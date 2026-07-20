import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required this.loginUseCase, required this.logoutUseCase});

  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? _currentUser;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<bool> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await loginUseCase(
        username: username,
        password: password,
        rememberMe: rememberMe,
      );

      _currentUser = user;
      _isAuthenticated = true;

      return true;
    } catch (e) {
      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = e.toString();

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await logoutUseCase();

      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
