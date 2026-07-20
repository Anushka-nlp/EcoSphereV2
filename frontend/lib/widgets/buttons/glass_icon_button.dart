import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/surface_effects.dart';

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 52,
    this.iconSize = 22,
    this.tooltip,
    this.isEnabled = true,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final String? tooltip;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && onPressed != null;

    Widget button = Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.circular,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: enabled ? onPressed : null,
          child: SurfaceEffects.blur(
            borderRadius: AppRadius.circular,
            child: Container(
              width: size,
              height: size,
              decoration: SurfaceEffects.decoration(
                borderRadius: AppRadius.circular,
              ),
              child: Icon(icon, size: iconSize, color: AppColors.iconPrimary),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
