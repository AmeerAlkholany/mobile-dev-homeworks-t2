import '../../../properties/domain/entities/property_entity.dart';

/// Contract for the saved-properties list. Persistence is an implementation
/// detail of `data/`.
abstract class FavoritesRepository {
  Future<List<String>> getFavoriteIds();

  Future<List<PropertyEntity>> getFavorites();

  /// Returns `true` when the property is now a favorite.
  Future<bool> toggleFavorite(String propertyId);
}
