import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/providers/contact_form_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Portfolio content', () {
    final repository = PortfolioRepository();

    test('projects.json parses into complete case studies', () async {
      final projects = await repository.fetchProjects();

      expect(projects, isNotEmpty);
      expect(projects.map((p) => p.id).toSet().length, projects.length,
          reason: 'project ids are URL slugs and must be unique');

      for (final project in projects) {
        expect(project.id, matches(RegExp(r'^[a-z0-9-]+$')),
            reason: '${project.id} must be URL-safe');
        expect(project.techStack, isNotEmpty);
        expect(project.facts, isNotEmpty);
        expect(project.architecture, isNotEmpty);
        expect(project.features, isNotEmpty);
        expect(project.screens, isNotEmpty);
        expect(project.headline.trim(), isNotEmpty);
        expect(project.challenge.trim(), isNotEmpty);
        expect(project.approach.trim(), isNotEmpty);
      }
    });

    test('experience.json lists roles newest first', () async {
      final experience = await repository.fetchExperience();

      expect(experience, isNotEmpty);
      expect(experience.first.duration, contains('Present'));
      expect(experience.first.role, 'Full-Stack Mobile Engineer');
    });

    test('skills.json parses', () async {
      final skills = await repository.fetchSkills();
      expect(skills.map((s) => s.name), containsAll(['Flutter', 'NestJS', 'System Design']));
    });
  });

  group('Contact form validation', () {
    late ProviderContainer container;
    late ContactFormNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(contactFormProvider.notifier);
    });

    tearDown(() => container.dispose());

    ContactFormState state() => container.read(contactFormProvider);

    test('hides errors while typing until the first submit', () {
      notifier.updateEmail('not-an-email');
      expect(state().emailError, isNull);
      expect(state().filledCount, 1);
    });

    test('validate flags every missing field', () {
      expect(notifier.validate(), isFalse);
      expect(state().nameError, isNotNull);
      expect(state().emailError, isNotNull);
      expect(state().messageError, isNotNull);
    });

    test('errors clear live once fields become valid', () {
      notifier.validate();

      notifier.updateName('Ada Lovelace');
      notifier.updateEmail('ada@example.com');
      notifier.updateMessage('I would like to build a mobile app.');

      expect(state().nameError, isNull);
      expect(state().emailError, isNull);
      expect(state().messageError, isNull);
      expect(state().isValid, isTrue);
      expect(state().filledCount, 3);
    });

    test('rejects malformed email and too-short message', () {
      expect(ContactFormNotifier.validateEmail('ada@'), isNotNull);
      expect(ContactFormNotifier.validateEmail('ada+work@example.co'), isNull);
      expect(ContactFormNotifier.validateMessage('Hi'), isNotNull);
    });
  });
}
