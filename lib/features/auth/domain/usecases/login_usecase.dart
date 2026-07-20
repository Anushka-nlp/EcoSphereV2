import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String username,
    required String password,
    required bool rememberMe,
  }) {
    return _repository.login(
      username: username,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
