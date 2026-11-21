import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/di.dart';
import '../../domain/usecases/delete_unit_usecase.dart';
import '../../domain/usecases/get_units_usecase.dart';
import '../controllers/units_controller.dart';
import 'units_dependencies.dart';

class UnitsBinding extends Bindings {
  @override
  void dependencies() {
    registerUnitsDependencies();
    registerLazy<UnitsController>(
      () => UnitsController(
        Get.find<GetUnitsUseCase>(),
        Get.find<DeleteUnitUseCase>(),
        Get.find<DataRefreshService>(),
      ),
    );
  }
}
