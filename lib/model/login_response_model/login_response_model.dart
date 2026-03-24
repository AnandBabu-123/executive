class LoginResponseModel {
  final int status;
  final String message;
  final LoginResult result;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.result,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json["status"],
      message: json["message"],
      result: LoginResult.fromJson(json["result"]),
    );
  }
}

class LoginResult {
  final String message;
  final int userId;
  final int otp;

  LoginResult({
    required this.message,
    required this.userId,
    required this.otp,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      message: json["message"],
      userId: json["user_id"],
      otp: json["otp"],
    );
  }
}