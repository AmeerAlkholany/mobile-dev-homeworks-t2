import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';

/// Persists only the property IDs; property details stay owned by the
/// properties feature.
abstract class FavoritesLocalDataSource {
  List<String> readFavoriteIds();

  Future<void> saveFavoriteIds(List<String> ids);
}

class FavoritesStorageDataSource implements FavoritesLocalDataSource {
  const FavoritesStorageDataSource(this._storage);

  final StorageService _storage;

  @override
  List<String> readFavoriteIds() {
    return _storage.readStringList(AppConstants.kFavoriteIds);
  }

  @override
  Future<void> saveFavoriteIds(List<String> ids) {
    return _storage.writeStringList(AppConstants.kFavoriteIds, ids);
  }
}
