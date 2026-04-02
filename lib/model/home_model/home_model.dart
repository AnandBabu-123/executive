class HomeModel {
  final String name;
  final String image;
  final int totalSubscriptions;
  final int monthlyEarnings;
  final int users;
  final int agents;
  final int tutorials;
  final int walletBalance;
  final List<RecentPayment> recentPayments;

  HomeModel({
    required this.name,
    required this.image,
    required this.totalSubscriptions,
    required this.monthlyEarnings,
    required this.users,
    required this.agents,
    required this.tutorials,
    required this.walletBalance,
    required this.recentPayments,
  });

  /// 🔥 Common Parser (handles int, String, double, null)
  static int parseToInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    if (value is double) return value.toInt();

    if (value is String) {
      return int.tryParse(value) ??
          double.tryParse(value)?.toInt() ??
          0;
    }

    return 0;
  }

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json["result"] != null && json["result"].isNotEmpty
        ? json["result"][0]
        : {};

    return HomeModel(
      name: data["full_name"] ?? "",
      image: data["image"] ?? "",

      totalSubscriptions: parseToInt(data["total_subscriptions"]),
      monthlyEarnings: parseToInt(data["monthly_earnings"]),
      users: parseToInt(data["users"]),
      agents: parseToInt(data["agents"]),
      tutorials: parseToInt(data["tutorials"]),
      walletBalance: parseToInt(data["wallet_balance"]),

      recentPayments: data["recent_payment"] != null
          ? List<RecentPayment>.from(
        data["recent_payment"].map((e) => RecentPayment.fromJson(e)),
      )
          : [],
    );
  }
}

class RecentPayment {
  final int amount;
  final String date;
  final String name;

  RecentPayment({
    required this.amount,
    required this.date,
    required this.name,
  });

  factory RecentPayment.fromJson(Map<String, dynamic> json) {
    return RecentPayment(
      amount: HomeModel.parseToInt(json["total_amount"]),
      date: json["created_on"] ?? "",
      name: json["name"] ?? "",
    );
  }
}