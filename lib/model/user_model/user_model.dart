class User {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final String dob;
  final int bloodGroupId;
  final String bloodGroupName;
  final int coverageCategoryId;
  final String coverageCategoryName;
  final String image;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.dob,
    required this.bloodGroupId,
    required this.bloodGroupName,
    required this.coverageCategoryId,
    required this.coverageCategoryName,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      mobile: json["mobile"].toString(),
      gender: json["gender"] ?? "",
      dob: json["dob"] ?? "",
      bloodGroupId: json["blood_group"] ?? 0,
      bloodGroupName: json["blood_group_name"] ?? "",
      coverageCategoryId: json["coverage_category"] ?? 0,
      coverageCategoryName: json["coverage_category_name"] ?? "",
      image: json["image"] ?? "",
    );
  }
}

class PaginatedUserResponse {
  final int currentPage;
  final int lastPage;
  final List<User> data;

  PaginatedUserResponse({
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory PaginatedUserResponse.fromJson(Map<String, dynamic> json) {
    final result = json["result"][0];
    final dataList = (result["data"] as List).map((e) => User.fromJson(e)).toList();
    return PaginatedUserResponse(
      currentPage: result["current_page"],
      lastPage: result["last_page"],
      data: dataList,
    );
  }
}