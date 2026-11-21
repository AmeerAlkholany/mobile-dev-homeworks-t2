import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/di.dart';
import '../../../units/domain/usecases/get_units_usecase.dart';
import '../../../units/presentation/bindings/units_dependencies.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/usecases/save_tenant_usecase.dart';
import '../controllers/tenant_form_controller.dart';
import 'tenants_dependencies.dart';

class TenantFormBinding extends Bindings {
  @override
  void dependencies() {
    registerUnitsDependencies();
    registerTenantsDependencies();
    registerLazy<TenantFormController>(
      () => TenantFormController(
        Get.find<SaveTenantUseCase>(),
        Get.find<GetUnitsUseCase>(),
        Get.find<DataRefreshService>(),
        _tenantFromArguments(),
      ),
    );
  }

  TenantEntity? _tenantFromArguments() {
    final Object? arguments = Get.arguments;
    if (arguments is Map && arguments['tenant'] is TenantEntity) {
      return arguments['tenant'] as TenantEntity;
    }
    return null;
  }
}
