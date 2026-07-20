import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => Injection.authProvider,
      child: const EchoSphereApp(),
    ),
  );
}

class EchoSphereApp extends StatelessWidget {
  const EchoSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoSphere',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashPage(),
    );
  }
}
