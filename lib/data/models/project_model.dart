class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.githubUrl,
    this.liveUrl,
    this.imageUrl,
    this.featured = false,
  });

  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String githubUrl;
  final String? liveUrl;
  final String? imageUrl;
  final bool featured;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        techStack: List<String>.from(json['techStack'] as List),
        githubUrl: json['githubUrl'] as String,
        liveUrl: json['liveUrl'] as String?,
        imageUrl: json['imageUrl'] as String?,
        featured: json['featured'] as bool? ?? false,
      );
}
