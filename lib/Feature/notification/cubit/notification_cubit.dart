// notification_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Feature/notification/repo/notifications_repository.dart';
import 'notification_state.dart';
import '../models/notification_model.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationsRepository _repository;
  StreamSubscription? _notificationsSubscription;

  NotificationCubit(this._repository) : super(NotificationInitial());

  // جلب إشعارات المستخدم
  void loadUserNotifications(String userId) {
    emit(NotificationLoading());

    _notificationsSubscription?.cancel();
    _notificationsSubscription = _repository
        .getUserNotificationsStream(userId)
        .listen(
          (notifications) {
            final unreadCount = notifications.where((n) => !n.read).length;
            emit(
              NotificationLoaded(
                notifications: notifications,
                unreadCount: unreadCount,
              ),
            );
          },
          onError: (error) {
            emit(NotificationError(error.toString()));
          },
        );
  }

  // تعليم الإشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // تعليم كل الإشعارات كمقروءة
  Future<void> markAllAsRead(List<AppNotification> notifications) async {
    try {
      for (var notif in notifications.where((n) => !n.read)) {
        await _repository.markAsRead(notif.id!);
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
