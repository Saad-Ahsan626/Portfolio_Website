import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Section index constants — single source of truth
class SectionIndex {
  static const int home = 0;
  static const int projects = 1;
  static const int experience = 2;
  static const int contact = 3;
}

// GlobalKeys for each section — used to scroll to them
final sectionKeysProvider = Provider<List<GlobalKey>>((ref) {
  return List.generate(4, (_) => GlobalKey());
});

// Tracks which section is currently visible in the viewport
final activeSectionProvider = StateProvider<int>((ref) => SectionIndex.home);

// ScrollController shared across the app
final scrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});
