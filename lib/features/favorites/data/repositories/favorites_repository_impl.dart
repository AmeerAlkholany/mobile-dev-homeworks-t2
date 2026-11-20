import '../../../properties/domain/entities/property_entity.dart';
import '../../../properties/domain/repositories/property_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

/// Resolves saved IDs into full properties through the properties domain
/// contract, then persists mutations through the local data source.
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._localDataSource, this._propertyRepository);

  final FavoritesLocalDataSource _localDataSource;
  final PropertyRepository _propertyRepository;

  @override
  Future<List<String>> getFavoriteIds() async {
    return _localDataSource.readFavoriteIds();
  }

  @override
  Future<List<PropertyEntity>> getFavorites() async {
    final List<String> ids = _localDataSource.readFavoriteIds();
    if (ids.isEmpty) {
      return <PropertyEntity>[];
    }
    final List<PropertyEntity> properties =
        await _propertyRepository.getProperties();
    return properties
        .where((PropertyEntity property) => ids.contains(property.id))
        .toList();
  }

  @override
  Future<bool> toggleFavorite(String propertyId) async {
    final List<String> ids = List<String>.from(
      _localDataSource.readFavoriteIds(),
    );
    final bool isFavorite = ids.contains(propertyId);
    if (isFavorite) {
      ids.remove(propertyId);
    } else {
      ids.insert(0, propertyId);
    }
    await _localDataSource.saveFavoriteIds(ids);
    return !isFavorite;
  }
}
