import '../../config/routes/app_url.dart';
import '../../model/user_model/blood_group_model.dart';
import '../../network/dio_network/dio_client.dart';

class BloodGroupRepository {
  final DioClient dioClient;
  BloodGroupRepository(this.dioClient);

  Future<List<BloodGroup>> getBloodGroups() async {
    final response = await dioClient.get(AppUrl.getBloodGroups);
    if (response["status"] == 200) {
      return (response["result"] as List).map((e) => BloodGroup.fromJson(e)).toList();
    } else {
      throw Exception(response["message"]);
    }
  }
}