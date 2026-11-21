import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/di.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/usecases/save_unit_usecase.dart';
import '../controllers/unit_form_controller.dart';
import 'units_dependencies.dart';

class UnitFormBinding extends Bindings {
  @override
  void dependencies() {
    registerUnitsDependencies();
    registerLazy<UnitFormController>(
      () => UnitFormController(
        Get.find<SaveUnitUseCase>(),
        Get.find<DataRefreshService>(),
        _unitFromArguments(),
      ),
    );
  }

  UnitEntity? _unitFromArguments() {
    final Object? arguments = Get.arguments;
    if (arguments is Map && arguments['unit'] is UnitEntity) {
      return arguments['unit'] as UnitEntity;
    }
    return null;
  }
}
