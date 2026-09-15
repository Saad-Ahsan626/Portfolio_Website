class EducationModel {
  const EducationModel({
    required this.id,
    required this.title,
    required this.institution,
    required this.duration,
    required this.description,
    required this.subjects,
  });

  final String id;

  /// Card heading, e.g. "Computer Science Student".
  final String title;
  final String institution;

  /// Display string, e.g. "2024 — 2028".
  final String duration;
  final String description;

  /// Course subjects shown as tags.
  final List<String> subjects;

  factory EducationModel.fromJson(Map<String, dynamic> json) => EducationModel(
        id: json['id'] as String,
        title: json['title'] as String,
        institution: json['institution'] as String,
        duration: json['duration'] as String,
        description: json['description'] as String,
        subjects: List<String>.from(json['subjects'] as List),
      );
}
