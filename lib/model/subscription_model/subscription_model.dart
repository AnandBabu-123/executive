class SubscriptionResponse {
  final int currentPage;
  final int lastPage;
  final List<Subscription> data;

  SubscriptionResponse({
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    final result = json["result"];

    /// 🔥 HANDLE ALL BAD CASES
    if (result == null || result is! Map) {
      return SubscriptionResponse(
        currentPage: 1,
        lastPage: 1,
        data: [],
      );
    }

    /// 🔥 SAFE EXTRACTION
    final dynamic currentPageRaw = result["current_page"];
    final dynamic lastPageRaw = result["last_page"];
    final dynamic dataRaw = result["data"];

    return SubscriptionResponse(
      currentPage: currentPageRaw is int
          ? currentPageRaw
          : int.tryParse(currentPageRaw?.toString() ?? "") ?? 1,

      lastPage: lastPageRaw is int
          ? lastPageRaw
          : int.tryParse(lastPageRaw?.toString() ?? "") ?? 1,

      data: dataRaw is List
          ? dataRaw.map((e) {
        if (e is Map<String, dynamic>) {
          return Subscription.fromJson(e);
        } else {
          return Subscription.empty(); // 🔥 fallback
        }
      }).toList()
          : [],
    );
  }
}
class Subscription {
  final String name;
  final String plan;
  final String amount;
  final String date;
  final String time;
  final String userImage;

  Subscription({
    required this.name,
    required this.plan,
    required this.amount,
    required this.date,
    required this.time,
    required this.userImage,
  });

  /// 🔥 EMPTY SAFE OBJECT
  factory Subscription.empty() {
    return Subscription(
      name: "",
      plan: "",
      amount: "0",
      date: "",
      time: "",
        userImage:"",
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      name: json["user_name"]?.toString() ?? "",
      plan: json["subscription_name"]?.toString() ?? "",
      amount: json["total_amount"]?.toString() ?? "0",
      date: json["date_only"]?.toString() ?? "",
      time: json["time_only"]?.toString() ?? "",
      userImage: json["user_image"]?.toString() ?? "",

    );
  }
}