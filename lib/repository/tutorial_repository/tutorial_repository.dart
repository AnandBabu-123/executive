import '../../config/routes/app_url.dart';
import '../../model/tutorial_model/tutorial_model.dart';
import '../../network/dio_network/dio_client.dart';

class TutorialRepository {
  final DioClient dioClient;

  TutorialRepository(this.dioClient);

  Future<TutorialResponse> getTutorials() async {
    final response = await dioClient.get(AppUrl.tutorials);

    if (response == null) {
      throw Exception("No response from server");
    }

    if (response["status"] == 200) {
      return TutorialResponse.fromJson(response);
    } else {
      throw Exception(response["message"] ?? "Something went wrong");
    }
  }
}