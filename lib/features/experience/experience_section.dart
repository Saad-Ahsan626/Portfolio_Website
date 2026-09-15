import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/portfolio_provider.dart';
import '../../shared/widgets/reveal_on_scroll.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import 'widgets/competencies_panel.dart';
import 'widgets/timeline_node.dart';

class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experienceAsync = ref.watch(experienceProvider);
    final educationAsync = ref.watch(educationProvider);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RevealOnScroll(
            id: 'experience-header',
            child: SectionHeader(
              label: 'Journey & Expertise',
              title: 'Education & Experience',
              subtitle:
                  'From academic foundations to shipping full-stack mobile '
                  'products professionally, one layer of the stack at a time.',
            ),
          ),

          const SizedBox(height: 64),

          // ── Education ─────────────────────────────────────────
          _TimelineGroup(
            id: 'education',
            heading: 'Education',
            unit: ('DEGREE', 'DEGREES'),
            entries: educationAsync.whenData(
              (items) => [
                for (final item in items)
                  (
                    id: item.id,
                    entry: TimelineEntry(
                      title: item.title,
                      subtitle: item.institution,
                      duration: item.duration,
                      description: item.description,
                      tags: item.subjects,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          // ── Work experience ───────────────────────────────────
          _TimelineGroup(
            id: 'work',
            heading: 'Work Experience',
            unit: ('ROLE', 'ROLES'),
            entries: experienceAsync.whenData(
              (items) => [
                for (final item in items)
                  (
                    id: item.id,
                    entry: TimelineEntry(
                      title: item.role,
                      subtitle: item.company,
                      duration: item.duration,
                      description: item.description,
                      tags: item.techStack,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          // ── Core competencies ─────────────────────────────────
          const RevealOnScroll(
            id: 'competencies-panel',
            child: CompetenciesPanel(),
          ),
        ],
      ),
    );
  }
}

/// A ruled heading with an item count ("WORK EXPERIENCE ——— 02 ROLES")
/// followed by its own left-rail timeline.
class _TimelineGroup extends StatelessWidget {
  const _TimelineGroup({
    required this.id,
    required this.heading,
    required this.unit,
    required this.entries,
  });

  final String id;
  final String heading;

  /// Singular and plural label for the count.
  final (String, String) unit;
  final AsyncValue<List<({String id, TimelineEntry entry})>> entries;

  @override
  Widget build(BuildContext context) {
    final count = entries.valueOrNull?.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RevealOnScroll(
          id: '$id-heading',
          child: RuledHeading(
            heading,
            trailing: count == null
                ? null
                : '${count.toString().padLeft(2, '0')} '
                    '${count == 1 ? unit.$1 : unit.$2}',
          ),
        ),
        const SizedBox(height: 40),
        entries.when(
          loading: () => const SizedBox(height: 160),
          error: (_, __) => Text(
            '$heading couldn\'t be loaded. Refresh the page to try again.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.error),
          ),
          data: (items) => ExperienceTimeline(
            children: [
              for (final (index, item) in items.indexed)
                RevealOnScroll(
                  id: 'timeline-${item.id}',
                  delay: Duration(milliseconds: index * 120),
                  child: item.entry,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
