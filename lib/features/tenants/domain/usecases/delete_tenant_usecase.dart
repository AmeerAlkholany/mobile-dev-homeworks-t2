import '../repositories/tenants_repository.dart';

class DeleteTenantUseCase {
  const DeleteTenantUseCase(this._repository);

  final TenantsRepository _repository;

  Future<void> call(String id) => _repository.deleteTenant(id);
}
