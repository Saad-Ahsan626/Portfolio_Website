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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= Breakpoints.mobile) return mobile;
    if (width <= Breakpoints.tablet) return tablet ?? desktop;
    return desktop;
  }
}
