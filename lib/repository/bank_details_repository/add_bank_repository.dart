
import '../../config/routes/app_url.dart';
import '../../network/dio_network/api_exception.dart';
import '../../network/dio_network/dio_client.dart';

class AddBankRepository {
  final DioClient dioClient;

  AddBankRepository(this.dioClient);

  Future<void> addBankDetails(Map<String, dynamic> body) async {
    final response = await dioClient.post(
      AppUrl.bankDetails,
      data: body,
    );

    if (response["status"] != 200) {
      throw ApiException(response["message"] ?? "Failed to add bank");
    }
  }
}