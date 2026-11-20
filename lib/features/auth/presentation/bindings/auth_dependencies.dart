import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/di.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

/// Shared auth wiring used by the login, register and profile bindings. All
/// registrations are guarded, so calling it from several screens is safe.
void registerAuthDependencies() {
  registerLazy<AuthLocalDataSource>(() => const MockAuthLocalDataSource());
  registerLazy<AuthRepository>(
    () => AuthRepositoryImpl(
      Get.find<AuthLocalDataSource>(),
      Get.find<AuthService>(),
    ),
  );
  registerLazy<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));
  registerLazy<RegisterUseCase>(
    () => RegisterUseCase(Get.find<AuthRepository>()),
  );
  registerLazy<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(Get.find<AuthRepository>()),
  );
  registerLazy<LogoutUseCase>(() => LogoutUseCase(Get.find<AuthRepository>()));
}
