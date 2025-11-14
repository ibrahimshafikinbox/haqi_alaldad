// cubit/booking_state.dart
import 'package:equatable/equatable.dart';
import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingFormValidating extends BookingState {}

class BookingSuccess extends BookingState {
  final BookingModel booking;
  final String message;

  const BookingSuccess({required this.booking, required this.message});

  @override
  List<Object?> get props => [booking, message];
}

class BookingError extends BookingState {
  final String message;
  final String? errorCode;

  const BookingError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class BookingValidationError extends BookingState {
  final Map<String, String> fieldErrors;

  const BookingValidationError({required this.fieldErrors});

  @override
  List<Object?> get props => [fieldErrors];
}

// Additional states for fetching bookings
class BookingsLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<BookingModel> bookings;

  const BookingsLoaded({required this.bookings});

  @override
  List<Object?> get props => [bookings];
}

class BookingUpdated extends BookingState {
  final BookingModel updatedBooking;
  final String message;

  const BookingUpdated({required this.updatedBooking, required this.message});

  @override
  List<Object?> get props => [updatedBooking, message];
}
