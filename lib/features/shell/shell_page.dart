import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/scroll_provider.dart';
import '../../features/home/home_section.dart';
import '../../features/projects/projects_section.dart';
import '../../features/experience/experience_section.dart';
import '../../features/contact/contact_section.dart';
import 'widgets/nav_bar.dart';

class ShellPage extends ConsumerWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);
    final sectionKeys = ref.watch(sectionKeysProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Radial gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.4,
                colors: [Color(0xFF1E293B), AppColors.midnightNavy],
              ),
            ),
          ),

          // Main scrollable content
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _updateActiveSection(ref, sectionKeys, context);
              return false;
            },
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  // Top padding for sticky nav
                  const SizedBox(height: 80),

                  HomeSection(key: sectionKeys[SectionIndex.home]),
                  _sectionDivider(),
                  ProjectsSection(key: sectionKeys[SectionIndex.projects]),
                  _sectionDivider(),
                  ExperienceSection(key: sectionKeys[SectionIndex.experience]),
                  _sectionDivider(),
                  ContactSection(key: sectionKeys[SectionIndex.contact]),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),

          // Sticky nav on top of everything
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(),
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
    for (int i = keys.length - 1; i >= 0; i--) {
      final ctx = keys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final position = box.localToGlobal(Offset.zero);
      if (position.dy <= 120) {
        ref.read(activeSectionProvider.notifier).state = i;
        break;
      }
    }
  }
}
