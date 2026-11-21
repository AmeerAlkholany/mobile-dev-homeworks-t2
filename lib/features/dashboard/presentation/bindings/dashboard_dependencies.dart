import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/di.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../auth/presentation/bindings/auth_dependencies.dart';
import '../../../payments/domain/usecases/get_payments_usecase.dart';
import '../../../payments/presentation/bindings/payments_dependencies.dart';
import '../../../tenants/presentation/bindings/tenants_dependencies.dart';
import '../../../units/domain/usecases/get_units_usecase.dart';
import '../../../units/presentation/bindings/units_dependencies.dart';
import '../controllers/dashboard_controller.dart';

/// Registers the dashboard controller together with the unit, tenant, payment
/// and auth graphs it aggregates.
void registerDashboardDependencies() {
  registerAuthDependencies();
  registerUnitsDependencies();
  registerTenantsDependencies();
  registerPaymentsDependencies();
  registerLazy<DashboardController>(
    () => DashboardController(
      Get.find<GetUnitsUseCase>(),
      Get.find<GetPaymentsUseCase>(),
      Get.find<GetCurrentUserUseCase>(),
      Get.find<DataRefreshService>(),
    ),
  );
}
