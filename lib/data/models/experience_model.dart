class ExperienceModel {
  const ExperienceModel({
    required this.id,
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
    required this.techStack,
  });

  final String id;
  final String role;
  final String company;

  /// Display string, e.g. "Sep 2026 — Present".
  final String duration;
  final String description;
  final List<String> techStack;

  factory ExperienceModel.fromJson(Map<String, dynamic> json) => ExperienceModel(
        id: json['id'] as String,
        role: json['role'] as String,
        company: json['company'] as String,
        duration: json['duration'] as String,
        description: json['description'] as String,
        techStack: List<String>.from(json['techStack'] as List),
      );
}
