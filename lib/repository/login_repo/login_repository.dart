
import '../../config/routes/app_url.dart';
import '../../model/login_response_model/login_response_model.dart';
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

    if (response == null) {
      throw Exception("Null response");
    }

    print(response);
    if (response["status"] == 200) {
      return LoginResponseModel.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}