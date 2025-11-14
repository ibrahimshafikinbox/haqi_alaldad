import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  static CartCubit get(context) => BlocProvider.of<CartCubit>(context);

  CartCubit() : super(CartState(cartItems: [], total: 0));

  Future<void> loadCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDoc = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid);
    final docSnapshot = await cartDoc.get();

    if (docSnapshot.exists) {
      final cartData = docSnapshot.data()?['items'] ?? [];
      final cartItems = List<Map<String, dynamic>>.from(cartData);
      emit(
        state.copyWith(cartItems: cartItems, total: _calculateTotal(cartItems)),
      );
    }
  }

  Future<void> addToCart({
    required String id,
    required String name,
    required String image,
    required String description,
    required num price,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDoc = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid);
    final cartData = await cartDoc.get();
    List<Map<String, dynamic>> newItems = [];

    if (cartData.exists) {
      final currentItems = List<Map<String, dynamic>>.from(
        cartData.data()?['items'] ?? [],
      );
      newItems = List.from(currentItems);
      final index = newItems.indexWhere((item) => item['id'] == id);

      if (index != -1) {
        newItems[index]['quantity'] += 1;
      } else {
        newItems.add({
          'id': id,
          'name': name,
          'image': image,
          'description': description,
          'price': price,
          'quantity': 1,
        });
      }
    } else {
      newItems.add({
        'id': id,
        'name': name,
        'image': image,
        'description': description,
        'price': price,
        'quantity': 1,
      });
    }

    await cartDoc.set({'items': newItems});

    emit(state.copyWith(cartItems: newItems, total: _calculateTotal(newItems)));
  }

  Future<void> increaseQuantity(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDoc = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid);
    final cartData = await cartDoc.get();
    if (!cartData.exists) return;

    final newItems = List<Map<String, dynamic>>.from(
      cartData.data()?['items'] ?? [],
    );
    final index = newItems.indexWhere((item) => item['id'] == id);

    if (index != -1) {
      newItems[index]['quantity'] += 1;
      await cartDoc.set({'items': newItems});

      emit(
        state.copyWith(cartItems: newItems, total: _calculateTotal(newItems)),
      );
    }
  }

  Future<void> decreaseQuantity(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDoc = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid);
    final cartData = await cartDoc.get();
    if (!cartData.exists) return;

    final newItems = List<Map<String, dynamic>>.from(
      cartData.data()?['items'] ?? [],
    );
    final index = newItems.indexWhere((item) => item['id'] == id);

    if (index != -1) {
      if (newItems[index]['quantity'] > 1) {
        newItems[index]['quantity'] -= 1;
      } else {
        newItems.removeAt(index);
      }
      await cartDoc.set({'items': newItems});

      emit(
        state.copyWith(cartItems: newItems, total: _calculateTotal(newItems)),
      );
    }
  }

  Future<void> deleteItem(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDoc = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid);
    final cartData = await cartDoc.get();
    if (!cartData.exists) return;

    final newItems = List<Map<String, dynamic>>.from(
      cartData.data()?['items'] ?? [],
    );
    newItems.removeWhere((item) => item['id'] == id);

    await cartDoc.set({'items': newItems});

    emit(state.copyWith(cartItems: newItems, total: _calculateTotal(newItems)));
  }

  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDoc = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid);

    await cartDoc.delete();
    emit(CartState(cartItems: [], total: 0));
  }

  num _calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold<num>(
      0,
      (total, item) => total + (item['price'] * item['quantity']),
    );
  }
}
