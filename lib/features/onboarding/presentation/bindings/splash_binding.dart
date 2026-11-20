import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/di.dart';
import '../../data/datasources/onboarding_local_data_source.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/get_onboarding_status_usecase.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    registerLazy<OnboardingLocalDataSource>(
      () => OnboardingStorageDataSource(Get.find()),
    );
    registerLazy<OnboardingRepository>(
      () => OnboardingRepositoryImpl(Get.find<OnboardingLocalDataSource>()),
    );
    registerLazy<GetOnboardingStatusUseCase>(
      () => GetOnboardingStatusUseCase(Get.find<OnboardingRepository>()),
    );
    registerLazy<SplashController>(
      () => SplashController(
        Get.find<GetOnboardingStatusUseCase>(),
        Get.find<AuthService>(),
      ),
    );
  }
}
