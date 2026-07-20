import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<User> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    final user = await _remoteDataSource.login(
      username: username,
      password: password,
    );

    // TODO:
    // Save rememberMe preference.
    // Save JWT token.
    // Cache user locally.

    return user;
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();

    // TODO:
    // Remove cached user.
    // Remove JWT.
    // Clear local session.
  }

  @override
  Future<User?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}
