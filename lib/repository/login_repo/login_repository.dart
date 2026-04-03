
import '../../config/routes/app_url.dart';
import '../../model/login_response_model/login_response_model.dart';
import '../../network/dio_network/api_exception.dart';
import '../../network/dio_network/dio_client.dart';

import '../../config/routes/app_url.dart';
import '../../model/login_response_model/login_response_model.dart';
import '../../network/dio_network/api_exception.dart';
import '../../network/dio_network/dio_client.dart';

class LoginRepository {
  final DioClient dioClient;

  LoginRepository(this.dioClient);

  Future<LoginResponseModel> login({
    required String phone,
  }) async {
    final body = {
      "phone": phone,
    };

    final response = await dioClient.post(
      AppUrl.login,
      data: body,
    );

    print("LOGIN RAW RESPONSE: $response");
    print("TYPE: ${response.runtimeType}");

    /// ✅ SAFETY CHECK
    if (response is! Map) {
      throw ApiException("Invalid response format");
    }

    /// ✅ CONVERT HERE ONLY ONCE
    final Map<String, dynamic> data =
    Map<String, dynamic>.from(response);

    print("CONVERTED DATA: $data");

    /// ✅ API STATUS CHECK
    if (data["status"] == 200) {
      return LoginResponseModel.fromJson(data);
    } else {
      throw ApiException(
        data["message"]?.toString() ?? "Login Failed",
      );
    }
  }
}