import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/unit_model.dart';
import 'units_mock_data.dart';

abstract class UnitsLocalDataSource {
  Future<List<UnitModel>> fetchUnits();

  Future<void> saveUnit(UnitModel unit);

  Future<void> deleteUnit(String id);
}

/// GetStorage-backed unit store. The demo building is seeded once, then every
/// create / update / delete is persisted immediately.
class UnitsStorageDataSource implements UnitsLocalDataSource {
  const UnitsStorageDataSource(this._storage);

  final StorageService _storage;

  @override
  Future<List<UnitModel>> fetchUnits() async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);
    if (!_storage.readBool(AppConstants.kUnitsSeeded)) {
      final List<UnitModel> seed = UnitMockData.build();
      await _writeAll(seed);
      await _storage.writeBool(AppConstants.kUnitsSeeded, true);
      return seed;
    }
    return _readAll();
  }

  @override
  Future<void> saveUnit(UnitModel unit) async {
    final List<UnitModel> units = _readAll();
    final int index = units.indexWhere((UnitModel item) => item.id == unit.id);
    if (index == -1) {
      units.add(unit);
    } else {
      units[index] = unit;
    }
    await _writeAll(units);
  }

  @override
  Future<void> deleteUnit(String id) async {
    final List<UnitModel> units = _readAll()
      ..removeWhere((UnitModel item) => item.id == id);
    await _writeAll(units);
  }

  List<UnitModel> _readAll() {
    return _storage
        .readListOfMaps(AppConstants.kUnits)
        .map(UnitModel.fromJson)
        .toList();
  }

  Future<void> _writeAll(List<UnitModel> units) {
    return _storage.writeListOfMaps(
      AppConstants.kUnits,
      units.map((UnitModel unit) => unit.toJson()).toList(),
    );
  }
}
