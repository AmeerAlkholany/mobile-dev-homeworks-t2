import '../entities/tenant_entity.dart';

/// Contract for tenant and lease management.
abstract class TenantsRepository {
  Future<List<TenantEntity>> getTenants();

  Future<TenantEntity?> getTenantById(String id);

  /// The tenant currently holding [unitId], if any.
  Future<TenantEntity?> getTenantByUnitId(String unitId);

  /// Creates a tenant when [TenantEntity.id] is empty, otherwise updates it.
  /// Also keeps the assigned unit's occupancy status in sync.
  Future<TenantEntity> saveTenant(TenantEntity tenant);

  Future<void> deleteTenant(String id);
}
