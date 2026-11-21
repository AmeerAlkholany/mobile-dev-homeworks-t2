import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/di.dart';
import '../../data/datasources/units_local_data_source.dart';
import '../../data/repositories/units_repository_impl.dart';
import '../../domain/repositories/units_repository.dart';
import '../../domain/usecases/delete_unit_usecase.dart';
import '../../domain/usecases/get_unit_by_id_usecase.dart';
import '../../domain/usecases/get_units_usecase.dart';
import '../../domain/usecases/save_unit_usecase.dart';

/// Registers the unit data graph. Guarded, so other features (tenants,
/// payments, dashboard) can safely depend on it too.
void registerUnitsDependencies() {
  registerLazy<UnitsLocalDataSource>(
    () => UnitsStorageDataSource(Get.find<StorageService>()),
  );
  registerLazy<UnitsRepository>(
    () => UnitsRepositoryImpl(Get.find<UnitsLocalDataSource>()),
  );
  registerLazy<GetUnitsUseCase>(
    () => GetUnitsUseCase(Get.find<UnitsRepository>()),
  );
  registerLazy<GetUnitByIdUseCase>(
    () => GetUnitByIdUseCase(Get.find<UnitsRepository>()),
  );
  registerLazy<SaveUnitUseCase>(
    () => SaveUnitUseCase(Get.find<UnitsRepository>()),
  );
  registerLazy<DeleteUnitUseCase>(
    () => DeleteUnitUseCase(Get.find<UnitsRepository>()),
  );
}
