
import '../../config/routes/app_url.dart';
import '../../model/profile_model/profile_model.dart';
import '../../network/dio_network/dio_client.dart';

class ProfileRepository {
  final DioClient dioClient;

  ProfileRepository(this.dioClient);

  Future<ProfileModel> getProfile() async {
    final response = await dioClient.get(
      AppUrl.getProfile,
    );

    if (response["status"] == 200) {
      return ProfileModel.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}