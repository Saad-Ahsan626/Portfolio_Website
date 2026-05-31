import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/shell_page.dart';

// Enables mouse drag-scrolling on Flutter Web
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
    return MaterialApp(
      title: 'YourName — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      scrollBehavior: _WebScrollBehavior(), // ← enables drag scroll on desktop
      home: const ShellPage(),
    );
  }
}
