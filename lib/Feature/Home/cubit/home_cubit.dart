// // home_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// part 'home_state.dart';

// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeInitial());

//   void loadData() async {
//     emit(HomeLoading());

//     try {
//       final categories = await _fetchCategories();
//       final customerCount = await _fetchMarketCustomerCount();

//       emit(HomeLoaded(categories: categories, customerCount: customerCount));
//     } catch (e) {
//       emit(HomeError(message: e.toString()));
//     }
//   }

//   Future<List<Map<String, String>>> _fetchCategories() async {
//     final snapshot =
//         await FirebaseFirestore.instance.collection('app_categories').get();

//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return {
//         'name': data['name']?.toString() ?? 'Unknown',
//         'emoji': data['emoji']?.toString() ?? '❓',
//       };
//     }).toList();
//   }

//   Future<int> _fetchMarketCustomerCount() async {
//     final snapshot = await FirebaseFirestore.instance.collection('users').get();
//     return snapshot.size;
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadData() async {
    emit(HomeLoading());

    try {
      // Ensure default categories exist
      await _ensureDefaultCategoriesExist();

      final categories = await _fetchCategories();
      final customerCount = await _fetchMarketCustomerCount();

      emit(HomeLoaded(categories: categories, customerCount: customerCount));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  /// Ensure default categories (Cats & Dogs) exist in Firestore
  Future<void> _ensureDefaultCategoriesExist() async {
    final db = FirebaseFirestore.instance;
    final categoriesRef = db.collection('app_categories');

    try {
      final snapshot = await categoriesRef.get();

      // If categories collection is empty, add default categories
      if (snapshot.docs.isEmpty) {
        await _addDefaultCategories();
      }
    } catch (e) {
      print('Error checking categories: $e');
      rethrow;
    }
  }

  /// Add default categories (Cats & Dogs) to Firestore
  Future<void> _addDefaultCategories() async {
    final db = FirebaseFirestore.instance;
    final batch = db.batch();

    final categories = [
      {
        'name': 'Cats',
        'emoji': '🐱',
        'description': 'Veterinary services for cats',
        'imageUrl':
            'https://images.unsplash.com/photo-1574158622682-e40e69881006?q=80&w=600&auto=format&fit=crop',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Dogs',
        'emoji': '🐕',
        'description': 'Veterinary services for dogs',
        'imageUrl':
            'https://images.unsplash.com/photo-1633722715463-d30628519d00?q=80&w=600&auto=format&fit=crop',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var category in categories) {
      final docRef = db.collection('app_categories').doc();
      batch.set(docRef, category);
    }

    await batch.commit();
  }

  Future<List<Map<String, String>>> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('app_categories')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name']?.toString() ?? 'Unknown',
        'emoji': data['emoji']?.toString() ?? '❓',
        'description': data['description']?.toString() ?? '',
        'imageUrl': data['imageUrl']?.toString() ?? '',
      };
    }).toList();
  }

  Future<int> _fetchMarketCustomerCount() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.size;
  }
}
