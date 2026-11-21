import '../entities/tenant_entity.dart';
import '../repositories/tenants_repository.dart';

class GetTenantsUseCase {
  const GetTenantsUseCase(this._repository);

  final TenantsRepository _repository;

  Future<List<TenantEntity>> call() => _repository.getTenants();
}
