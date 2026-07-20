import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class Background extends StatefulWidget {
  const Background({super.key, required this.child});

  final Widget child;

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.background),

            Positioned(
              left: -size.width * 0.22 + (20 * math.sin(t * math.pi * 2)),
              top: -size.width * 0.22 + (15 * math.cos(t * math.pi * 2)),
              child: _AmbientGlow(
                size: size.width * 0.70,
                color: AppColors.info.withValues(alpha: 0.10),
              ),
            ),

            Positioned(
              right: -size.width * 0.18 + (18 * math.cos(t * math.pi * 2)),
              bottom: -size.width * 0.20 + (12 * math.sin(t * math.pi * 2)),
              child: _AmbientGlow(
                size: size.width * 0.60,
                color: Colors.white.withValues(alpha: 0.025),
              ),
            ),

            IgnorePointer(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: const SizedBox.expand(),
              ),
            ),

            widget.child,
          ],
        );
      },
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            radius: 0.85,
            colors: [
              color,
              color.withValues(alpha: color.a * 0.35),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
