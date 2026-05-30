import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppSpacing.radius,
    this.enableHover = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool enableHover;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) =>
          widget.enableHover ? setState(() => _hovered = true) : null,
      onExit: (_) =>
          widget.enableHover ? setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: widget.enableHover && _hovered
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color:
                _hovered ? AppColors.glassBorderHover : AppColors.glassBorder,
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  const BoxShadow(
                    color: Color(0x4D000000),
                    blurRadius: 40,
                    offset: Offset(0, 20),
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
