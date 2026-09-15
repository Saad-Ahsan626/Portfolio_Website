import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/router/section_navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/scroll_provider.dart';
import '../about/about_section.dart';
import '../contact/contact_section.dart';
import '../experience/experience_section.dart';
import '../home/home_section.dart';
import '../projects/projects_section.dart';
import 'widgets/mobile_drawer.dart';
import 'widgets/nav_bar.dart';
import 'widgets/site_footer.dart';

class ShellPage extends ConsumerStatefulWidget {
  const ShellPage({super.key});

  @override
  ConsumerState<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends ConsumerState<ShellPage> {
  final _scrollViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Arriving from a case-study link such as "All projects".
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumePendingSection());
  }

  void _consumePendingSection() {
    if (!mounted) return;
    final index = ref.read(pendingSectionProvider);
    if (index == null) return;
    ref.read(pendingSectionProvider.notifier).state = null;
    scrollToSection(ProviderScope.containerOf(context, listen: false), index);
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ref.watch(scrollControllerProvider);
    final sectionKeys = ref.watch(sectionKeysProvider);

    // Shell already mounted underneath a case-study page: scroll once the
    // pop has rebuilt it.
    ref.listen<int?>(pendingSectionProvider, (_, next) {
      if (next != null) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _consumePendingSection());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MobileDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(NavBar.heightFor(context)),
        child: const NavBar(),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _updateActiveSection(sectionKeys);
          return false;
        },
        child: SingleChildScrollView(
          key: _scrollViewKey,
          controller: scrollController,
          child: Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      HomeSection(key: sectionKeys[SectionIndex.home]),
                      ProjectsSection(key: sectionKeys[SectionIndex.projects]),
                      ExperienceSection(
                          key: sectionKeys[SectionIndex.experience]),
                      AboutSection(key: sectionKeys[SectionIndex.about]),
                      ContactSection(key: sectionKeys[SectionIndex.contact]),
                    ],
                  ),
                ),
              ),
              // Outside the 1200px column so the footer rule spans the page.
              const SiteFooter(),
            ],
          ),
        ),
      ),
    );
  }

  /// Marks the last section whose top has crossed 30% of the viewport, or the
  /// final section once the page is scrolled to the bottom.
  void _updateActiveSection(List<GlobalKey> keys) {
    final scrollBox =
        _scrollViewKey.currentContext?.findRenderObject() as RenderBox?;
    final controller = ref.read(scrollControllerProvider);
    if (scrollBox == null || !scrollBox.hasSize || !controller.hasClients) {
      return;
    }

    var active = SectionIndex.home;
    final position = controller.position;
    if (position.pixels >= position.maxScrollExtent - 2 &&
        position.maxScrollExtent > 0) {
      active = keys.length - 1;
    } else {
      final threshold = scrollBox.size.height * 0.3;
      for (var i = 0; i < keys.length; i++) {
        final box = keys[i].currentContext?.findRenderObject() as RenderBox?;
        if (box == null || !box.attached) continue;
        final top = box.localToGlobal(Offset.zero, ancestor: scrollBox).dy;
        if (top <= threshold) active = i;
      }
    }

    if (ref.read(activeSectionProvider) != active) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(activeSectionProvider.notifier).state = active;
      });
    }
  }
}
