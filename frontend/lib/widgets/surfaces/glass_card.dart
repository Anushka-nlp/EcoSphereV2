import 'package:flutter/material.dart';

import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/surface_effects.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.margin = EdgeInsets.zero,
    this.borderRadius = AppRadius.xl,
    this.width,
    this.height,
    this.alignment,
    this.decoration,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
  });

  final Widget child;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final BorderRadius borderRadius;

  final double? width;
  final double? height;

  final AlignmentGeometry? alignment;

  /// Optional custom decoration.
  final BoxDecoration? decoration;

  final Clip clipBehavior;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget card = SurfaceEffects.blur(
      borderRadius: borderRadius,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        curve: Curves.easeOut,
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

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: card,
      ),
    );
  }
}
