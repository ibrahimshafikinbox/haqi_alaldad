// lib/Feature/orders/cubit/order_state.dart
import 'package:store_mangment/Feature/Orders/model/order_model.dart';

abstract class OrderState {}

class OrdersInitial extends OrderState {}

class OrdersLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<CetOrder> orders;
  OrdersLoaded(this.orders);
}

class OrdersError extends OrderState {
  final String message;
  OrdersError(this.message);
}

// Action states – useful for snackbars / UI feedback
class OrderCreating extends OrderState {}

class OrderCreated extends OrderState {
  final String orderId;
  OrderCreated(this.orderId);
}

class OrderUpdating extends OrderState {}

class OrderUpdated extends OrderState {}

class OrderConverting extends OrderState {}

class OrderConverted extends OrderState {}

class OrderDeleting extends OrderState {}

class OrderDeleted extends OrderState {}

class OrderActionError extends OrderState {
  final String message;
  OrderActionError(this.message);
}
