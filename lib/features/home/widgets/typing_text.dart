import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';

class TypingText extends StatefulWidget {
  const TypingText({
    super.key,
    required this.texts,
    this.typingSpeed = const Duration(milliseconds: 60),
    this.deletingSpeed = const Duration(milliseconds: 30),
    this.pauseDuration = const Duration(milliseconds: 1800),
  });

  /// List of strings to cycle through
  final List<String> texts;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration pauseDuration;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;
  late Animation<double> _cursorOpacity;

  String _displayText = '';
  int _textIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Blinking cursor animation
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);

    _cursorOpacity = Tween<double>(begin: 1, end: 0).animate(_cursorController);

    _startTyping();
  }

  void _startTyping() {
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
        // Remove one character
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
        // Add one character
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
    final isMobile = Responsive.isMobile(context);
    final style =
        isMobile ? AppTypography.headlineLgMobile : AppTypography.headlineLg;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            _displayText,
            style: style.copyWith(
              color: AppColors.onSurface,
              shadows: [
                Shadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),

        // Blinking cursor
        FadeTransition(
          opacity: _cursorOpacity,
          child: Container(
            width: 2.5,
            height: isMobile ? 32 : 42,
            margin: const EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              color: AppColors.electricCyan,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
