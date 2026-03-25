class AboutModel {
  final int id;
  final String name;

  AboutModel({
    required this.id,
    required this.name,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    final result = json["result"];

    return AboutModel(
      id: result["id"] ?? 0,
      name: result["name"] ?? "",
    );
  }
}