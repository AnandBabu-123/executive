class WalletWithdrawResponse {
  final int status;
  final String message;

  WalletWithdrawResponse({
    required this.status,
    required this.message,
  });

  factory WalletWithdrawResponse.fromJson(Map<String, dynamic> json) {
    return WalletWithdrawResponse(
      status: json["status"],
      message: json["message"],
    );
  }
}