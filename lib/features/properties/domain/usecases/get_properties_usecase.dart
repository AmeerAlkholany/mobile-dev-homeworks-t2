import '../entities/property_entity.dart';
import '../repositories/property_repository.dart';

/// Fetches the property feed with the active discovery filters applied.
class GetPropertiesUseCase {
  const GetPropertiesUseCase(this._repository);

  final PropertyRepository _repository;

  Future<List<PropertyEntity>> call({
    String? query,
    PropertyCategory? category,
    String? cityKey,
    double? maxPrice,
  }) {
    return _repository.getProperties(
      query: query,
      category: category,
      cityKey: cityKey,
      maxPrice: maxPrice,
    );
  }
}
