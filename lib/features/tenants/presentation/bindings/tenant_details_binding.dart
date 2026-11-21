import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/di.dart';
import '../../../payments/domain/usecases/get_tenant_payments_usecase.dart';
import '../../../payments/presentation/bindings/payments_dependencies.dart';
import '../../../units/domain/usecases/get_unit_by_id_usecase.dart';
import '../../domain/usecases/delete_tenant_usecase.dart';
import '../../domain/usecases/get_tenant_by_id_usecase.dart';
import '../controllers/tenant_details_controller.dart';
import 'tenants_dependencies.dart';

class TenantDetailsBinding extends Bindings {
  @override
  void dependencies() {
    registerTenantsDependencies();
    registerPaymentsDependencies();
    registerLazy<TenantDetailsController>(
      () => TenantDetailsController(
        Get.find<GetTenantByIdUseCase>(),
        Get.find<GetUnitByIdUseCase>(),
        Get.find<GetTenantPaymentsUseCase>(),
        Get.find<DeleteTenantUseCase>(),
        Get.find<DataRefreshService>(),
        _tenantIdFromArguments(),
      ),
    );
  }

  String _tenantIdFromArguments() {
    final Object? arguments = Get.arguments;
    if (arguments is Map && arguments['tenantId'] is String) {
      return arguments['tenantId'] as String;
    }
    return '';
  }
}
