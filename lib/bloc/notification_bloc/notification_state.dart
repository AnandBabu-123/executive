import '../../model/notification_response/notification_response.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> list;
  final int unreadCount;

  NotificationLoaded({
    required this.list,
    required this.unreadCount,
  });
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}