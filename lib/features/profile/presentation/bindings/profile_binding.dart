import 'package:get/get.dart';

import '../../../../core/services/locale_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/utils/di.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../../auth/presentation/bindings/auth_dependencies.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    registerAuthDependencies();
    registerLazy<ProfileController>(
      () => ProfileController(
        Get.find<GetCurrentUserUseCase>(),
        Get.find<LogoutUseCase>(),
        Get.find<ThemeService>(),
        Get.find<LocaleService>(),
      ),
    );
  }
}
