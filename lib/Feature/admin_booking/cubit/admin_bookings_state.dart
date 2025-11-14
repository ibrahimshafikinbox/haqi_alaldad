import 'package:equatable/equatable.dart';
import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';

abstract class AdminBookingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminBookingsInitial extends AdminBookingsState {}

class AdminBookingsLoading extends AdminBookingsState {}

class AdminBookingsLoaded extends AdminBookingsState {
  final List<BookingModel> all; // جميع الحجوزات من Firestore
  final List<BookingModel> filtered; // نتائج البحث/الفلترة
  final String query;
  final String statusFilter; // all/pending/approved/declined/cancelled

  AdminBookingsLoaded({
    required this.all,
    required this.filtered,
    required this.query,
    required this.statusFilter,
  });

  AdminBookingsLoaded copyWith({
    List<BookingModel>? all,
    List<BookingModel>? filtered,
    String? query,
    String? statusFilter,
  }) {
    return AdminBookingsLoaded(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  @override
  List<Object?> get props => [all, filtered, query, statusFilter];
}

class AdminBookingsError extends AdminBookingsState {
  final String message;
  AdminBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminBookingUpdating extends AdminBookingsState {}

class AdminBookingUpdated extends AdminBookingsState {
  final String message;
  AdminBookingUpdated(this.message);

  @override
  List<Object?> get props => [message];
}
