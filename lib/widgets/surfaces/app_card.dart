import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/surface_effects.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = AppRadius.lg,
    this.alignment,
    this.decoration,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final double? width;
  final double? height;

  final BorderRadius borderRadius;

  final AlignmentGeometry? alignment;

  /// Optional custom decoration.
  final BoxDecoration? decoration;

  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return SurfaceEffects.blur(
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        alignment: alignment,
        margin: margin,
        padding: padding,
        clipBehavior: clipBehavior,
        decoration:
            decoration ?? SurfaceEffects.decoration(borderRadius: borderRadius),
        child: child,
      ),
    );
  }
}
