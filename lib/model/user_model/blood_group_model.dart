class BloodGroup {
  final int id;
  final String name;

  BloodGroup({required this.id, required this.name});

  factory BloodGroup.fromJson(Map<String, dynamic> json) {
    return BloodGroup(id: json["id"], name: json["name"]);
  }
}
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json["id"], name: json["name"]);
  }
}