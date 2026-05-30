class ExperienceModel {
  const ExperienceModel({
    required this.id,
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
    required this.techStack,
    this.isCurrent = false,
    this.icon = 'work',        
  });

  final String id;
  final String role;
  final String company;
  final String duration;
  final String description;
  final List<String> techStack;
  final bool isCurrent;
  final String icon;           

  factory ExperienceModel.fromJson(Map<String, dynamic> json) => ExperienceModel(
        id: json['id'] as String,
        role: json['role'] as String,
        company: json['company'] as String,
        duration: json['duration'] as String,
        description: json['description'] as String,
        techStack: List<String>.from(json['techStack'] as List),
        isCurrent: json['isCurrent'] as bool? ?? false,
        icon: json['icon'] as String? ?? 'work',   
      );
}