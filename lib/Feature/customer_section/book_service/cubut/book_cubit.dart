// // cubit/booking_cubit.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_state.dart';

// class BookingCubit extends Cubit<BookingState> {
//   final BookingRepository _repository;

//   BookingCubit({required BookingRepository repository})
//     : _repository = repository,
//       super(BookingInitial());

//   // Validation helper
//   Map<String, String> _validateBookingForm({
//     required String customerName,
//     required String customerPhone,
//     required DateTime? bookingDate,
//     required TimeOfDay? bookingTime,
//   }) {
//     Map<String, String> errors = {};

//     if (customerName.trim().isEmpty) {
//       errors['name'] = 'Name is required';
//     } else if (customerName.trim().length < 2) {
//       errors['name'] = 'Name must be at least 2 characters';
//     }

//     if (customerPhone.trim().isEmpty) {
//       errors['phone'] = 'Phone number is required';
//     } else if (customerPhone.trim().length < 10) {
//       errors['phone'] = 'Phone number must be at least 10 digits';
//     }

//     if (bookingDate == null) {
//       errors['date'] = 'Booking date is required';
//     } else if (bookingDate.isBefore(
//       DateTime.now().subtract(const Duration(days: 1)),
//     )) {
//       errors['date'] = 'Booking date cannot be in the past';
//     }

//     if (bookingTime == null) {
//       errors['time'] = 'Booking time is required';
//     }

//     return errors;
//   }

//   // Create booking with validation
//   Future<void> createBooking({
//     required dynamic service,
//     required String customerName,
//     required String customerPhone,
//     required DateTime bookingDate,
//     required TimeOfDay bookingTime,
//     required String notes,
//     required String userId,
//   }) async {
//     emit(BookingFormValidating());

//     // Validate form
//     final errors = _validateBookingForm(
//       customerName: customerName,
//       customerPhone: customerPhone,
//       bookingDate: bookingDate,
//       bookingTime: bookingTime,
//     );

//     if (errors.isNotEmpty) {
//       emit(BookingValidationError(fieldErrors: errors));
//       return;
//     }

//     emit(BookingLoading());

//     try {
//       final booking = BookingModel(
//         serviceId: service.id ?? 'unknown',
//         serviceName: service.name ?? 'Unknown Service',
//         servicePrice: (service.price ?? 0).toDouble(),
//         serviceImage: service.imageUrl ?? '',
//         customerName: customerName.trim(),
//         customerPhone: customerPhone.trim(),
//         bookingDate: bookingDate,
//         bookingTime:
//             '${bookingTime.hour.toString().padLeft(2, '0')}:${bookingTime.minute.toString().padLeft(2, '0')}',
//         notes: notes.trim(),
//         status: 'pending',
//         userId: userId,
//         createdAt: DateTime.now(),
//       );

//       final bookingId = await _repository.createBooking(booking);
//       final createdBooking = booking.copyWith(id: bookingId);

//       emit(
//         BookingSuccess(
//           booking: createdBooking,
//           message: 'Your service has been booked successfully!',
//         ),
//       );
//     } catch (e) {
//       emit(
//         BookingError(
//           message: 'Failed to book service. Please try again.',
//           errorCode: 'BOOKING_FAILED',
//         ),
//       );
//     }
//   }

//   // Get user bookings
//   Future<void> getUserBookings(String userId) async {
//     emit(BookingsLoading());

//     try {
//       final bookings = await _repository.getUserBookings(userId);
//       emit(BookingsLoaded(bookings: bookings));
//     } catch (e) {
//       emit(
//         BookingError(
//           message: 'Failed to load bookings.',
//           errorCode: 'FETCH_FAILED',
//         ),
//       );
//     }
//   }

//   // Get bookings by status
//   Future<void> getBookingsByStatus(String userId, String status) async {
//     emit(BookingsLoading());

