import '../entities/unit_entity.dart';
import '../repositories/units_repository.dart';

class GetUnitByIdUseCase {
  const GetUnitByIdUseCase(this._repository);

  final UnitsRepository _repository;

  Future<UnitEntity?> call(String id) => _repository.getUnitById(id);
}
