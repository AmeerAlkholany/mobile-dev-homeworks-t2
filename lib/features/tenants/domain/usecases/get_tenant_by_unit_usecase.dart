import '../entities/tenant_entity.dart';
import '../repositories/tenants_repository.dart';

class GetTenantByUnitUseCase {
  const GetTenantByUnitUseCase(this._repository);

  final TenantsRepository _repository;

  Future<TenantEntity?> call(String unitId) =>
      _repository.getTenantByUnitId(unitId);
}
