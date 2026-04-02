class Tutorial {
  final String title;
  final String videoUrl;
  final String duration;
  final String description;

  Tutorial({
    required this.title,
    required this.videoUrl,
    required this.duration,
    required this.description,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      title: json["title"] ?? "",
      videoUrl: json["video_url"] ?? "",
      duration: json["duration"] ?? "",
      description: json["description"] ?? "",
    );
  }
}

class TutorialResponse {
  final List<Tutorial> tutorials;

  TutorialResponse({required this.tutorials});

  factory TutorialResponse.fromJson(Map<String, dynamic> json) {
    final result = json["result"];

    if (result == null || result is! List) {
      return TutorialResponse(tutorials: []);
    }

    return TutorialResponse(
      tutorials: List<Tutorial>.from(
        result.map((e) => Tutorial.fromJson(e)),
      ),
    );
  }
}