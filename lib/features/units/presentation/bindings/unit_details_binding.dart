import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../../tenants/domain/usecases/get_tenant_by_unit_usecase.dart';
import '../../../tenants/presentation/bindings/tenants_dependencies.dart';
import '../../domain/usecases/get_unit_by_id_usecase.dart';
import '../controllers/unit_details_controller.dart';
import 'units_dependencies.dart';

class UnitDetailsBinding extends Bindings {
  @override
  void dependencies() {
    registerUnitsDependencies();
    registerTenantsDependencies();
    registerLazy<UnitDetailsController>(
      () => UnitDetailsController(
        Get.find<GetUnitByIdUseCase>(),
        Get.find<GetTenantByUnitUseCase>(),
        _unitIdFromArguments(),
      ),
    );
  }

  String _unitIdFromArguments() {
    final Object? arguments = Get.arguments;
    if (arguments is Map && arguments['unitId'] is String) {
      return arguments['unitId'] as String;
    }
    return '';
  }
}
