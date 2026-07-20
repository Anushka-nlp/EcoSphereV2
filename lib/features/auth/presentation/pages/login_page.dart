import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_logo.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.huge,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthLogo(),

                SizedBox(height: AppSpacing.xxl),

                AuthHeader(),

                SizedBox(height: AppSpacing.massive),

                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
