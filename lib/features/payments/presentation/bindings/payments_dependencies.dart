import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/di.dart';
import '../../../tenants/domain/repositories/tenants_repository.dart';
import '../../../tenants/presentation/bindings/tenants_dependencies.dart';
import '../../../units/domain/repositories/units_repository.dart';
import '../../../units/presentation/bindings/units_dependencies.dart';
import '../../data/datasources/payments_local_data_source.dart';
import '../../data/repositories/payments_repository_impl.dart';
import '../../domain/repositories/payments_repository.dart';
import '../../domain/usecases/get_payments_usecase.dart';
import '../../domain/usecases/get_tenant_payments_usecase.dart';
import '../../domain/usecases/mark_payment_paid_usecase.dart';
import '../../domain/usecases/record_payment_usecase.dart';

/// Registers the rent ledger graph. The ledger is derived from tenants and
/// their units, so both graphs are registered first.
void registerPaymentsDependencies() {
  registerUnitsDependencies();
  registerTenantsDependencies();
  registerLazy<PaymentsLocalDataSource>(
    () => PaymentsStorageDataSource(
      Get.find<StorageService>(),
      Get.find<TenantsRepository>(),
      Get.find<UnitsRepository>(),
    ),
  );
  registerLazy<PaymentsRepository>(
    () => PaymentsRepositoryImpl(Get.find<PaymentsLocalDataSource>()),
  );
  registerLazy<GetPaymentsUseCase>(
    () => GetPaymentsUseCase(Get.find<PaymentsRepository>()),
  );
  registerLazy<GetTenantPaymentsUseCase>(
    () => GetTenantPaymentsUseCase(Get.find<PaymentsRepository>()),
  );
  registerLazy<RecordPaymentUseCase>(
    () => RecordPaymentUseCase(Get.find<PaymentsRepository>()),
  );
  registerLazy<MarkPaymentPaidUseCase>(
    () => MarkPaymentPaidUseCase(Get.find<PaymentsRepository>()),
  );
}
