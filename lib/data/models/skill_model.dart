class SkillModel {
  const SkillModel({
    required this.id,
    required this.name,
    required this.category,
  });

  final String id;
  final String name;
  final String category;

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
      );
}