//     try {
//       final bookings = await _repository.getBookingsByStatus(userId, status);
//       emit(BookingsLoaded(bookings: bookings));
//     } catch (e) {
//       emit(
//         BookingError(
//           message: 'Failed to load bookings.',
//           errorCode: 'FETCH_FAILED',
//         ),
//       );
//     }
//   }

//   // Update booking status
//   Future<void> updateBookingStatus(String bookingId, String status) async {
//     emit(BookingLoading());

//     try {
//       await _repository.updateBookingStatus(bookingId, status);

//       final updatedBooking = await _repository.getBookingById(bookingId);
//       if (updatedBooking != null) {
//         emit(
//           BookingUpdated(
//             updatedBooking: updatedBooking,
//             message: 'Booking status updated successfully',
//           ),
//         );
//       }
//     } catch (e) {
//       emit(
//         BookingError(
//           message: 'Failed to update booking status.',
//           errorCode: 'UPDATE_FAILED',
//         ),
//       );
//     }
//   }

//   // Cancel booking
//   Future<void> cancelBooking(String bookingId) async {
//     await updateBookingStatus(bookingId, 'cancelled');
//   }

//   // Get single booking
//   Future<void> getBookingById(String bookingId) async {
//     emit(BookingLoading());

//     try {
//       final booking = await _repository.getBookingById(bookingId);
//       if (booking != null) {
//         emit(BookingsLoaded(bookings: [booking]));
//       } else {
//         emit(
//           const BookingError(
//             message: 'Booking not found.',
//             errorCode: 'NOT_FOUND',
//           ),
//         );
//       }
//     } catch (e) {
//       emit(
//         BookingError(
//           message: 'Failed to load booking.',
//           errorCode: 'FETCH_FAILED',
//         ),
//       );
//     }
//   }

//   // Listen to bookings stream
//   void listenToUserBookings(String userId) {
//     _repository
//         .getUserBookingsStream(userId)
//         .listen(
//           (bookings) {
//             emit(BookingsLoaded(bookings: bookings));
//           },
//           onError: (error) {
//             emit(
//               BookingError(
//                 message: 'Failed to load bookings.',
//                 errorCode: 'STREAM_ERROR',
//               ),
//             );
//           },
//         );
//   }

//   // Reset state
//   void resetState() {
//     emit(BookingInitial());
//   }
// }

// class BookingRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _collection = 'service_bookings';

//   // Create new booking
//   Future<String> createBooking(BookingModel booking) async {
//     try {
//       DocumentReference docRef = await _firestore
//           .collection(_collection)
//           .add(booking.toMap());
//       return docRef.id;
//     } catch (e) {
//       throw Exception('Failed to create booking: ${e.toString()}');
//     }
//   }

//   // Get user bookings
//   Future<List<BookingModel>> getUserBookings(String userId) async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection(_collection)
//           .where('userId', isEqualTo: userId)
//           .orderBy('createdAt', descending: true)
//           .get();

//       return querySnapshot.docs
//           .map((doc) => BookingModel.fromFirestore(doc))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to fetch bookings: ${e.toString()}');
//     }
//   }

//   // Get booking by ID
//   Future<BookingModel?> getBookingById(String bookingId) async {
//     try {
//       DocumentSnapshot doc = await _firestore
//           .collection(_collection)
//           .doc(bookingId)
//           .get();

//       if (doc.exists) {
//         return BookingModel.fromFirestore(doc);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to fetch booking: ${e.toString()}');
//     }
//   }

//   // Update booking status
//   Future<void> updateBookingStatus(String bookingId, String status) async {
//     try {
//       await _firestore.collection(_collection).doc(bookingId).update({
//         'status': status,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception('Failed to update booking status: ${e.toString()}');
//     }
//   }

//   // Update entire booking
//   Future<void> updateBooking(String bookingId, BookingModel booking) async {
//     try {
//       await _firestore.collection(_collection).doc(bookingId).update({
//         ...booking.toMap(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception('Failed to update booking: ${e.toString()}');
//     }
//   }

