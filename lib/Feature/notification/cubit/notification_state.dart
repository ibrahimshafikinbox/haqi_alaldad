// notification_state.dart
import '../models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;

  NotificationLoaded({required this.notifications, required this.unreadCount});
}

class NotificationError extends NotificationState {
  final String error;
  NotificationError(this.error);
}

class NotificationMarkingRead extends NotificationState {}
