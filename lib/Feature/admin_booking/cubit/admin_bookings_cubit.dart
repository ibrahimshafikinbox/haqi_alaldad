import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';
import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_cubit.dart';
import 'package:store_mangment/Feature/notification/models/notification_model.dart';
import 'package:store_mangment/Feature/notification/repo/notifications_repository.dart';
import 'admin_bookings_state.dart';

class AdminBookingsCubit extends Cubit<AdminBookingsState> {
  final BookingRepository bookingRepository;
  final NotificationsRepository notificationsRepository;
  StreamSubscription<List<BookingModel>>? _sub;

  AdminBookingsCubit({
    required this.bookingRepository,
    required this.notificationsRepository,
  }) : super(AdminBookingsInitial());

  void listenAllBookings() {
    emit(AdminBookingsLoading());
    // نجلب كل الحجوزات بدون تقييد uid (هذه شاشة إدمن)
    _sub?.cancel();
    _sub = bookingRepository
        .getAllBookingsStream() // نضيفها في الريبو
        .listen(
          (bookings) {
            final loaded = AdminBookingsLoaded(
              all: bookings,
              filtered: bookings,
              query: '',
              statusFilter: 'all',
            );
            emit(loaded);
          },
          onError: (e) {
            emit(AdminBookingsError('Failed to load bookings'));
          },
        );
  }

  void applyQuery(String query) {
    final current = state;
    if (current is! AdminBookingsLoaded) return;

    final q = query.trim().toLowerCase();
    final filtered = current.all.where((b) {
      final name = b.customerName.toLowerCase();
      final phone = b.customerPhone.toLowerCase();
      final service = b.serviceName.toLowerCase();
      final status = b.status.toLowerCase();
      return name.contains(q) ||
          phone.contains(q) ||
          service.contains(q) ||
          status.contains(q);
    }).toList();

    emit(
      current.copyWith(
        filtered: _applyStatusFilter(filtered, current.statusFilter),
        query: query,
      ),
    );
  }

  void applyStatusFilter(String status) {
    final current = state;
    if (current is! AdminBookingsLoaded) return;

    final filteredBase = current.query.isEmpty
        ? current.all
        : current.all.where((b) {
            final q = current.query.toLowerCase();
            return b.customerName.toLowerCase().contains(q) ||
                b.customerPhone.toLowerCase().contains(q) ||
                b.serviceName.toLowerCase().contains(q) ||
                b.status.toLowerCase().contains(q);
          }).toList();

    final filtered = _applyStatusFilter(filteredBase, status);

    emit(current.copyWith(filtered: filtered, statusFilter: status));
  }

  List<BookingModel> _applyStatusFilter(
    List<BookingModel> list,
    String status,
  ) {
    if (status == 'all') return list;
    return list
        .where((b) => b.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  Future<void> updateStatus({
    required String bookingId,
    required String newStatus, // approved / declined
    String? adminNote,
  }) async {
    try {
      emit(AdminBookingUpdating());
      await bookingRepository.updateBookingStatus(bookingId, newStatus);

      // احضر الحجز بعد التحديث للحصول على userId
      final updated = await bookingRepository.getBookingById(bookingId);
      if (updated != null) {
        // أرسل إشعار إلى صاحب الحجز
        final notif = AppNotification(
          userId: updated.userId,
          title: newStatus == 'approved' ? 'تم اعتماد حجزك' : 'تم رفض حجزك',
          body: adminNote?.isNotEmpty == true
              ? adminNote!
              : (newStatus == 'approved'
                    ? 'تم اعتماد الحجز للخدمة: ${updated.serviceName}.'
                    : 'تم رفض الحجز للخدمة: ${updated.serviceName}.'),
          bookingId: bookingId,
          status: newStatus,
          createdAt: DateTime.now(),
        );
        await notificationsRepository.sendNotification(notif);
      }

      emit(AdminBookingUpdated('Booking $newStatus successfully'));
      // بعد نجاح التحديث، أعد تحميل القائمة عبر الاشتراك القائم أصلاً
      // (الستريم سيحدث الحالة تلقائياً)
    } catch (e) {
      emit(AdminBookingsError('Failed to update status'));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
