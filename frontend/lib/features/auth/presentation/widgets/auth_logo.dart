import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlutterLogo(size: AppSizes.splashLogo);
  }
}
