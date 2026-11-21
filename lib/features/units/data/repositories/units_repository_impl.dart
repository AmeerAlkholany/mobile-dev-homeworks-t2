import '../../domain/entities/unit_entity.dart';
import '../../domain/repositories/units_repository.dart';
import '../datasources/units_local_data_source.dart';
import '../models/unit_model.dart';

class UnitsRepositoryImpl implements UnitsRepository {
  UnitsRepositoryImpl(this._localDataSource);

  final UnitsLocalDataSource _localDataSource;

  @override
  Future<List<UnitEntity>> getUnits() => _localDataSource.fetchUnits();

  @override
  Future<UnitEntity?> getUnitById(String id) async {
    final List<UnitEntity> units = await getUnits();
    for (final UnitEntity unit in units) {
      if (unit.id == id) {
        return unit;
      }
    }
    return null;
  }

  @override
  Future<UnitEntity> saveUnit(UnitEntity unit) async {
    final UnitModel model = UnitModel.fromEntity(unit);
    final UnitModel stored = unit.id.isEmpty
        ? UnitModel.fromEntity(
            model.copyWith(
              id: 'unit-${DateTime.now().microsecondsSinceEpoch}',
            ),
          )
        : model;
    await _localDataSource.saveUnit(stored);
    return stored;
  }

  @override
  Future<void> deleteUnit(String id) => _localDataSource.deleteUnit(id);
}
