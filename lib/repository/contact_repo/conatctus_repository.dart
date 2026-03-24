
import '../../config/routes/app_url.dart';
import '../../config/session_manager/session_manager.dart';
import '../../model/conatct_response_model/contact_response_model.dart';
import '../../network/dio_network/dio_client.dart';

class ContactUsRepository {
  final DioClient dioClient;

  ContactUsRepository(this.dioClient);

  Future<ContactResponse> contactUs({
    required String name,
    required String email,
    required String mobile,
    required String message,
  }) async {
    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken(); // optional print

    final body = {
      "user_id": userId,
      "name": name,
      "email": email,
      "mobile": mobile,
      "message": message,
    };

    /// ✅ PRINT REQUEST DATA
    print("📤 CONTACT API REQUEST");
    print("➡️ URL: ${AppUrl.contactUs}");
    print("👤 USER ID: $userId");
    print("🔐 TOKEN: $token");
    print("📦 BODY: $body");

    final response = await dioClient.post(
      AppUrl.contactUs,
      data: body,
    );

    /// ✅ PRINT RESPONSE
    print("📥 RESPONSE: $response");

    if (response["status"] == 200) {
      return ContactResponse.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}