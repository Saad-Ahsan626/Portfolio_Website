import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/project_model.dart';
import '../../providers/portfolio_provider.dart';
import '../../shared/widgets/reveal_on_scroll.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import 'widgets/project_card.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RevealOnScroll(
            id: 'projects-header',
            child: SectionHeader(
              label: 'Selected Works',
              title: 'Engineering mobile products, from interface to infrastructure.',
              titleMaxWidth: 640,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          projectsAsync.when(
            loading: () => const _LoadingGrid(),
            error: (_, __) => const _ErrorState(),
            data: (projects) => _ProjectsGrid(projects: projects),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Responsive grid — auto-fit, minmax(300px, 1fr), 48px gap
// ─────────────────────────────────────────────────────────────────────────────
class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects});

  final List<ProjectModel> projects;

  static const double gap = AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.autoFitColumns(
          width: constraints.maxWidth,
          minItemWidth: 300,
          gap: gap,
          itemCount: projects.length,
        );
        final itemWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        Widget card(int index, {required bool fillHeight}) {
          final project = projects[index];
          return SizedBox(
            width: itemWidth,
            child: RevealOnScroll(
              id: 'project-card-${project.id}',
              delay: Duration(milliseconds: index * 120),
              child: ProjectCard(project: project, fillHeight: fillHeight),
            ),
          );
        }

        if (columns == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < projects.length; i++) ...[
                if (i > 0) const SizedBox(height: gap),
                card(i, fillHeight: false),
              ],
            ],
          );
        }

        // CSS grid rows stretch their items; IntrinsicHeight gives each row
        // the tallest card's height.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var start = 0; start < projects.length; start += columns) ...[
              if (start > 0) const SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = start;
                        i < start + columns && i < projects.length;
                        i++) ...[
                      if (i > start) const SizedBox(width: gap),
                      card(i, fillHeight: true),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading skeleton
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.autoFitColumns(
          width: constraints.maxWidth,
          minItemWidth: 300,
          gap: _ProjectsGrid.gap,
          itemCount: 3,
        );
        final itemWidth =
            (constraints.maxWidth - _ProjectsGrid.gap * (columns - 1)) / columns;
        return Wrap(
          spacing: _ProjectsGrid.gap,
          runSpacing: _ProjectsGrid.gap,
          children: List.generate(
            3,
            (_) => Container(
              width: itemWidth,
              height: 520,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(color: AppColors.hairline),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
                  duration: 1200.ms,
                  color: AppColors.onSurface.withValues(alpha: 0.04),
                ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Projects couldn\'t be loaded. Refresh the page to try again.',
      style: AppTypography.bodyMd.copyWith(color: AppColors.error),
    );
  }
}
