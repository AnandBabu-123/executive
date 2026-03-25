import '../../config/routes/app_url.dart';
import '../../model/about_model/about_model.dart';
import '../../network/dio_network/dio_client.dart';

class AboutRepository {
  final DioClient dioClient;

  AboutRepository(this.dioClient);

  Future<AboutModel> getAbout() async {
    final response = await dioClient.get(AppUrl.about);

    if (response["status"] == 200) {
      return AboutModel.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}