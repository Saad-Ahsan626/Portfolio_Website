import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'providers/portfolio_provider.dart';

class _WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  /// Browser-tab title for the home page. Keep in sync with web/index.html.
  static const homeTitle = 'Muhammad Saad Ahsan — Full-Stack Mobile Engineer';

  static String caseStudyTitle(String project) =>
      '$project — Case Study | Muhammad Saad Ahsan';

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final GoRouter _router = ref.read(routerProvider);

  @override
  void initState() {
    super.initState();
    _router.routerDelegate.addListener(_syncTitle);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncTitle());
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_syncTitle);
    super.dispose();
  }

  /// Sets the tab title from the current route. Done here rather than with a
  /// Title widget per page, because the home shell stays mounted under case
  /// studies and wouldn't rebuild to restore its title on the way back.
  void _syncTitle() {
    if (!mounted) return;
    final path = _router.state.uri.path;
    var title = App.homeTitle;
    if (path.startsWith('/projects/')) {
      final id = path.substring('/projects/'.length);
      final projects = ref.read(projectsProvider).valueOrNull;
      // Until the list loads, keep the title the prerendered page came with.
      if (projects == null) return;
      for (final project in projects) {
        if (project.id == id) title = App.caseStudyTitle(project.title);
      }
    }
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: title,
        primaryColor: AppColors.background.toARGB32(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // A case study opened directly needs the project list before its title.
    ref.listen(projectsProvider, (_, __) => _syncTitle());

    // No `title`: on the web that leaves document.title to _syncTitle, so a
    // case study opened directly never flashes the home title.
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      scrollBehavior: _WebScrollBehavior(),
      routerConfig: _router,
    );
  }
}
