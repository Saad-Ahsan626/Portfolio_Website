class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.githubUrl,
    this.liveUrl,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String githubUrl;
  final String? liveUrl;
  final String? imageUrl;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        techStack: List<String>.from(json['techStack'] as List),
        githubUrl: json['githubUrl'] as String,
        liveUrl: json['liveUrl'] as String?,
        imageUrl: json['imageUrl'] as String?,
      );
}
