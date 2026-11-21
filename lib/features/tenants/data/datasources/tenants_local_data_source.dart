import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/tenant_model.dart';
import 'tenants_mock_data.dart';

abstract class TenantsLocalDataSource {
  Future<List<TenantModel>> fetchTenants();

  Future<void> saveTenant(TenantModel tenant);

  Future<void> deleteTenant(String id);
}

/// GetStorage-backed tenant store with one-time demo seeding.
class TenantsStorageDataSource implements TenantsLocalDataSource {
  const TenantsStorageDataSource(this._storage);

  final StorageService _storage;

  @override
  Future<List<TenantModel>> fetchTenants() async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);
    if (!_storage.readBool(AppConstants.kTenantsSeeded)) {
      final List<TenantModel> seed = TenantMockData.build();
      await _writeAll(seed);
      await _storage.writeBool(AppConstants.kTenantsSeeded, true);
      return seed;
    }
    return _readAll();
  }

  @override
  Future<void> saveTenant(TenantModel tenant) async {
    final List<TenantModel> tenants = _readAll();
    final int index =
        tenants.indexWhere((TenantModel item) => item.id == tenant.id);
    if (index == -1) {
      tenants.add(tenant);
    } else {
      tenants[index] = tenant;
    }
    await _writeAll(tenants);
  }

  @override
  Future<void> deleteTenant(String id) async {
    final List<TenantModel> tenants = _readAll()
      ..removeWhere((TenantModel item) => item.id == id);
    await _writeAll(tenants);
  }

  List<TenantModel> _readAll() {
    return _storage
        .readListOfMaps(AppConstants.kTenants)
        .map(TenantModel.fromJson)
        .toList();
  }

  Future<void> _writeAll(List<TenantModel> tenants) {
    return _storage.writeListOfMaps(
      AppConstants.kTenants,
      tenants.map((TenantModel tenant) => tenant.toJson()).toList(),
    );
  }
}
