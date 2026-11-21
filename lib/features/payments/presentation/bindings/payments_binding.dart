import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/di.dart';
import '../../../tenants/domain/usecases/get_tenants_usecase.dart';
import '../../domain/usecases/get_payments_usecase.dart';
import '../../domain/usecases/mark_payment_paid_usecase.dart';
import '../../domain/usecases/record_payment_usecase.dart';
import '../controllers/payments_controller.dart';
import 'payments_dependencies.dart';

class PaymentsBinding extends Bindings {
  @override
  void dependencies() {
    registerPaymentsDependencies();
    registerLazy<PaymentsController>(
      () => PaymentsController(
        Get.find<GetPaymentsUseCase>(),
        Get.find<RecordPaymentUseCase>(),
        Get.find<MarkPaymentPaidUseCase>(),
        Get.find<GetTenantsUseCase>(),
        Get.find<DataRefreshService>(),
      ),
    );
  }
}
