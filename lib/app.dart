import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/shell_page.dart';
import 'providers/theme_provider.dart'; // <-- Add this import

class _WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── NEW: Watch the theme state ──
    final isDarkMode = ref.watch(isDarkModeProvider);

    return MaterialApp(
      title:
          'Muhammad Saad Ahsan — Flutter Developer', // Added your name for polish!
      debugShowCheckedModeBanner: false,
      // ── NEW: Apply the dynamic theme ──
      theme: isDarkMode ? AppTheme.dark : ThemeData.light(),
      scrollBehavior: _WebScrollBehavior(),
      home: const ShellPage(),
    );
  }
}
