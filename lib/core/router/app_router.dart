import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/project_detail/project_detail_page.dart';
import '../../features/shell/shell_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static String project(String id) => '/projects/$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ShellPage()),
        routes: [
          // Nested under home so the one-page shell (and its scroll position)
          // stays mounted underneath and browser back returns to it.
          GoRoute(
            path: 'projects/:id',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: ProjectDetailPage(
                projectId: state.pathParameters['id']!,
              ),
              transitionDuration: const Duration(milliseconds: 250),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, _, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),
        ],
      ),
    ],
    // Unknown URLs fall back to the home page instead of an error screen.
    redirect: (context, state) {
      final path = state.uri.path;
      if (path == AppRoutes.home || path.startsWith('/projects/')) return null;
      return AppRoutes.home;
    },
  );
  ref.onDispose(router.dispose);
  return router;
});
