
import '../../config/routes/app_url.dart';
import '../../model/wallet_model/withdraw_response.dart';
import '../../network/dio_network/dio_client.dart';

class WalletWithdrawRepository {
  final DioClient dioClient;

  WalletWithdrawRepository(this.dioClient);

  Future<WalletWithdrawResponse> walletWithdraw({
    required int userId,
    required String amount,
  }) async {
    final response = await dioClient.post(
      AppUrl.walletWithDraw,
      data: {
        "user_id": userId,
        "amount": amount,
      },
    );

    if (response["status"] == 200) {
      return WalletWithdrawResponse.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}