import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_label.dart';
import 'widgets/hero_visual.dart';
import 'widgets/skill_chip.dart';
import 'widgets/stat_card.dart';
import 'widgets/typing_text.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  static const _typingTexts = [
    "Hi, I'm a Mobile App Developer",
    "I build Flutter applications",
    "I craft seamless UX experiences",
    "I turn ideas into products",
  ];

  static const _skillChips = [
    (label: 'Flutter', icon: Icons.flutter_dash),
    (label: 'Dart', icon: Icons.terminal),
    (label: 'Firebase', icon: Icons.cloud),
    (label: 'Riverpod', icon: Icons.layers),
    (label: 'REST APIs', icon: Icons.api),
  ];

  static const _stats = [
    (value: '50+', label: 'Apps Deployed'),
    (value: '99%', label: 'Crash-Free Rate'),
    (value: '4+', label: 'Years Exp.'),
    (value: '12', label: 'Open Source'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero ──────────────────────────────────────────────
            _HeroRow(
              isMobile: isMobile,
              isDesktop: isDesktop,
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Stats divider ──────────────────────────────────────
            _StatsRow(stats: _stats, isMobile: isMobile),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Row
// ─────────────────────────────────────────────────────────────────────────────
class _HeroRow extends StatelessWidget {
  const _HeroRow({required this.isMobile, required this.isDesktop});

  final bool isMobile;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final content = _HeroContent(isMobile: isMobile);
    final visual = const HeroVisual();

    if (isMobile) {
      // Stack vertically — visual on top, content below
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 280,
            child: visual,
          ),
          const SizedBox(height: AppSpacing.lg),
          content,
        ],
      );
    }

    // Desktop / Tablet: side by side
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: content),
        const SizedBox(width: AppSpacing.xl),
        Expanded(flex: 4, child: visual),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Content (left column)
// ─────────────────────────────────────────────────────────────────────────────
class _HeroContent extends StatelessWidget {
  const _HeroContent({this.isMobile = false});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Available badge
        Align(
          alignment: isMobile ? Alignment.center : Alignment.centerLeft,
          child: const SectionLabel('Available for work')
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.3, end: 0, duration: 400.ms),
        ),

        const SizedBox(height: AppSpacing.md),

        // Typing headline
        SizedBox(
          height: Responsive.isMobile(context) ? 80 : 100,
          child: const TypingText(
            texts: HomeSection._typingTexts,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

        const SizedBox(height: AppSpacing.md),

        // Subheading
        Text(
          'I craft high-performance, visually stunning cross-platform '
          'applications using Flutter. My focus is on technical precision '
          'and creating seamless digital experiences.',
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),

        const SizedBox(height: AppSpacing.lg),

        // CTA Buttons
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            PrimaryButton(
              label: 'View My Work',
              icon: Icons.arrow_downward_rounded,
              onPressed: () {},
            ),
            GhostButton(
              label: 'Download Resume',
              icon: Icons.download_rounded,
              onPressed: () {},
            ),
          ],
        ).animate(delay: 600.ms).fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),

        const SizedBox(height: AppSpacing.lg),

        // Skill chips
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: HomeSection._skillChips
              .asMap()
              .entries
              .map(
                (e) => SkillChip(label: e.value.label, icon: e.value.icon)
                    .animate(delay: Duration(milliseconds: 800 + e.key * 100))
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: -0.2, end: 0, duration: 300.ms),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats, required this.isMobile});

  final List<({String value, String label})> stats;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: isMobile
          ? GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.lg,
              crossAxisSpacing: AppSpacing.lg,
              childAspectRatio: 2.5,
              children: _buildStatCards(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildStatCards(),
            ),
    );
  }

  List<Widget> _buildStatCards() {
    return stats
        .asMap()
        .entries
        .map(
          (e) => StatCard(
            value: e.value.value,
            label: e.value.label,
            delay: Duration(milliseconds: 1000 + e.key * 150),
          ),
        )
        .toList();
  }
}
