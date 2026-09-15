import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Types and deletes each phrase in turn with a blinking gold cursor.
class TypingText extends StatefulWidget {
  const TypingText({
    super.key,
    required this.texts,
    required this.style,
    this.typingSpeed = const Duration(milliseconds: 60),
    this.deletingSpeed = const Duration(milliseconds: 30),
    this.pauseDuration = const Duration(milliseconds: 1800),
  });

  /// List of strings to cycle through
  final List<String> texts;
  final TextStyle style;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration pauseDuration;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cursorController;

  String _displayText = '';
  int _textIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Hard on/off blink, like the design's `steps(1)` keyframes.
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _scheduleNext(widget.typingSpeed);
  }

  void _scheduleNext(Duration delay) {
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (!mounted) return;

    final fullText = widget.texts[_textIndex];

    setState(() {
      if (_isDeleting) {
        if (_displayText.isNotEmpty) {
          _displayText = fullText.substring(0, _displayText.length - 1);
        }

        if (_displayText.isEmpty) {
          _isDeleting = false;
          _textIndex = (_textIndex + 1) % widget.texts.length;
          _scheduleNext(widget.typingSpeed);
          return;
        }
        _scheduleNext(widget.deletingSpeed);
      } else {
        if (_displayText.length < fullText.length) {
          _displayText = fullText.substring(0, _displayText.length + 1);
        }

        if (_displayText.length == fullText.length) {
          // Pause at full text, then start deleting
          _isDeleting = true;
          _scheduleNext(widget.pauseDuration);
          return;
        }
        _scheduleNext(widget.typingSpeed);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.style.fontSize ?? 48;
    final longest = widget.texts.reduce((a, b) => a.length >= b.length ? a : b);

    final cursor = WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: AnimatedBuilder(
        animation: _cursorController,
        builder: (context, _) => Opacity(
          opacity: _cursorController.value < 0.5 ? 1 : 0,
          child: Container(
            width: 3,
            height: fontSize * 0.8,
            margin: const EdgeInsets.only(left: 6),
            color: AppColors.accent,
          ),
        ),
      ),
    );

    return Semantics(
      label: widget.texts.join(' '),
      child: ExcludeSemantics(
        child: Stack(
          children: [
            // Invisible longest phrase reserves the final height, so the hero
            // doesn't jump when a phrase wraps onto a second line.
            Opacity(
              opacity: 0,
              child: Text.rich(
                TextSpan(text: longest, children: [cursor]),
                style: widget.style,
              ),
            ),
            Text.rich(
              TextSpan(text: _displayText, children: [cursor]),
              style: widget.style,
            ),
          ],
        ),
      ),
    );
  }
}
