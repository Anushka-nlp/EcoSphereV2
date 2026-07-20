import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.center,
    this.typingSpeed = const Duration(milliseconds: 70),
    this.initialDelay = Duration.zero,
    this.onFinished,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Duration typingSpeed;
  final Duration initialDelay;
  final VoidCallback? onFinished;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  Timer? _timer;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  Future<void> _startTyping() async {
    if (widget.initialDelay != Duration.zero) {
      await Future.delayed(widget.initialDelay);
    }

    if (!mounted) return;

    _timer = Timer.periodic(widget.typingSpeed, (timer) {
      if (!mounted) return;

      if (_currentLength < widget.text.length) {
        setState(() {
          _currentLength++;
        });
      } else {
        timer.cancel();
        widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: Text(
        widget.text.substring(0, _currentLength),
        key: ValueKey(_currentLength),
        textAlign: widget.textAlign,
        style: widget.style,
      ),
    );
  }
}
