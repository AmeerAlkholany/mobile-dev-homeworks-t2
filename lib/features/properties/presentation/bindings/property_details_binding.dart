import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../../favorites/presentation/bindings/favorites_binding.dart';
import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../data/datasources/property_local_data_source.dart';
import '../../data/repositories/property_repository_impl.dart';
import '../../domain/repositories/property_repository.dart';
import '../../domain/usecases/get_property_by_id_usecase.dart';
import '../controllers/property_details_controller.dart';

class PropertyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    FavoritesBinding().dependencies();
    registerLazy<PropertyLocalDataSource>(
      () => const PropertyMockLocalDataSource(),
    );
    registerLazy<PropertyRepository>(
      () => PropertyRepositoryImpl(Get.find<PropertyLocalDataSource>()),
    );
    registerLazy<GetPropertyByIdUseCase>(
      () => GetPropertyByIdUseCase(Get.find<PropertyRepository>()),
    );
    registerLazy<PropertyDetailsController>(
      () => PropertyDetailsController(
        Get.find<GetPropertyByIdUseCase>(),
        Get.find<FavoritesController>(),
      ),
    );
  }
}
