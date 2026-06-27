import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/shell/widgets/mobile_drawer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/scroll_provider.dart';
import '../../features/home/home_section.dart';
import '../../features/projects/projects_section.dart';
import '../../features/experience/experience_section.dart';
import '../../features/contact/contact_section.dart';
import '../../core/utils/responsive.dart';
import 'widgets/nav_bar.dart';
import 'widgets/site_footer.dart';

class ShellPage extends ConsumerWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);
    final sectionKeys = ref.watch(sectionKeysProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MobileDrawer(),
      // Use the Scaffold's appBar slot with a fixed-height PreferredSize so
      // Flutter knows the nav is exactly 80px — no Stack, no Positioned, no
      // unbounded height constraints that cause overflow on first render.
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Responsive.isMobile(context) ? 60 : 80),
        child: const NavBar(),
      ),
      body: Stack(
        children: [
          // Radial gradient background — fills the body area below the nav.
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.4,
                  colors: [Color(0xFF1E293B), AppColors.midnightNavy],
                ),
              ),
            ),
          ),

          // Main scrollable content — no top SizedBox needed, Scaffold
          // handles the appBar offset automatically.
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _updateActiveSection(ref, sectionKeys, context);
              return false;
            },
            child: SingleChildScrollView(
              controller: scrollController,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.containerMax,
                  ),
                  child: Column(
                    children: [
                      HomeSection(key: sectionKeys[SectionIndex.home]),
                      _sectionDivider(),
                      ProjectsSection(key: sectionKeys[SectionIndex.projects]),
                      _sectionDivider(),
                      ExperienceSection(
                          key: sectionKeys[SectionIndex.experience]),
                      _sectionDivider(),
                      ContactSection(key: sectionKeys[SectionIndex.contact]),

                      const SizedBox(height: AppSpacing.xl),
                      const SiteFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionDivider() => const SizedBox(height: AppSpacing.xl);

  void _updateActiveSection(
    WidgetRef ref,
    List<GlobalKey> keys,
    BuildContext context,
  ) {
    // ── NEW: Fetch the scroll controller ──
    final scrollController = ref.read(scrollControllerProvider);

    // ── NEW: Safety catch for bouncing at the absolute top ──
    if (scrollController.hasClients && scrollController.offset <= 0) {
      if (ref.read(activeSectionProvider) != SectionIndex.home) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(activeSectionProvider.notifier).state = SectionIndex.home;
        });
      }
      return; // Exit early since we know we are at the top
    }

    // Standard boundary math for the rest of the page
    for (int i = keys.length - 1; i >= 0; i--) {
      final ctx = keys[i].currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final position = box.localToGlobal(Offset.zero);

      // Scaffold appBar reserves space. Sections stop scrolling exactly at
      // (appBarHeight + 20). Set threshold slightly below that.
      final appBarHeight = Responsive.isMobile(context) ? 60.0 : 80.0;
      final triggerThreshold = appBarHeight + 40.0;

      if (position.dy <= triggerThreshold) {
        if (ref.read(activeSectionProvider) != i) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(activeSectionProvider.notifier).state = i;
          });
        }
        break;
      }
    }
  }
}
