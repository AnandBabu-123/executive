abstract class NotificationEvent {}

class FetchNotifications extends NotificationEvent {}

class ClearAllNotifications extends NotificationEvent {}

class MarkNotificationRead extends NotificationEvent {
  final int id;

  MarkNotificationRead(this.id);
}