// cubit/admin_market_order_state.dart
import 'package:equatable/equatable.dart';
import '../models/market_order_model.dart';

abstract class AdminMarketOrderState extends Equatable {
  const AdminMarketOrderState();

  @override
  List<Object?> get props => [];
}

class AdminMarketOrderInitial extends AdminMarketOrderState {}

class AdminMarketOrderLoading extends AdminMarketOrderState {}

class AdminMarketOrderLoaded extends AdminMarketOrderState {
  final List<MarketOrderModel> orders;

  const AdminMarketOrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class AdminMarketOrderError extends AdminMarketOrderState {
  final String message;

  const AdminMarketOrderError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminMarketOrderUpdating extends AdminMarketOrderState {}

class AdminMarketOrderUpdated extends AdminMarketOrderState {
  final String message;

  const AdminMarketOrderUpdated(this.message);

  @override
  List<Object?> get props => [message];
}
