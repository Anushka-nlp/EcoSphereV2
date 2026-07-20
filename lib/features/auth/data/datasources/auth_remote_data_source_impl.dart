import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: '1',
      username: username,
      email: '$username@ecosphere.com',
      role: 'Student',
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return null;
  }

  @override
  Future<void> logout() async {}
}
