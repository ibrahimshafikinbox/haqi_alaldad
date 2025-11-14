import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/cubit/customer_home_state.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/models/categories_model.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/models/product_model.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/models/vet_service.dart';

class CustomerHomeCubit extends Cubit<CustomerHomeState> {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _categoriesSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _servicesSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _productsSub;

  static const defaultImageUrl =
      'https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=600&auto=format&fit=crop';

  CustomerHomeCubit({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _db = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance,
      super(CustomerHomeState.initial());

  void initialize() {
    _subscribeUser();
    _subscribeCategories();
    _subscribeServices();
    _subscribeProducts();
  }

  void _subscribeUser() {
    final uid = _auth.currentUser?.uid ?? 'guest';
    emit(state.copyWith(isLoadingUser: true));

    _userSub?.cancel();
    _userSub = _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
          (doc) {
            if (doc.exists) {
              final data = doc.data()!;
              final name = (data['firstName'] ?? 'Guest').toString();
              final image = (data['profileImage'] ?? defaultImageUrl)
                  .toString();
              emit(
                state.copyWith(
                  isLoadingUser: false,
                  name: name,
                  imageUrl: image,
                  clearError: true,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  isLoadingUser: false,
                  name: 'Guest',
                  imageUrl: defaultImageUrl,
                  clearError: true,
                ),
              );
            }
          },
          onError: (e) {
            print('❌ User Error: $e');
            emit(
              state.copyWith(
                isLoadingUser: false,
                error: 'Failed to load user data',
              ),
            );
          },
        );
  }

  void _subscribeCategories() {
    emit(state.copyWith(isLoadingCategories: true));

    _categoriesSub?.cancel();
    _categoriesSub = _db
        .collection('app_categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snap) {
            if (snap.docs.isNotEmpty) {
              final list = snap.docs.map(AppCategory.fromDoc).toList();
              emit(
                state.copyWith(
                  isLoadingCategories: false,
                  categories: list,
                  clearError: true,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  isLoadingCategories: false,
                  categories: [],
                  clearError: true,
                ),
              );
            }
          },
          onError: (e) {
            print('❌ Categories Error: $e');
            emit(
              state.copyWith(
                isLoadingCategories: false,
                error: 'Failed to load categories',
              ),
            );
          },
        );
  }

  void _subscribeServices() {
    emit(state.copyWith(isLoadingServices: true));

    _servicesSub?.cancel();
    _servicesSub = _db
        .collection('vet_services')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snap) {
            if (snap.docs.isNotEmpty) {
              final list = snap.docs.map(VetService.fromDoc).toList();
              emit(
                state.copyWith(
                  isLoadingServices: false,
                  services: list,
                  clearError: true,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  isLoadingServices: false,
                  services: [],
                  clearError: true,
                ),
              );
            }
          },
          onError: (e) {
            print('❌ Services Error: $e');
            emit(
              state.copyWith(
                isLoadingServices: false,
                error: 'Failed to load services',
              ),
            );
          },
        );
  }

  void _subscribeProducts() {
    emit(state.copyWith(isLoadingProducts: true));

    _productsSub?.cancel();

    // ✅ جلب المنتجات بدون orderBy (لتجنب Index)
    _productsSub = _db
        .collectionGroup('products')
        .limit(100) // 👈 نجلب 100 منتج كحد أقصى
        .snapshots()
        .listen(
          (snap) {
            print('📊 Products snapshot received: ${snap.docs.length} items');

            if (snap.docs.isEmpty) {
              emit(
                state.copyWith(
                  isLoadingProducts: false,
                  products: [],
                  clearError: true,
                ),
              );
              return;
            }

            // ✅ تحويل البيانات وفلترتها
            var list = snap.docs
                .map(Product.fromDoc)
                .where((p) => p.id.isNotEmpty && p.name.isNotEmpty)
                .toList();

            print('✅ Valid products before sorting: ${list.length}');

            // ✅ الترتيب يدوياً في Dart (بدلاً من Firestore)
            list.sort((a, b) {
              // لو أحد المنتجات مافيه تاريخ، نخليه في الآخر
              if (a.createdAt == null) return 1;
              if (b.createdAt == null) return -1;

              // ترتيب تنازلي (الأحدث أولاً)
              return b.createdAt!.compareTo(a.createdAt!);
            });

            print('✅ Products after sorting: ${list.length}');

            emit(
              state.copyWith(
                isLoadingProducts: false,
                products: list,
                clearError: true,
              ),
            );
          },
          onError: (e) {
            print('❌ Products Error: $e');
            emit(
              state.copyWith(
                isLoadingProducts: false,
                error: 'Failed to load products',
              ),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    _categoriesSub?.cancel();
    _servicesSub?.cancel();
    _productsSub?.cancel();
    return super.close();
  }
}
