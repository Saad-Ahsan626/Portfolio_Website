import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Section index constants — single source of truth, in page order.
class SectionIndex {
  static const int home = 0;
  static const int projects = 1;
  static const int experience = 2;
  static const int about = 3;
  static const int contact = 4;

  static const int count = 5;
}

// GlobalKeys for each section — used to scroll to them
final sectionKeysProvider = Provider<List<GlobalKey>>((ref) {
  return List.generate(SectionIndex.count, (_) => GlobalKey());
});

// Tracks which section is currently visible in the viewport
final activeSectionProvider = StateProvider<int>((ref) => SectionIndex.home);

/// Section to scroll to once the one-page shell is on screen again, set when
/// navigating back from a case-study page.
final pendingSectionProvider = StateProvider<int?>((ref) => null);

// ScrollController shared across the app
final scrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});
