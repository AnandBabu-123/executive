
import '../../config/routes/app_url.dart';
import '../../model/wallet_model/wallet_model.dart';
import '../../network/dio_network/dio_client.dart';

class WalletRepository {
  final DioClient dioClient;

  WalletRepository(this.dioClient);

  Future<WalletResponse> getWallet({
    required int userId,
    int page = 1,
  }) async {
    final response = await dioClient.get(
      "${AppUrl.getWallet}?user_id=$userId&transaction_type=all&per_page=10&page=$page",
    );

    if (response["status"] == 200) {
      return WalletResponse.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}