import 'package:flutter/material.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_animated_logo.dart';

/// Splash Screen with Animated Logo
class EchoSphereSplashScreen extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  
  const EchoSphereSplashScreen({
    super.key,
    this.onAnimationComplete,
  });

  @override
  State<EchoSphereSplashScreen> createState() => _EchoSphereSplashScreenState();
}

class _EchoSphereSplashScreenState extends State<EchoSphereSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: EchoSphereAnimatedLogo(
          size: 200,
          autoPlay: true,
          onAnimationComplete: () {
            // Navigate to home after animation
            Future.delayed(const Duration(milliseconds: 500), () {
              widget.onAnimationComplete?.call();
            });
          },
        ),
      ),
    );
  }
}
