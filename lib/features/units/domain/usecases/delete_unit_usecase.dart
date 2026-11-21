import '../repositories/units_repository.dart';

class DeleteUnitUseCase {
  const DeleteUnitUseCase(this._repository);

  final UnitsRepository _repository;

  Future<void> call(String id) => _repository.deleteUnit(id);
}
