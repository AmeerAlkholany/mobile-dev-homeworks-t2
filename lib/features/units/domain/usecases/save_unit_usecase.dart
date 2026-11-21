import '../entities/unit_entity.dart';
import '../repositories/units_repository.dart';

class SaveUnitUseCase {
  const SaveUnitUseCase(this._repository);

  final UnitsRepository _repository;

  Future<UnitEntity> call(UnitEntity unit) => _repository.saveUnit(unit);
}
