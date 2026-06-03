import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../providers/portfolio_provider.dart';
import '../../shared/widgets/section_label.dart';
import 'widgets/competencies_panel.dart';
import 'widgets/timeline_node.dart';

class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experienceAsync = ref.watch(experienceProvider);
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
            _SectionHeader(isMobile: isMobile),

            const SizedBox(height: AppSpacing.xl),

            // ── Timeline ─────────────────────────────────────────
            experienceAsync.when(
              loading: () => const _LoadingSkeleton(),
              error: (e, _) => _ErrorState(error: e.toString()),
              data: (items) => Column(
                children: items
                    .asMap()
                    .entries
                    .map(
                      (e) => TimelineNodeRow(
                        experience: e.value,
                        index: e.key,
                        isLast: e.key == items.length - 1,
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Core competencies ─────────────────────────────────
            const CompetenciesPanel(),
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
  const _SectionHeader({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const SectionLabel('Journey & Expertise')
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.3, end: 0, duration: 400.ms),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Experience & Milestones',
          style: (isMobile
                  ? AppTypography.headlineLgMobile
                  : AppTypography.display.copyWith(fontSize: 48))
              .copyWith(color: AppColors.onSurface),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate(delay: 150.ms).fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: AppSpacing.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'A technical chronicle of my evolution as a Flutter developer — '
            'from academic foundations to professional cross-platform engineering.',
            style: AppTypography.bodyLg
                .copyWith(color: AppColors.onSurfaceVariant),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading skeleton
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: i.isOdd
                    ? Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
                          duration: 1200.ms,
                          color: AppColors.primary.withOpacity(0.04),
                        )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: AppSpacing.md),
              const SizedBox(width: 14),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: i.isEven
                    ? Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
                          duration: 1200.ms,
                          color: AppColors.primary.withOpacity(0.04),
                        )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
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
            'Failed to load experience',
            style: AppTypography.bodyMd.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
