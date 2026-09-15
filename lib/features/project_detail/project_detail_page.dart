import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/router/app_router.dart';
import '../../core/router/section_navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/project_model.dart';
import '../../providers/portfolio_provider.dart';
import '../../providers/scroll_provider.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/hover_card.dart';
import '../../shared/widgets/hover_link.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../projects/widgets/phone_mockup.dart';
import '../shell/widgets/mobile_drawer.dart';
import '../shell/widgets/nav_bar.dart';
import '../shell/widgets/site_footer.dart';

/// Case study for one project — `/projects/:id`.
class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MobileDrawer(activeOverride: SectionIndex.projects),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(NavBar.heightFor(context)),
        child: const NavBar(
          activeOverride: SectionIndex.projects,
          showProgress: false,
        ),
      ),
      body: projectsAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const _Message(
          title: 'Case study unavailable',
          body: 'Projects couldn\'t be loaded. Refresh the page to try again.',
        ),
        data: (projects) {
          final index = projects.indexWhere((p) => p.id == projectId);
          if (index < 0) {
            return const _Message(
              title: 'Project not found',
              body: 'This case study doesn\'t exist or has moved.',
            );
          }
          return _CaseStudy(projects: projects, index: index);
        },
      ),
    );
  }
}

class _CaseStudy extends StatelessWidget {
  const _CaseStudy({required this.projects, required this.index});

  final List<ProjectModel> projects;
  final int index;

  @override
  Widget build(BuildContext context) {
    final project = projects[index];
    final next = projects[(index + 1) % projects.length];
    final sectionTop = Responsive.fluid(context, min: 48, vw: 6, max: 80);

    Widget constrained(Widget child) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: child,
          ),
        );

    return SingleChildScrollView(
      // A fresh scroll position per project, so switching starts at the top.
      key: PageStorageKey('case-study-${project.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Switcher(projects: projects, activeIndex: index),
          constrained(
            SectionContainer(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Hero(project: project, index: index)
                      .animate()
                      .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.03, end: 0, duration: 500.ms),
                  SizedBox(height: sectionTop),
                  _Screens(project: project),
                  SizedBox(height: sectionTop),
                  _Overview(project: project),
                  SizedBox(height: sectionTop),
                  _Features(project: project),
                  SizedBox(height: sectionTop),
                  _ChallengeApproach(project: project),
                  _NextProject(project: next),
                ],
              ),
            ),
          ),
          const SiteFooter(compact: true),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Switcher bar: back link + project tabs
// ─────────────────────────────────────────────────────────────────────────────
class _Switcher extends StatelessWidget {
  const _Switcher({required this.projects, required this.activeIndex});

