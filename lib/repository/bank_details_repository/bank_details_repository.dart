
import '../../config/routes/app_url.dart';
import '../../model/bank_model/bank_model.dart';
import '../../network/dio_network/dio_client.dart';

class BankDetailsRepository {
  final DioClient dioClient;

  BankDetailsRepository(this.dioClient);

  Future<List<BankModel>> getBankDetails() async {
    final response = await dioClient.get(AppUrl.bankDetails);

    if (response["status"] == 200) {
      List data = response["result"];
      return data.map((e) => BankModel.fromJson(e)).toList();
    } else {
      throw response["message"];
    }
  }
}