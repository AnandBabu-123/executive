
import '../../config/routes/app_url.dart';
import '../../model/user_model/blood_group_model.dart';
import '../../network/dio_network/dio_client.dart';

class CategoryRepository {
  final DioClient dioClient;
  CategoryRepository(this.dioClient);

  Future<List<Category>> getCategories() async {
    final response = await dioClient.get(AppUrl.getCategories);
    if (response["status"] == 200) {
      return (response["result"] as List).map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception(response["message"]);
    }
  }
}