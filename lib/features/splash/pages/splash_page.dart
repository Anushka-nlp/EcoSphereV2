import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../widgets/backgrounds/background.dart';
import '../../auth/presentation/pages/auth_wrapper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _logoController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: AppDurations.extraSlow,
    );

    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeOut);

    _logoScale = Tween<double>(begin: 0.94, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    _logoController.forward();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthWrapper()));
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FlutterLogo(size: 92),

                      const SizedBox(height: AppSpacing.xxl),

                      Text('ECOSPHERE', style: AppTextStyles.logo),

                      const SizedBox(height: AppSpacing.sm),

                      Text(
                        'Smart Campus Communication',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.logoSubtitle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
