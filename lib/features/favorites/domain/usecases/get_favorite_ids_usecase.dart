import '../repositories/favorites_repository.dart';

class GetFavoriteIdsUseCase {
  const GetFavoriteIdsUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<List<String>> call() => _repository.getFavoriteIds();
}
