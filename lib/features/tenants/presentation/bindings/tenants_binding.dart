import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/di.dart';
import '../../domain/usecases/delete_tenant_usecase.dart';
import '../../domain/usecases/get_tenants_usecase.dart';
import '../controllers/tenants_controller.dart';
import 'tenants_dependencies.dart';

class TenantsBinding extends Bindings {
  @override
  void dependencies() {
    registerTenantsDependencies();
    registerLazy<TenantsController>(
      () => TenantsController(
        Get.find<GetTenantsUseCase>(),
        Get.find<DeleteTenantUseCase>(),
        Get.find<DataRefreshService>(),
      ),
    );
  }
}
