import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';

class UpdateBankRepository {
  final DioClient dioClient;

  UpdateBankRepository(this.dioClient);

  Future<void> updateBankDetails(int id, Map<String, dynamic> body) async {
    print("🔹 UPDATE BANK REQUEST");
    print("URL: ${AppUrl.bankDetails}/$id");
    print("BODY: $body");
    final response = await dioClient.put(

      "${AppUrl.bankDetails}/$id", // ✅ keep ID
      data: body,
    );
    print("🔹 UPDATE BANK RESPONSE");
    print(response);
    if (response["status"] != 200) {
      throw Exception(response["message"]);
    }
  }
}