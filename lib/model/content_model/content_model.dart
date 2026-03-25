class ContentModel {
  final int id;
  final String name;

  ContentModel({
    required this.id,
    required this.name,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json["result"]["id"],
      name: json["result"]["name"],
    );
  }
}