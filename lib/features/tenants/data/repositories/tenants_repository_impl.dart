import '../../../units/domain/entities/unit_entity.dart';
import '../../../units/domain/repositories/units_repository.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/repositories/tenants_repository.dart';
import '../datasources/tenants_local_data_source.dart';
import '../models/tenant_model.dart';

/// Tenant storage plus the occupancy side effects on the assigned unit.
class TenantsRepositoryImpl implements TenantsRepository {
  TenantsRepositoryImpl(this._localDataSource, this._unitsRepository);

  final TenantsLocalDataSource _localDataSource;
  final UnitsRepository _unitsRepository;

  @override
  Future<List<TenantEntity>> getTenants() => _localDataSource.fetchTenants();

  @override
  Future<TenantEntity?> getTenantById(String id) async {
    final List<TenantEntity> tenants = await getTenants();
    for (final TenantEntity tenant in tenants) {
      if (tenant.id == id) {
        return tenant;
      }
    }
    return null;
  }

  @override
  Future<TenantEntity?> getTenantByUnitId(String unitId) async {
    final List<TenantEntity> tenants = await getTenants();
    final DateTime today = DateTime.now();
    TenantEntity? fallback;
    for (final TenantEntity tenant in tenants) {
      if (tenant.unitId != unitId) {
        continue;
      }
      fallback ??= tenant;
      if (tenant.statusOn(today) != TenantStatus.ended) {
        return tenant;
      }
    }
    return fallback;
  }

  @override
  Future<TenantEntity> saveTenant(TenantEntity tenant) async {
    final List<TenantEntity> tenants = await _localDataSource.fetchTenants();
    TenantEntity? previous;
    for (final TenantEntity item in tenants) {
      if (item.id == tenant.id && tenant.id.isNotEmpty) {
        previous = item;
      }
    }

    final String id = tenant.id.isEmpty
        ? 'tenant-${DateTime.now().microsecondsSinceEpoch}'
        : tenant.id;
    final TenantModel stored = TenantModel.fromEntity(tenant.copyWith(id: id));

    if (previous != null && previous.unitId != stored.unitId) {
      await _releaseUnit(previous.unitId, keepTenantId: stored.id);
    }
    await _localDataSource.saveTenant(stored);
    await _occupyUnit(stored.unitId);
    return stored;
  }

  @override
  Future<void> deleteTenant(String id) async {
    final List<TenantEntity> tenants = await _localDataSource.fetchTenants();
    TenantEntity? target;
    for (final TenantEntity tenant in tenants) {
      if (tenant.id == id) {
        target = tenant;
      }
    }
    await _localDataSource.deleteTenant(id);
    if (target != null) {
      await _releaseUnit(target.unitId, keepTenantId: id);
    }
  }

  Future<void> _occupyUnit(String unitId) async {
    if (unitId.isEmpty) {
      return;
    }
    final UnitEntity? unit = await _unitsRepository.getUnitById(unitId);
    if (unit != null && unit.status != UnitStatus.occupied) {
      await _unitsRepository.saveUnit(
        unit.copyWith(status: UnitStatus.occupied),
      );
    }
  }

  Future<void> _releaseUnit(
    String unitId, {
    required String keepTenantId,
  }) async {
    if (unitId.isEmpty) {
      return;
    }
    final List<TenantEntity> tenants = await _localDataSource.fetchTenants();
    final bool stillAssigned = tenants.any(
      (TenantEntity tenant) =>
          tenant.unitId == unitId && tenant.id != keepTenantId,
    );
    if (stillAssigned) {
      return;
    }
    final UnitEntity? unit = await _unitsRepository.getUnitById(unitId);
    if (unit != null && unit.status == UnitStatus.occupied) {
      await _unitsRepository.saveUnit(
        unit.copyWith(status: UnitStatus.vacant),
      );
    }
  }
}
