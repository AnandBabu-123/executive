
import '../../config/routes/app_url.dart';
import '../../model/notification_response/notification_response.dart';
import '../../network/dio_network/dio_client.dart';

class NotificationRepository {
  final DioClient dioClient;

  NotificationRepository(this.dioClient);

  Future<NotificationResponse> getNotifications({int? id}) async {
    final response = await dioClient.get(
      id != null
          ? "${AppUrl.notification}?id=$id"
          : AppUrl.notification,
    );

    if (response == null) {
      throw Exception("No response");
    }

    if (response["status"] == 200) {
      return NotificationResponse.fromJson(response);
    } else {
      throw Exception(response["message"] ?? "Error");
    }
  }
}