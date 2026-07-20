import 'package:flutter/material.dart';

import 'package:ecosphere/core/enums/auth_state.dart';
import 'package:ecosphere/features/auth/presentation/pages/login_page.dart';
import 'package:ecosphere/features/home/pages/home_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  AuthState _authState = AuthState.unknown;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // ===========================================================
    // TODO
    //
    // 1. Read Secure Storage
    // 2. Check Access Token
    // 3. Refresh Token
    // 4. Load User
    // 5. Load Permissions
    //
    // ===========================================================

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _authState = AuthState.unauthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authState) {
      case AuthState.unknown:
        return const Scaffold(body: SizedBox.expand());

      case AuthState.authenticated:
        return const HomePage();

      case AuthState.unauthenticated:
        return const LoginPage();
    }
  }
}
