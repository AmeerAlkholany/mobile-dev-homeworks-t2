import '../entities/tenant_entity.dart';
import '../repositories/tenants_repository.dart';

class SaveTenantUseCase {
  const SaveTenantUseCase(this._repository);

  final TenantsRepository _repository;

  Future<TenantEntity> call(TenantEntity tenant) =>
      _repository.saveTenant(tenant);
}
