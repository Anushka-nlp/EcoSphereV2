import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1120), Color(0xFF111827), Color(0xFF0F172A)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -120,
            child: _Glow(size: 320, color: Colors.blueAccent, opacity: .08),
          ),

          Positioned(
            bottom: -140,
            right: -100,
            child: _Glow(size: 360, color: Colors.white, opacity: .03),
          ),

          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color, required this.opacity});

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: size,
              spreadRadius: size / 3,
            ),
          ],
        ),
      ),
    );
  }
}
