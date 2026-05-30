import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/experience_model.dart';
import '../data/models/project_model.dart';
import '../data/models/skill_model.dart';
import '../data/repositories/portfolio_repository.dart';

final portfolioRepositoryProvider = Provider<PortfolioRepository>(
  (_) => PortfolioRepository(),
);

final projectsProvider = FutureProvider<List<ProjectModel>>((ref) {
  return ref.watch(portfolioRepositoryProvider).fetchProjects();
});

final experienceProvider = FutureProvider<List<ExperienceModel>>((ref) {
  return ref.watch(portfolioRepositoryProvider).fetchExperience();
});

final skillsProvider = FutureProvider<List<SkillModel>>((ref) {
  return ref.watch(portfolioRepositoryProvider).fetchSkills();
});
