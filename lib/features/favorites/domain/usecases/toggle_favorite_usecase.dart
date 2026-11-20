import '../repositories/favorites_repository.dart';

/// Adds or removes a property from favorites and returns the new state.
class ToggleFavoriteUseCase {
  const ToggleFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<bool> call(String propertyId) =>
      _repository.toggleFavorite(propertyId);
}
