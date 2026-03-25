import '../../config/routes/app_url.dart';
import '../../model/content_model/content_model.dart';
import '../../network/dio_network/dio_client.dart';

class PrivacyRepository {
  final DioClient dioClient;

  PrivacyRepository(this.dioClient);

  Future<ContentModel> getPrivacy() async {
    final response = await dioClient.get(AppUrl.privacy);

    if (response["status"] == 200) {
      return ContentModel.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}