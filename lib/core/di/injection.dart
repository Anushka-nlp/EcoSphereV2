import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class Injection {
  Injection._();

  static final AuthRemoteDataSource authRemoteDataSource =
      AuthRemoteDataSourceImpl();

  static final AuthRepository authRepository = AuthRepositoryImpl(
    authRemoteDataSource,
  );

  static final LoginUseCase loginUseCase = LoginUseCase(authRepository);

  static final LogoutUseCase logoutUseCase = LogoutUseCase(authRepository);

  static final AuthProvider authProvider = AuthProvider(
    loginUseCase: loginUseCase,
    logoutUseCase: logoutUseCase,
  );
}
