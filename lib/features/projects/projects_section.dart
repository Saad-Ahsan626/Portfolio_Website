import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../providers/portfolio_provider.dart';
import '../../shared/widgets/section_label.dart';
import 'widgets/project_card.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    final horizontalPadding = isDesktop
        ? AppSpacing.xl
        : isMobile
            ? AppSpacing.md
            : AppSpacing.lg;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSpacing.containerMax),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ───────────────────────────────────
            _SectionHeader(),

            const SizedBox(height: AppSpacing.lg),

            // ── Projects grid ────────────────────────────────────
            projectsAsync.when(
              loading: () => const _LoadingGrid(),
              error: (e, _) => _ErrorState(error: e.toString()),
              data: (projects) => _ProjectsGrid(
                projects: projects,
                isMobile: isMobile,
                isDesktop: isDesktop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Selected Works')
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: -0.3, end: 0, duration: 400.ms),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Crafting seamless digital\nexperiences with Flutter.',
          style: (Responsive.isMobile(context)
                  ? AppTypography.headlineLgMobile
                  : AppTypography.headlineLg)
              .copyWith(color: AppColors.onSurface),
        ).animate(delay: 150.ms).fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Responsive grid
// ─────────────────────────────────────────────────────────────────────────────
class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({
    required this.projects,
    required this.isMobile,
    required this.isDesktop,
  });

  final List projects;
  final bool isMobile;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    // columns: mobile=1, tablet=2, desktop=3
    final crossAxisCount = isMobile
        ? 1
        : isDesktop
            ? 3
            : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.lg,
        crossAxisSpacing: AppSpacing.lg,
        // Card height grows with content — use childAspectRatio tuned per breakpoint
        childAspectRatio: isMobile
            ? 0.75
            : isDesktop
                ? 0.62
                : 0.68,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => ProjectCard(
        project: projects[index],
        animationDelay: Duration(milliseconds: index * 100),
      ),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.lg,
        crossAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.62,
      ),
      itemCount: 3,
      itemBuilder: (_, __) => _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.glassBorder),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
          duration: 1200.ms,
          color: AppColors.primary.withOpacity(0.04),
        );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Failed to load projects',
            style: AppTypography.bodyMd.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
