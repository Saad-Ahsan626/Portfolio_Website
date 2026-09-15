import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scroll_provider.dart';
import 'app_router.dart';

/// Scrolls the one-page shell so section [index] sits directly under the nav.
///
/// Takes a [ProviderContainer] rather than a `WidgetRef` so callers whose
/// widget is about to unmount (e.g. the mobile drawer) can still use it.
void scrollToSection(ProviderContainer container, int index) {
  final ctx = container.read(sectionKeysProvider)[index].currentContext;
  if (ctx == null || !ctx.mounted) return;
  Scrollable.ensureVisible(
    ctx,
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeInOut,
  );
}

/// Goes to a section from anywhere: scrolls when the shell is showing, or
/// returns to the shell first when a case-study page is open.
void goToSection({
  required ProviderContainer container,
  required GoRouter router,
  required int index,
}) {
  if (router.state.uri.path == AppRoutes.home) {
    scrollToSection(container, index);
    return;
  }
  container.read(pendingSectionProvider.notifier).state = index;
  router.go(AppRoutes.home);
}

extension SectionNavigationContext on BuildContext {
  void goToSection(int index) => _goToSection(this, index);
}

void _goToSection(BuildContext context, int index) => goToSection(
      container: ProviderScope.containerOf(context, listen: false),
      router: GoRouter.of(context),
      index: index,
    );
