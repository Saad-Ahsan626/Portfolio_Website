import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

/// Applies the design's section padding:
/// `clamp(40px,5vw,80px)` vertically and `clamp(20px,4vw,48px)` horizontally.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
  });

  final Widget child;
  final bool top;
  final bool bottom;

  static double horizontalPadding(BuildContext context) =>
      Responsive.fluid(context, min: 20, vw: 4, max: 48);

  static double verticalPadding(BuildContext context) =>
      Responsive.fluid(context, min: 40, vw: 5, max: 80);

  @override
  Widget build(BuildContext context) {
    final h = horizontalPadding(context);
    final v = verticalPadding(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(h, top ? v : 0, h, bottom ? v : 0),
      child: child,
    );
  }
}
