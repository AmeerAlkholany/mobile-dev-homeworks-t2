import 'package:flutter_application_1/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:flutter_application_1/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:flutter_application_1/features/properties/domain/entities/property_entity.dart';
import 'package:flutter_application_1/features/properties/domain/repositories/property_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_property.dart';

class _InMemoryFavoritesDataSource implements FavoritesLocalDataSource {
  List<String> ids = <String>[];

  @override
  List<String> readFavoriteIds() => List<String>.from(ids);

  @override
  Future<void> saveFavoriteIds(List<String> ids) async {
    this.ids = List<String>.from(ids);
  }
}

class _FakePropertyRepository implements PropertyRepository {
  _FakePropertyRepository(this.properties);

  final List<PropertyEntity> properties;

  @override
  Future<List<PropertyEntity>> getProperties({
    String? query,
    PropertyCategory? category,
    String? cityKey,
    double? maxPrice,
  }) async {
    return properties;
  }

  @override
  Future<PropertyEntity> getPropertyById(String id) async {
    return properties.firstWhere((PropertyEntity property) => property.id == id);
  }
}

void main() {
  late _InMemoryFavoritesDataSource dataSource;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    dataSource = _InMemoryFavoritesDataSource();
    repository = FavoritesRepositoryImpl(
      dataSource,
      _FakePropertyRepository(<PropertyEntity>[
        fakeProperty(id: 'p1'),
        fakeProperty(id: 'p2', titleEn: 'Second'),
      ]),
    );
  });

  test('toggles a favorite on and off with persistence', () async {
    expect(await repository.toggleFavorite('p1'), isTrue);
    expect(dataSource.ids, <String>['p1']);
    expect(await repository.getFavoriteIds(), <String>['p1']);

    final List<PropertyEntity> favorites = await repository.getFavorites();
    expect(favorites, hasLength(1));
    expect(favorites.single.id, 'p1');

    expect(await repository.toggleFavorite('p1'), isFalse);
    expect(dataSource.ids, isEmpty);
    expect(await repository.getFavorites(), isEmpty);
  });

  test('resolves only known favorites', () async {
    await repository.toggleFavorite('p2');
    await repository.toggleFavorite('unknown');

    final List<PropertyEntity> favorites = await repository.getFavorites();
    expect(favorites.single.id, 'p2');
  });
}
