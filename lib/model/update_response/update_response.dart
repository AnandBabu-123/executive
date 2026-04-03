class UpdateResponse {
  final int status;
  final String message;
  final UpdateResult? result;

  UpdateResponse({
    required this.status,
    required this.message,
    this.result,
  });

  factory UpdateResponse.fromJson(Map<String, dynamic> json) {
    return UpdateResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? "",
      result: json['result'] != null
          ? UpdateResult.fromJson(json['result'])
          : null,
    );
  }
}

class UpdateResult {
  final String currentVersion;
  final String yourVersion;
  final String message;

  /// Optional fields (only for status 200)
  final bool? isLatest;
  final bool? compatible;

  UpdateResult({
    required this.currentVersion,
    required this.yourVersion,
    required this.message,
    this.isLatest,
    this.compatible,
  });

  factory UpdateResult.fromJson(Map<String, dynamic> json) {
    return UpdateResult(
      currentVersion: json['current_version'] ?? "",
      yourVersion: json['your_version'] ?? "",
      message: json['message'] ?? "",

      /// These may NOT come in 426 response
      isLatest: json['is_latest'],
      compatible: json['compatible'],
    );
  }
}