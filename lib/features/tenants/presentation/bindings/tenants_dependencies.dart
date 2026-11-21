import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/di.dart';
import '../../../units/domain/repositories/units_repository.dart';
import '../../../units/presentation/bindings/units_dependencies.dart';
import '../../data/datasources/tenants_local_data_source.dart';
import '../../data/repositories/tenants_repository_impl.dart';
import '../../domain/repositories/tenants_repository.dart';
import '../../domain/usecases/delete_tenant_usecase.dart';
import '../../domain/usecases/get_tenant_by_id_usecase.dart';
import '../../domain/usecases/get_tenant_by_unit_usecase.dart';
import '../../domain/usecases/get_tenants_usecase.dart';
import '../../domain/usecases/save_tenant_usecase.dart';

/// Registers the tenant graph. Tenants keep unit occupancy in sync, so the
/// unit graph is registered first.
void registerTenantsDependencies() {
  registerUnitsDependencies();
  registerLazy<TenantsLocalDataSource>(
    () => TenantsStorageDataSource(Get.find<StorageService>()),
  );
  registerLazy<TenantsRepository>(
    () => TenantsRepositoryImpl(
      Get.find<TenantsLocalDataSource>(),
      Get.find<UnitsRepository>(),
    ),
  );
  registerLazy<GetTenantsUseCase>(
    () => GetTenantsUseCase(Get.find<TenantsRepository>()),
  );
  registerLazy<GetTenantByIdUseCase>(
    () => GetTenantByIdUseCase(Get.find<TenantsRepository>()),
  );
  registerLazy<GetTenantByUnitUseCase>(
    () => GetTenantByUnitUseCase(Get.find<TenantsRepository>()),
  );
  registerLazy<SaveTenantUseCase>(
    () => SaveTenantUseCase(Get.find<TenantsRepository>()),
  );
  registerLazy<DeleteTenantUseCase>(
    () => DeleteTenantUseCase(Get.find<TenantsRepository>()),
  );
}
