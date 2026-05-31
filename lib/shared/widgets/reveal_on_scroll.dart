import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/providers/scroll_visibility_provider.dart';


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
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _checkVisibility() {
    if (!mounted) return;
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final position = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (position.dy < screenHeight * 0.92) {
      ref.read(scrollVisibilityProvider.notifier).markVisible(widget.id);
    }
  }

  Offset get _slideOffset {
    return switch (widget.slideDirection) {
      AxisDirection.up => const Offset(0, 30),
      AxisDirection.down => const Offset(0, -30),
      AxisDirection.left => const Offset(30, 0),
      AxisDirection.right => const Offset(-30, 0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(scrollVisibilityProvider)[widget.id] ?? false;

    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        _checkVisibility();
        return false;
      },
      child: KeyedSubtree(
        key: _key,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          opacity: isVisible ? 1.0 : 0.0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            offset: isVisible ? Offset.zero : _slideOffset / 100,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
