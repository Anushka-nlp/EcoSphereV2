import 'package:flutter/material.dart';

class EchoSphereProgressIndicator extends StatelessWidget {
  final double? value;
  final double? strokeWidth;
  final Color? backgroundColor;

  const EchoSphereProgressIndicator({
    super.key,
    this.value,
    this.strokeWidth,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      strokeWidth: strokeWidth ?? 4,
      backgroundColor: backgroundColor,
    );
  }
}
