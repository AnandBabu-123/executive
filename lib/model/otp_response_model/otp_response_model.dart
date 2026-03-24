class OtpVerifyResponse {
  final int status;
  final String message;
  final List<UserData> result;

  OtpVerifyResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      status: json["status"],
      message: json["message"],
      result: (json["result"] as List)
          .map((e) => UserData.fromJson(e))
          .toList(),
    );
  }
}

class UserData {
  final int id;
  final String phone;
  final String name;
  final String email;
  final String accessToken;
  final String type;
  final String uniqueId;

  UserData({
    required this.id,
    required this.phone,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.type,
    required this.uniqueId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"] ?? 0,
      phone: json["phone"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      accessToken: json["access_token"] ?? "",
      type: json["type"] ?? "",
      uniqueId: json["unique_id"] ?? "",
    );
  }
}