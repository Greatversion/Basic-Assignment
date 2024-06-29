class VideoDetails {
  final int? id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;

  VideoDetails({
    this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  // Convert a VideoDetails object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
    };
  }

  // Create a VideoDetails object from a JSON map
  factory VideoDetails.fromJson(Map<String, dynamic> json) {
    return VideoDetails(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      videoUrl: json['video_url'] as String,
    );
  }
}
