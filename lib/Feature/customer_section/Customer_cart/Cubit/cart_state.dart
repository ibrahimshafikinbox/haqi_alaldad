part of 'cart_cubit.dart';

class CartState {
  final List<Map<String, dynamic>> cartItems;
  final num total;

  CartState({
    required this.cartItems,
    required this.total,
  });

  // Add copyWith method for easier state updates
  CartState copyWith({
    List<Map<String, dynamic>>? cartItems,
    num? total,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      total: total ?? this.total,
    );
  }
}
