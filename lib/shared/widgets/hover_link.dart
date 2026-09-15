import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Text link that turns gold on hover/focus (design `a:hover`), keyboard
/// reachable. [builder] receives the current colour so callers can tint
/// icons or multi-part labels.
class HoverLink extends StatefulWidget {
  const HoverLink({
    super.key,
    required this.onTap,
    required this.builder,
    this.color = AppColors.onSurface,
    this.hoverColor = AppColors.accent,
    this.semanticLabel,
  });

  final VoidCallback onTap;
  final Widget Function(BuildContext context, Color color, bool hovered) builder;
  final Color color;
  final Color hoverColor;
  final String? semanticLabel;

  @override
  State<HoverLink> createState() => _HoverLinkState();
}

class _HoverLinkState extends State<HoverLink> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = _hovered || _focused;
    return Semantics(
      link: true,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: widget.builder(
            context,
            highlighted ? widget.hoverColor : widget.color,
            highlighted,
          ),
        ),
      ),
    );
  }
}