//   // Delete booking
//   Future<void> deleteBooking(String bookingId) async {
//     try {
//       await _firestore.collection(_collection).doc(bookingId).delete();
//     } catch (e) {
//       throw Exception('Failed to delete booking: ${e.toString()}');
//     }
//   }

//   // Get bookings by status
//   Future<List<BookingModel>> getBookingsByStatus(
//     String userId,
//     String status,
//   ) async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection(_collection)
//           .where('userId', isEqualTo: userId)
//           .where('status', isEqualTo: status)
//           .orderBy('createdAt', descending: true)
//           .get();

//       return querySnapshot.docs
//           .map((doc) => BookingModel.fromFirestore(doc))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to fetch bookings by status: ${e.toString()}');
//     }
//   }

//   // Get bookings stream for real-time updates
//   Stream<List<BookingModel>> getUserBookingsStream(String userId) {
//     return _firestore
//         .collection(_collection)
//         .where('userId', isEqualTo: userId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => BookingModel.fromFirestore(doc))
//               .toList(),
//         );
//   }
// }
// cubit/booking_cubit.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';
import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _repository;

  BookingCubit({required BookingRepository repository})
    : _repository = repository,
      super(BookingInitial());

  Map<String, String> _validateBookingForm({
    required String customerName,
    required String customerPhone,
    required DateTime? bookingDate,
    required TimeOfDay? bookingTime,
    required String? location,
  }) {
    final errors = <String, String>{};

    if (customerName.trim().isEmpty) {
      errors['name'] = 'Name is required';
    } else if (customerName.trim().length < 2) {
      errors['name'] = 'Name must be at least 2 characters';
    }

    if (customerPhone.trim().isEmpty) {
      errors['phone'] = 'Phone number is required';
    } else if (customerPhone.trim().length < 7) {
      errors['phone'] = 'Phone number looks too short';
    }

    if (bookingDate == null) {
      errors['date'] = 'Booking date is required';
    } else if (bookingDate.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    )) {
      errors['date'] = 'Booking date cannot be in the past';
    }

    if (bookingTime == null) {
      errors['time'] = 'Booking time is required';
    }

    if (location == null || location.trim().isEmpty) {
      errors['location'] = 'Location is required';
    }

    return errors;
  }

  Future<void> createBooking({
    required dynamic service,
    required String customerName,
    required String customerPhone,
    required DateTime bookingDate,
    required TimeOfDay bookingTime,
    required String notes,
    required String userId,
    required String location,
  }) async {
    emit(BookingFormValidating());

    final errors = _validateBookingForm(
      customerName: customerName,
      customerPhone: customerPhone,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      location: location,
    );

    if (errors.isNotEmpty) {
      emit(BookingValidationError(fieldErrors: errors));
      return;
    }

    emit(BookingLoading());

    try {
      final booking = BookingModel(
        id: null,
        serviceId: service?.id ?? 'unknown',
        serviceName: service?.name ?? 'Unknown Service',
        servicePrice: (service?.price ?? 0).toDouble(),
        serviceImage: service?.imageUrl ?? '',
        customerName: customerName.trim(),
        customerPhone: customerPhone.trim(),
        bookingDate: bookingDate,
        bookingTime:
            '${bookingTime.hour.toString().padLeft(2, '0')}:${bookingTime.minute.toString().padLeft(2, '0')}',
        notes: notes.trim(),
        status: 'pending',
        userId: userId,
        createdAt: DateTime.now(),
        location: location.trim(), // NEW
      );

      final bookingId = await _repository.createBooking(booking);
      final createdBooking = booking.copyWith(id: bookingId);

      emit(
        BookingSuccess(
          booking: createdBooking,
          message: 'Your service has been booked successfully!',
        ),
      );
    } catch (e) {
      emit(
        BookingError(
          message: 'Failed to book service. Please try again.',
          errorCode: 'BOOKING_FAILED',
        ),
      );
    }
  }

  Future<void> getUserBookings(String userId) async {
    emit(BookingsLoading());
    try {
      final bookings = await _repository.getUserBookings(userId);
      emit(BookingsLoaded(bookings: bookings));
    } catch (e) {
      emit(
        BookingError(
          message: 'Failed to load bookings.',
          errorCode: 'FETCH_FAILED',
        ),
      );
    }
  }

  Future<void> getBookingsByStatus(String userId, String status) async {
    emit(BookingsLoading());
    try {
      final bookings = await _repository.getBookingsByStatus(userId, status);
      emit(BookingsLoaded(bookings: bookings));
    } catch (e) {
      emit(
        BookingError(
          message: 'Failed to load bookings.',
          errorCode: 'FETCH_FAILED',
        ),
      );
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    emit(BookingLoading());
    try {
      await _repository.updateBookingStatus(bookingId, status);
      final updatedBooking = await _repository.getBookingById(bookingId);
      if (updatedBooking != null) {
        emit(
          BookingUpdated(
            updatedBooking: updatedBooking,
            message: 'Booking status updated successfully',
          ),
        );
      }
    } catch (e) {
      emit(
        BookingError(
          message: 'Failed to update booking status.',
          errorCode: 'UPDATE_FAILED',
        ),
      );
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    await updateBookingStatus(bookingId, 'cancelled');
  }

  Future<void> getBookingById(String bookingId) async {
    emit(BookingLoading());
    try {
      final booking = await _repository.getBookingById(bookingId);
      if (booking != null) {
        emit(BookingsLoaded(bookings: [booking]));
      } else {
        emit(
          const BookingError(
            message: 'Booking not found.',
            errorCode: 'NOT_FOUND',
          ),
        );
      }
    } catch (e) {
      emit(
        BookingError(
          message: 'Failed to load booking.',
          errorCode: 'FETCH_FAILED',
        ),
      );
    }
  }

  void listenToUserBookings(String userId) {
    _repository
        .getUserBookingsStream(userId)
        .listen(
          (bookings) => emit(BookingsLoaded(bookings: bookings)),
          onError: (_) => emit(
            BookingError(
              message: 'Failed to load bookings.',
              errorCode: 'STREAM_ERROR',
            ),
          ),
        );
  }

  void resetState() => emit(BookingInitial());
}

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'service_bookings';

  Future<String> createBooking(BookingModel booking) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(booking.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create booking: ${e.toString()}');
    }
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final qs = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return qs.docs.map((d) => BookingModel.fromFirestore(d)).toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings: ${e.toString()}');
    }
  }

  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(bookingId).get();
      if (doc.exists) return BookingModel.fromFirestore(doc);
      return null;
    } catch (e) {
      throw Exception('Failed to fetch booking: ${e.toString()}');
    }
  }
  // داخل BookingRepository (أضف هذه الدالة)

  Stream<List<BookingModel>> getAllBookingsStream() {
    // كل الحجوزات مرتبة بالأحدث
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => BookingModel.fromFirestore(d)).toList(),
        );
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update booking status: ${e.toString()}');
    }
  }

  Future<void> updateBooking(String bookingId, BookingModel booking) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        ...booking.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update booking: ${e.toString()}');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).delete();
    } catch (e) {
      throw Exception('Failed to delete booking: ${e.toString()}');
    }
  }

  Future<List<BookingModel>> getBookingsByStatus(
    String userId,
    String status,
  ) async {
    try {
      final qs = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();
      return qs.docs.map((d) => BookingModel.fromFirestore(d)).toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings by status: ${e.toString()}');
    }
  }

  Stream<List<BookingModel>> getUserBookingsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => BookingModel.fromFirestore(d)).toList(),
        );
  }
}