  final List<ProjectModel> projects;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SectionContainer.horizontalPadding(context),
              vertical: 16,
            ),
            // Full width, otherwise the Wrap shrinks to its content and
            // spaceBetween has no room to act.
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  HoverLink(
                    onTap: () => context.goToSection(SectionIndex.projects),
                    color: AppColors.onSurfaceVariant,
                    builder: (context, color, _) => Text(
                      '← ALL PROJECTS',
                      style: AppTypography.labelSm.copyWith(color: color),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final (i, project) in projects.indexed)
                        _Tab(
                          label: project.shortTitle,
                          isActive: i == activeIndex,
                          onTap: () =>
                              context.go(AppRoutes.project(project.id)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab(
      {required this.label, required this.isActive, required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverLink(
      onTap: isActive ? () {} : onTap,
      color: isActive ? AppColors.onAccent : AppColors.onSurfaceVariant,
      hoverColor: isActive ? AppColors.onAccent : AppColors.accent,
      builder: (context, color, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isActive || hovered
                ? AppColors.accent
                : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.labelSm.copyWith(color: color, height: 1.3),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero + meta strip
// ─────────────────────────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  const _Hero({required this.project, required this.index});

  final ProjectModel project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final metaStyle = AppTypography.labelCaps.copyWith(
      color: AppColors.onSurfaceVariant,
      height: 1.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [
            Text(
              'PROJECT ${(index + 1).toString().padLeft(2, '0')}',
              style: metaStyle.copyWith(color: AppColors.accent),
            ),
            Text(project.kind.toUpperCase(), style: metaStyle),
            Text(project.year, style: metaStyle),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          project.title.toUpperCase(),
          style: AppTypography.headlineLg.copyWith(
            fontSize: Responsive.fluid(context, min: 44, vw: 7, max: 104),
            height: 0.95,
            letterSpacing: -0.02 * 104,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              project.description,
              style: AppTypography.bodyLg.copyWith(
                fontSize: Responsive.fluid(context, min: 18, vw: 1.6, max: 22),
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            if (project.githubUrl != null)
              PrimaryButton(
                label: 'View Source ↗',
                onPressed: () => launchUrl(Uri.parse(project.githubUrl!)),
              ),
            if (project.liveUrl != null)
              PrimaryButton(
                label: 'Live Demo ↗',
                onPressed: () => launchUrl(Uri.parse(project.liveUrl!)),
              ),
            GhostButton(
              label: 'Ask about it',
              onPressed: () => context.goToSection(SectionIndex.contact),
            ),
          ],
        ),
        SizedBox(height: Responsive.fluid(context, min: 40, vw: 5, max: 64)),
        _MetaStrip(facts: project.facts),
      ],
    );
  }
}

class _MetaStrip extends StatelessWidget {
  const _MetaStrip({required this.facts});

  final List<ProjectFact> facts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.autoFitColumns(
          width: constraints.maxWidth,
          minItemWidth: 180,
          gap: 0,
          itemCount: facts.length,
        );
        final itemWidth = constraints.maxWidth / columns;

        return Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.outlineVariant),
            ),
          ),
          child: Wrap(
            children: [
              for (final (i, fact) in facts.indexed)
                Container(
                  width: itemWidth,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      right: (i + 1) % columns != 0
                          ? const BorderSide(color: AppColors.outlineVariant)
                          : BorderSide.none,
                      top: i >= columns
                          ? const BorderSide(color: AppColors.outlineVariant)
                          : BorderSide.none,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fact.label.toUpperCase(),
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        fact.value,
                        style: AppTypography.headlineMd.copyWith(
                          fontSize: 20,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screens gallery
// ─────────────────────────────────────────────────────────────────────────────
class _Screens extends StatelessWidget {
  const _Screens({required this.project});

  final ProjectModel project;

  static const double _gap = 24;

  @override
  Widget build(BuildContext context) {
    final count = project.screens.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RuledHeading(
          'Screens',
          uppercase: true,
          trailing:
              '${count.toString().padLeft(2, '0')} ${count == 1 ? 'VIEW' : 'VIEWS'}',
        ),
        const SizedBox(height: 40),
        LayoutBuilder(
          builder: (context, constraints) {
            // Always size for four tracks so one or two phones don't balloon.
            final columns = Responsive.autoFitColumns(
              width: constraints.maxWidth,
              minItemWidth: 200,
              gap: _gap,
              itemCount: 4,
            );
            final itemWidth =
                (constraints.maxWidth - _gap * (columns - 1)) / columns;
            return Wrap(
              spacing: _gap,
              runSpacing: _gap,
              children: [
                for (final screen in project.screens)
                  SizedBox(
                    width: itemWidth.clamp(0, 260),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PhoneMockup(imageUrl: screen.image),
                        const SizedBox(height: 14),
                        Text(
                          screen.label.toUpperCase(),
                          style: AppTypography.labelSm
                              .copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Overview + stack + architecture
// ─────────────────────────────────────────────────────────────────────────────
class _Overview extends StatelessWidget {
  const _Overview({required this.project});

  final ProjectModel project;

  static const double _gap = 48;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OVERVIEW',
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.accent,
            letterSpacing: 0.1 * 12,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          project.headline,
          style: AppTypography.headlineLg.copyWith(
            fontSize: Responsive.fluid(context, min: 28, vw: 3.2, max: 40),
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          project.overview,
          style: AppTypography.bodyMd.copyWith(
            fontSize: 18,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );

    final panels = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Panel(
          label: 'Stack',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tech in project.techStack)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Text(
                    tech.toUpperCase(),
                    style: AppTypography.labelSm
                        .copyWith(color: AppColors.onSurface, height: 1.3),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _Panel(
          label: 'Architecture',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, line) in project.architecture.indexed) ...[
                if (i > 0) const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        (i + 1).toString().padLeft(2, '0'),
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.accent,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        line,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300 * 2 + _gap) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [text, const SizedBox(height: _gap), panels],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: text),
            const SizedBox(width: _gap),
            Expanded(child: panels),
          ],
        );
      },
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSm
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Key features
// ─────────────────────────────────────────────────────────────────────────────
class _Features extends StatelessWidget {
  const _Features({required this.project});

  final ProjectModel project;

  static const double _gap = 24;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const RuledHeading('Key Features', uppercase: true),
        const SizedBox(height: 40),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = Responsive.autoFitColumns(
              width: constraints.maxWidth,
              minItemWidth: 240,
              gap: _gap,
              itemCount: project.features.length,
              avoidOrphans: true,
            );
            final itemWidth =
                (constraints.maxWidth - _gap * (columns - 1)) / columns;
            return Wrap(
              spacing: _gap,
              runSpacing: _gap,
              children: [
                for (final (i, feature) in project.features.indexed)
                  SizedBox(
                    width: itemWidth,
                    child: HoverCard(
                      color: AppColors.tile,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (i + 1).toString().padLeft(2, '0'),
                            style: AppTypography.labelSm
                                .copyWith(color: AppColors.accent),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            feature.title,
                            style: AppTypography.headlineMd.copyWith(
                              fontSize: 22,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            feature.body,
                            style: AppTypography.bodyMd
                                .copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Challenge / approach
// ─────────────────────────────────────────────────────────────────────────────
class _ChallengeApproach extends StatelessWidget {
  const _ChallengeApproach({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final padding =
        EdgeInsets.all(Responsive.fluid(context, min: 24, vw: 3, max: 40));

    Widget cell(String label, String body,
            {required bool approach, required bool filled}) =>
        Container(
          color: approach && filled ? AppColors.panel : null,
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSm.copyWith(
                  color:
                      approach ? AppColors.accent : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                body,
                style: AppTypography.bodyMd.copyWith(
                  fontSize: 19,
                  height: 1.55,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        );

    return Container(
      foregroundDecoration:
          BoxDecoration(border: Border.all(color: AppColors.outlineVariant)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 320 * 2;
          final challenge = cell('THE CHALLENGE', project.challenge,
              approach: false, filled: stacked);
          final approach = cell('THE APPROACH', project.approach,
              approach: true, filled: stacked);
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                challenge,
                const Divider(
                    height: 1, thickness: 1, color: AppColors.outlineVariant),
                approach,
              ],
            );
          }
          // The approach fill and divider are painted full-height behind the
          // row, so both cells read as equal height without IntrinsicHeight.
          return Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    const Spacer(),
                    Container(width: 1, color: AppColors.outlineVariant),
                    const Expanded(child: ColoredBox(color: AppColors.panel)),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: challenge),
                  const SizedBox(width: 1),
                  Expanded(child: approach),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Next project
// ─────────────────────────────────────────────────────────────────────────────
class _NextProject extends StatelessWidget {
  const _NextProject({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final big = AppTypography.headlineLg.copyWith(
      fontSize: Responsive.fluid(context, min: 32, vw: 5, max: 64),
      height: 1,
      letterSpacing: -0.02 * 64,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.fluid(context, min: 48, vw: 6, max: 88),
      ),
      child: HoverLink(
        onTap: () => context.go(AppRoutes.project(project.id)),
        semanticLabel: 'Next project: ${project.title}',
        builder: (context, color, _) => Container(
          padding: const EdgeInsets.only(top: 32),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.outline, width: 2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEXT PROJECT',
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    Text(project.title.toUpperCase(),
                        style: big.copyWith(color: color)),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Text('→', style: big.copyWith(color: AppColors.accent)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: SectionHeader.titleStyle(context),
            ),
            const SizedBox(height: 16),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLg
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Back to projects',
              onPressed: () => context.goToSection(SectionIndex.projects),
            ),
          ],
        ),
      ),
    );
  }
}
