import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../models/skill_model.dart';

class PortfolioRepository {
  Future<List<ProjectModel>> fetchProjects() async {
    final raw = await rootBundle.loadString('assets/data/projects.json');
    final list = json.decode(raw) as List;
    return list
        .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ExperienceModel>> fetchExperience() async {
    final raw = await rootBundle.loadString('assets/data/experience.json');
    final list = json.decode(raw) as List;
    return list
        .map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SkillModel>> fetchSkills() async {
    final raw = await rootBundle.loadString('assets/data/skills.json');
    final list = json.decode(raw) as List;
    return list
        .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
