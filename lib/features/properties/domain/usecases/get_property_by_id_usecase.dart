import '../entities/property_entity.dart';
import '../repositories/property_repository.dart';

/// Loads a single property for the details screen.
class GetPropertyByIdUseCase {
  const GetPropertyByIdUseCase(this._repository);

  final PropertyRepository _repository;

  Future<PropertyEntity> call(String id) => _repository.getPropertyById(id);
}
