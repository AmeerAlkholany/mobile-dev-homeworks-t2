import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../../favorites/presentation/bindings/favorites_binding.dart';
import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../data/datasources/property_local_data_source.dart';
import '../../data/repositories/property_repository_impl.dart';
import '../../domain/repositories/property_repository.dart';
import '../../domain/usecases/get_properties_usecase.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    FavoritesBinding().dependencies();
    registerLazy<PropertyLocalDataSource>(
      () => const PropertyMockLocalDataSource(),
    );
    registerLazy<PropertyRepository>(
      () => PropertyRepositoryImpl(Get.find<PropertyLocalDataSource>()),
    );
    registerLazy<GetPropertiesUseCase>(
      () => GetPropertiesUseCase(Get.find<PropertyRepository>()),
    );
    registerLazy<HomeController>(
      () => HomeController(Get.find(), Get.find<FavoritesController>()),
    );
  }
}
