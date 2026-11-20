import '../entities/property_entity.dart';

/// Domain contract for property discovery. Implementations live in `data/`.
abstract class PropertyRepository {
  Future<List<PropertyEntity>> getProperties({
    String? query,
    PropertyCategory? category,
    String? cityKey,
    double? maxPrice,
  });

  Future<PropertyEntity> getPropertyById(String id);
}
