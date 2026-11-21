import '../entities/unit_entity.dart';
import '../repositories/units_repository.dart';

class GetUnitsUseCase {
  const GetUnitsUseCase(this._repository);

  final UnitsRepository _repository;

  Future<List<UnitEntity>> call() => _repository.getUnits();
}
