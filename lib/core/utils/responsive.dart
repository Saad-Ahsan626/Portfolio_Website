import 'package:flutter/material.dart';
import '../constants/breakpoints.dart';

enum DeviceType { mobile, tablet, desktop }

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  static DeviceType deviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= Breakpoints.mobile) return DeviceType.mobile;
    if (width <= Breakpoints.tablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= Breakpoints.mobile;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w > Breakpoints.mobile && w <= Breakpoints.tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width > Breakpoints.tablet;

  /// CSS `clamp(min, vw, max)` against the viewport width — the design files
  /// size most type and spacing this way.
  static double fluid(
    BuildContext context, {
    required double min,
    required double vw,
    required double max,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * vw / 100).clamp(min, max);
  }

  /// Number of columns a CSS `repeat(auto-fit, minmax(minItem, 1fr))` grid
  /// would produce, capped at [itemCount] because auto-fit collapses empty
  /// tracks. With [avoidOrphans], drops columns until the last row isn't a
  /// lone item (e.g. four items become 2×2 rather than 3 + 1).
  static int autoFitColumns({
    required double width,
    required double minItemWidth,
    required double gap,
    int? itemCount,
    bool avoidOrphans = false,
  }) {
    var columns = ((width + gap) / (minItemWidth + gap)).floor();
    if (columns < 1) columns = 1;
    if (itemCount != null && itemCount > 0) {
      if (columns > itemCount) columns = itemCount;
      while (avoidOrphans && columns > 2 && itemCount % columns == 1) {
        columns--;
      }
    }
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= Breakpoints.mobile) return mobile;
    if (width <= Breakpoints.tablet) return tablet ?? desktop;
    return desktop;
  }
}
