
import '../../config/routes/app_url.dart';
import '../../model/otp_response_model/otp_response_model.dart';
import '../../network/dio_network/dio_client.dart';

class OtpRepository {
  final DioClient dioClient;

  OtpRepository(this.dioClient);

  Future<OtpVerifyResponse> verifyOtp({
    required int userId,
    required String otp,
  }) async {
    final body = {
      "user_id": userId,
      "otp": otp,
    };

    final response = await dioClient.post(
      AppUrl.otpVerify,
      data: body,
    );

    if (response == null) {
      throw Exception("Null response");
    }

    if (response["status"] == 200) {
      return OtpVerifyResponse.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}