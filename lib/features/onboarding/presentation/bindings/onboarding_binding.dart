import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../data/datasources/onboarding_local_data_source.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    registerLazy<OnboardingLocalDataSource>(
      () => OnboardingStorageDataSource(Get.find()),
    );
    registerLazy<OnboardingRepository>(
      () => OnboardingRepositoryImpl(Get.find<OnboardingLocalDataSource>()),
    );
    registerLazy<CompleteOnboardingUseCase>(
      () => CompleteOnboardingUseCase(Get.find<OnboardingRepository>()),
    );
    registerLazy<OnboardingController>(
      () => OnboardingController(Get.find<CompleteOnboardingUseCase>()),
    );
  }
}
