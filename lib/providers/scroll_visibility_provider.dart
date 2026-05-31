import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds a registry of GlobalKey → bool (is visible)
class ScrollVisibilityNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  void markVisible(String id) {
    if (state[id] == true) return; // already visible — never hide again
    state = {...state, id: true};
  }

  bool isVisible(String id) => state[id] ?? false;
}

final scrollVisibilityProvider =
    NotifierProvider<ScrollVisibilityNotifier, Map<String, bool>>(
  ScrollVisibilityNotifier.new,
);
