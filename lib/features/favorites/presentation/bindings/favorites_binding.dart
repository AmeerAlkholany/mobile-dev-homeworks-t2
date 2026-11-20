import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../../properties/data/datasources/property_local_data_source.dart';
import '../../../properties/data/repositories/property_repository_impl.dart';
import '../../../properties/domain/repositories/property_repository.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/get_favorite_ids_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    // Favorites resolve saved IDs through the properties domain contract, so
    // make sure that contract exists even when this binding runs first.
    registerLazy<PropertyLocalDataSource>(
      () => const PropertyMockLocalDataSource(),
    );
    registerLazy<PropertyRepository>(
      () => PropertyRepositoryImpl(Get.find<PropertyLocalDataSource>()),
    );
    registerLazy<FavoritesLocalDataSource>(
      () => FavoritesStorageDataSource(Get.find()),
    );
    registerLazy<FavoritesRepository>(
      () => FavoritesRepositoryImpl(
        Get.find<FavoritesLocalDataSource>(),
        Get.find<PropertyRepository>(),
      ),
    );
    registerLazy<GetFavoriteIdsUseCase>(
      () => GetFavoriteIdsUseCase(Get.find<FavoritesRepository>()),
    );
    registerLazy<GetFavoritesUseCase>(
      () => GetFavoritesUseCase(Get.find<FavoritesRepository>()),
    );
    registerLazy<ToggleFavoriteUseCase>(
      () => ToggleFavoriteUseCase(Get.find<FavoritesRepository>()),
    );
    registerLazy<FavoritesController>(
      () => FavoritesController(Get.find(), Get.find(), Get.find()),
    );
  }
}
