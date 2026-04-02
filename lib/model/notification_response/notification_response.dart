class AppNotification {
  final int id;
  final String title;
  final String message;
  final int readStatus;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.readStatus,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      readStatus: json["read_status"] ?? 0,
    );
  }

  /// 🔥 REQUIRED FOR BLOC UPDATE
  AppNotification copyWith({
    int? id,
    String? title,
    String? message,
    int? readStatus,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      readStatus: readStatus ?? this.readStatus,
    );
  }
}

class NotificationResponse {
  final List<AppNotification> notifications;
  final int unreadCount;

  NotificationResponse({
    required this.notifications,
    required this.unreadCount,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final result = json["result"];

    /// 🔥 HANDLE NULL / EMPTY {}
    if (result == null || result is! Map) {
      return NotificationResponse(
        notifications: [],
        unreadCount: 0,
      );
    }

    return NotificationResponse(
      notifications: (result["notifications"] as List? ?? [])
          .map((e) => AppNotification.fromJson(e))
          .toList(),

      /// 🔥 SAFE INT PARSE
      unreadCount: result["unread_count"] is int
          ? result["unread_count"]
          : int.tryParse(result["unread_count"]?.toString() ?? "0") ?? 0,
    );
  }
}