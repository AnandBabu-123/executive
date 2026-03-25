import '../../config/routes/app_url.dart';
import '../../model/content_model/content_model.dart';
import '../../network/dio_network/dio_client.dart';

class TermsRepository {
  final DioClient dioClient;

  TermsRepository(this.dioClient);

  Future<ContentModel> getTerms() async {
    final response = await dioClient.get(AppUrl.terms);

    if (response["status"] == 200) {
      return ContentModel.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}