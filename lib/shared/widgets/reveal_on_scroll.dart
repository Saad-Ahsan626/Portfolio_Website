import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/providers/scroll_provider.dart';
import 'package:portfolio/providers/scroll_visibility_provider.dart';

/// Reveals [child] with a fade + slide the first time it scrolls into the
/// viewport. Reveal state lives in [scrollVisibilityProvider] so a widget
/// never re-hides once shown (e.g. after a rebuild or resize).
class RevealOnScroll extends ConsumerStatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.id,
    required this.child,
    this.delay = Duration.zero,
    this.slideDirection = AxisDirection.up,
  });

  final String id;
  final Widget child;
  final Duration delay;
  final AxisDirection slideDirection;

  @override
  ConsumerState<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends ConsumerState<RevealOnScroll> {
  ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    // Scroll notifications bubble UP from the scrollable, so a listener down
    // here never sees them — observe the shared ScrollController instead.
    _controller = ref.read(scrollControllerProvider);
    _controller!.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _controller?.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (!mounted) return;
    if (ref.read(scrollVisibilityProvider)[widget.id] == true) {
      _controller?.removeListener(_checkVisibility);
      return;
    }

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;

    final top = box.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Reveal once the top of the widget crosses 90% of the viewport height.
    if (top < screenHeight * 0.9) {
      _controller?.removeListener(_checkVisibility);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(scrollVisibilityProvider.notifier).markVisible(widget.id);
        }
      });
    }
  }

  Offset get _slideBegin {
    return switch (widget.slideDirection) {
      AxisDirection.up => const Offset(0, 0.12),
      AxisDirection.down => const Offset(0, -0.12),
      AxisDirection.left => const Offset(0.08, 0),
      AxisDirection.right => const Offset(-0.08, 0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(
      scrollVisibilityProvider.select((m) => m[widget.id] ?? false),
    );

    // target-driven Animate: plays forward when isVisible flips to 1,
    // honoring the stagger delay. autoPlay off so it waits for the trigger.
    return Animate(
      target: isVisible ? 1 : 0,
      autoPlay: false,
      effects: [
        FadeEffect(
          delay: widget.delay,
          duration: 500.ms,
          curve: Curves.easeOut,
        ),
        SlideEffect(
          delay: widget.delay,
          begin: _slideBegin,
          end: Offset.zero,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        ),
      ],
      child: widget.child,
    );
  }
}
