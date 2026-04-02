
import '../../config/routes/app_url.dart';
import '../../model/subscription_model/subscription_model.dart';
import '../../network/dio_network/dio_client.dart';

class SubscriptionsRepository {
  final DioClient dioClient;

  SubscriptionsRepository(this.dioClient);

  Future<SubscriptionResponse> getSubscriptions({
    int page = 1,
  }) async {
    final response = await dioClient.get(
      "${AppUrl.subscription}?page=$page&per_page=5",
    );

    /// 🔥 SAFE CHECK
    if (response == null) {
      throw Exception("No response from server");
    }
    /// 🔥 HANDLE STATUS SAFELY
    if (response["status"] == 200) {
      return SubscriptionResponse.fromJson(response);
    } else {
      throw Exception(response["message"] ?? "Something went wrong");
    }
  }
}