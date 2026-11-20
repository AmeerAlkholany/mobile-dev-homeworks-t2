import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/property_local_data_source.dart';

/// Applies discovery filters over the data source and exposes pure domain
/// entities to the use cases.
class PropertyRepositoryImpl implements PropertyRepository {
  PropertyRepositoryImpl(this._localDataSource);

  final PropertyLocalDataSource _localDataSource;

  @override
  Future<List<PropertyEntity>> getProperties({
    String? query,
    PropertyCategory? category,
    String? cityKey,
    double? maxPrice,
  }) async {
    final List<PropertyEntity> all = await _localDataSource.fetchProperties();
    final String needle = (query ?? '').trim().toLowerCase();

    Iterable<PropertyEntity> filtered = all;

    if (needle.isNotEmpty) {
      filtered = filtered.where((PropertyEntity property) {
        final List<String> haystack = <String>[
          property.titleEn,
          property.titleAr,
          property.districtEn,
          property.districtAr,
          property.cityKey,
        ];
        return haystack.any(
          (String value) => value.toLowerCase().contains(needle),
        );
      });
    }

    if (category != null) {
      filtered = filtered.where(
        (PropertyEntity property) => property.category == category,
      );
    }

    if (cityKey != null && cityKey.isNotEmpty) {
      filtered = filtered.where(
        (PropertyEntity property) => property.cityKey == cityKey,
      );
    }

    if (maxPrice != null) {
      filtered = filtered.where(
        (PropertyEntity property) => property.monthlyPrice <= maxPrice,
      );
    }

    final List<PropertyEntity> result = filtered.toList()
      ..sort((PropertyEntity a, PropertyEntity b) {
        if (a.featured != b.featured) {
          return a.featured ? -1 : 1;
        }
        return b.rating.compareTo(a.rating);
      });
    return result;
  }

  @override
  Future<PropertyEntity> getPropertyById(String id) async {
    final PropertyEntity property = await _localDataSource.fetchPropertyById(id);
    return property;
  }
}
