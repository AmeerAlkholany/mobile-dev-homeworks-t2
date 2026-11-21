import '../entities/unit_entity.dart';

/// Contract for reading and mutating building units.
abstract class UnitsRepository {
  Future<List<UnitEntity>> getUnits();

  Future<UnitEntity?> getUnitById(String id);

  /// Creates a unit when [UnitEntity.id] is empty, otherwise updates it.
  Future<UnitEntity> saveUnit(UnitEntity unit);

  Future<void> deleteUnit(String id);
}
