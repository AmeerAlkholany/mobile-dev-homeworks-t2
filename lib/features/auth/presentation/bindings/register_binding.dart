import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../domain/usecases/register_usecase.dart';
import '../controllers/register_controller.dart';
import 'auth_dependencies.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    registerAuthDependencies();
    registerLazy<RegisterController>(
      () => RegisterController(Get.find<RegisterUseCase>()),
    );
  }
}
