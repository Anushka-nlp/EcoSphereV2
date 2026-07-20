import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ECOSPHERE',
          textAlign: TextAlign.center,
          style: AppTextStyles.logo,
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          'Smart Campus Communication',
          textAlign: TextAlign.center,
          style: AppTextStyles.logoSubtitle,
        ),
      ],
    );
  }
}
