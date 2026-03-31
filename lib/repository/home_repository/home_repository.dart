import '../../config/routes/app_url.dart';
import '../../model/home_model/home_model.dart';
import '../../network/dio_network/dio_client.dart';

class HomeRepository {
  final DioClient dioClient;

  HomeRepository(this.dioClient);

  Future<HomeModel> getHomeData() async {
    final response = await dioClient.get(AppUrl.homeData);

    if (response["status"] == 200) {
      return HomeModel.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}