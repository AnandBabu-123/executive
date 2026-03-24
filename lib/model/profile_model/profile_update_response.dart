class UpdateProfileResponse {
  final int status;
  final String message;

  UpdateProfileResponse({
    required this.status,
    required this.message,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      status: json["status"],
      message: json["message"] ?? "",
    );
  }
}