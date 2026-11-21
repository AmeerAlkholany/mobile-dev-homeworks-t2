import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/data_refresh_service.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/usecases/delete_tenant_usecase.dart';
import '../../domain/usecases/get_tenants_usecase.dart';

class TenantsController extends GetxController
    with StateMixin<List<TenantEntity>> {
  TenantsController(this._getTenants, this._deleteTenant, this._refresh);

  final GetTenantsUseCase _getTenants;
  final DeleteTenantUseCase _deleteTenant;
  final DataRefreshService _refresh;

  final RxList<TenantEntity> tenants = <TenantEntity>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<TenantStatus?> statusFilter = Rxn<TenantStatus>();
  final TextEditingController searchController = TextEditingController();

  Worker? _refreshWorker;

  @override
  void onInit() {
    super.onInit();
    _refreshWorker = _refresh.listen((int _) => loadTenants());
    loadTenants();
  }

  Future<void> loadTenants() async {
    change(null, status: RxStatus.loading());
    try {
      final List<TenantEntity> list = await _getTenants();
      tenants.assignAll(list);
      change(
        list,
        status: list.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (_) {
      change(null, status: RxStatus.error('error_tenants'.tr));
    }
  }

  List<TenantEntity> get filteredTenants {
    final String query = searchQuery.value.trim().toLowerCase();
    final DateTime today = DateTime.now();
    return tenants.where((TenantEntity tenant) {
      if (statusFilter.value != null &&
          tenant.statusOn(
                today,
                endingSoonDays: AppConstants.leaseEndingSoonDays,
              ) !=
              statusFilter.value) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final String haystack = <String>[
        tenant.fullName,
        tenant.phone,
        tenant.nationalId,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void setStatusFilter(TenantStatus? status) {
    statusFilter.value = status;
  }

  void openTenantDetails(TenantEntity tenant) {
    Get.toNamed(
      AppRoutes.tenantDetails,
      arguments: <String, dynamic>{'tenantId': tenant.id},
    );
  }

  void openTenantForm({TenantEntity? tenant}) {
    Get.toNamed(
      AppRoutes.tenantForm,
      arguments: tenant == null
          ? null
          : <String, dynamic>{'tenant': tenant},
    );
  }

  Future<void> deleteTenant(String id) async {
    try {
      await _deleteTenant(id);
      _refresh.notifyChanged();
      Get.snackbar(
        'app_name'.tr,
        'tenant_deleted'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      Get.snackbar(
        'app_name'.tr,
        'error_generic'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  void onClose() {
    _refreshWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }
}
