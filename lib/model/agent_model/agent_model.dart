class Agent {
  final int id;
  final String type;
  final String uniqueId;
  final String name;
  final String mobile;
  final String email;
  final String? gst;
  final String? tds;
  final String image;
  final String gender;
  final String dob;
  final String occupation;

  // ✅ NEW FIELD
  final SubscriptionData? subscriptionData;

  Agent({
    required this.id,
    required this.type,
    required this.uniqueId,
    required this.name,
    required this.mobile,
    required this.email,
    this.gst,
    this.tds,
    required this.image,
    required this.gender,
    required this.dob,
    required this.occupation,
    this.subscriptionData,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      type: json['type'],
      uniqueId: json['unique_id'],
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
      gst: json['gst'],
      tds: json['tds'],
      image: json['image'] ?? "",
      gender: json['gender'] ?? "",
      dob: json['dob'] ?? "",
      occupation: json['occupation'] ?? "",

      // ✅ PARSE SUBSCRIPTION DATA
      subscriptionData: json['subscription_data'] is Map<String, dynamic>
          ? SubscriptionData.fromJson(json['subscription_data'])
          : null,
    );
  }
}

class SubscriptionData {
  final int totalSubscription;
  final int totalFamilySubscription;
  final int totalSingleSubscription;

  SubscriptionData({
    required this.totalSubscription,
    required this.totalFamilySubscription,
    required this.totalSingleSubscription,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      totalSubscription: json['total_subscription'] ?? 0,
      totalFamilySubscription: json['total_family_subscription'] ?? 0,
      totalSingleSubscription: json['total_single_subscription'] ?? 0,
    );
  }
}

class AgentPagination {
  final int currentPage;
  final int lastPage;
  final List<Agent> data;
  final String? nextPageUrl;

  AgentPagination({
    required this.currentPage,
    required this.lastPage,
    required this.data,
    this.nextPageUrl,
  });

  factory AgentPagination.fromJson(Map<String, dynamic> json) {
    return AgentPagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      data: (json['data'] as List)
          .map((e) => Agent.fromJson(e))
          .toList(),
      nextPageUrl: json['next_page_url'],
    );
  }
}