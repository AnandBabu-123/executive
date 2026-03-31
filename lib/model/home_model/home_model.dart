class HomeModel {
  final String name;
  final String image;
  final int totalSubscriptions;
  final String monthlyEarnings;
  final int users;
  final int agents;
  final int tutorials;
  final String walletBalance;
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

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json["result"][0];

    return HomeModel(
      name: data["full_name"] ?? "",
      image: data["image"] ?? "",
      totalSubscriptions: data["total_subscriptions"] ?? 0,
      monthlyEarnings: data["monthly_earnings"] ?? "0",
      users: data["users"] ?? 0,
      agents: data["agents"] ?? 0,
      tutorials: data["tutorials"] ?? 0,
      walletBalance: data["wallet_balance"] ?? "0",
      recentPayments: (data["recent_payment"] as List)
          .map((e) => RecentPayment.fromJson(e))
          .toList(),
    );
  }
}

class RecentPayment {
  final String amount;
  final String date;
  final String name;

  RecentPayment({
    required this.amount,
    required this.date,
    required this.name,
  });

  factory RecentPayment.fromJson(Map<String, dynamic> json) {
    return RecentPayment(
      amount: json["total_amount"],
      date: json["created_on"],
      name: json["name"],
    );
  }
}