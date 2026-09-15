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

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RevealOnScroll(
            id: 'experience-header',
            child: SectionHeader(
              label: 'Journey & Expertise',
              title: 'Experience & Milestones',
              subtitle:
                  'From academic foundations to shipping full-stack mobile '
                  'products professionally, one layer of the stack at a time.',
            ),
          ),

          const SizedBox(height: 64),

          experienceAsync.when(
            loading: () => const SizedBox(height: 240),
            error: (_, __) => Text(
              'Experience couldn\'t be loaded. Refresh the page to try again.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.error),
            ),
            data: (items) => ExperienceTimeline(
              children: [
                for (final (index, item) in items.indexed)
                  RevealOnScroll(
                    id: 'timeline-${item.id}',
                    delay: Duration(milliseconds: index * 120),
                    child: TimelineEntry(experience: item),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          const RevealOnScroll(
            id: 'competencies-panel',
            child: CompetenciesPanel(),
          ),
        ],
      ),
    );
  }
}
