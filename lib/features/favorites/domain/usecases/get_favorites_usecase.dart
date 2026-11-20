import '../../../properties/domain/entities/property_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  const GetFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<List<PropertyEntity>> call() => _repository.getFavorites();
}
