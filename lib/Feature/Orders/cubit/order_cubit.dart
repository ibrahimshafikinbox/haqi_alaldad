import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Feature/Orders/cubit/order_state.dart'
    show
        OrderState,
        OrdersInitial,
        OrdersLoading,
        OrdersLoaded,
        OrdersError,
        OrderCreating,
        OrderCreated,
        OrderActionError,
        OrderUpdating,
        OrderUpdated,
        OrderDeleting,
        OrderDeleted,
        OrderConverting,
        OrderConverted;
import 'package:store_mangment/Feature/Orders/model/order_model.dart'
    show CetOrder;

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrdersInitial());

  final _db = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  List<CetOrder> _currentOrders = [];

  static const String collectionName = 'cet_orders';

  /// Starts listening to the whole collection.
  void subscribeToOrders() {
    emit(OrdersLoading());
    _sub?.cancel();
    _sub = _db
        .collection(collectionName)
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((snapshot) {
          _currentOrders = snapshot.docs
              .map((doc) => CetOrder.fromDoc(doc))
              .toList(growable: false);
          emit(OrdersLoaded(_currentOrders));
        }, onError: (e) => emit(OrdersError(e.toString())));
  }

  /// Creates a new order. If the order type is **market** and
  /// `autoConvertMarketToVet` is true, the order is instantly converted
  /// to a vet order.
  Future<void> createOrder({
    required String petName,
    required String petOwner,
    required String petType,
    required String serviceType,
    required double serviceCharge,
    required String paymentStatus,
    required String serviceStatus,
    required String orderType, // 'vet' or 'market'
    bool autoConvertMarketToVet = true,
  }) async {
    try {
      emit(OrderCreating());

      final order = CetOrder(
        id: '',
        petName: petName,
        petOwner: petOwner,
        petType: petType,
        serviceType: serviceType,
        serviceCharge: serviceCharge,
        paymentStatus: paymentStatus,
        serviceStatus: serviceStatus,
        orderType: orderType,
        convertedFromMarket: false,
      );

      final ref = await _db.collection(collectionName).add(order.toCreateMap());

      // Auto‑convert market → vet if requested
      if (orderType.toLowerCase() == 'market' && autoConvertMarketToVet) {
        await convertMarketOrderToVet(ref.id, silent: true);
      }

      emit(OrderCreated(ref.id));
    } catch (e) {
      emit(OrderActionError('Failed to create order: $e'));
    }
  }

  /// Update an existing order.
  Future<void> updateOrder({
    required String id,
    required CetOrder updated,
  }) async {
    try {
      emit(OrderUpdating());
      await _db
          .collection(collectionName)
          .doc(id)
          .update(updated.toUpdateMap());
      emit(OrderUpdated());
    } catch (e) {
      emit(OrderActionError('Failed to update order: $e'));
    }
  }

  /// Delete an order.
  Future<void> deleteOrder(String id) async {
    try {
      emit(OrderDeleting());
      await _db.collection(collectionName).doc(id).delete();
      emit(OrderDeleted());
    } catch (e) {
      emit(OrderActionError('Failed to delete order: $e'));
    }
  }

  /// Convert a **market** order to a **vet** order.
  /// If `silent` is true the UI won’t receive a converting/converted state
  /// (used when conversion happens automatically on creation).
  Future<void> convertMarketOrderToVet(String id, {bool silent = false}) async {
    try {
      if (!silent) emit(OrderConverting());

      final docRef = _db.collection(collectionName).doc(id);
      final snap = await docRef.get();
      final data = snap.data() as Map<String, dynamic>?;

      if (data == null) throw 'Order not found';

      // If it’s already a vet order we’re done.
      if ((data['order_type'] ?? 'vet').toString().toLowerCase() == 'vet') {
        if (!silent) emit(OrderConverted());
        return;
      }

      await docRef.update({
        'order_type': 'vet',
        'converted_from_market': true,
        'converted_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      if (!silent) emit(OrderConverted());
    } catch (e) {
      if (!silent) emit(OrderActionError('Failed to convert order: $e'));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
