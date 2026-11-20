import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../domain/usecases/login_usecase.dart';
import '../controllers/login_controller.dart';
import 'auth_dependencies.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    registerAuthDependencies();
    registerLazy<LoginController>(
      () => LoginController(Get.find<LoginUseCase>()),
    );
  }
}
