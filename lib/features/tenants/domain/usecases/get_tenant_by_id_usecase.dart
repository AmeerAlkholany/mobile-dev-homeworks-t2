import '../entities/tenant_entity.dart';
import '../repositories/tenants_repository.dart';

class GetTenantByIdUseCase {
  const GetTenantByIdUseCase(this._repository);

  final TenantsRepository _repository;

  Future<TenantEntity?> call(String id) => _repository.getTenantById(id);
}
