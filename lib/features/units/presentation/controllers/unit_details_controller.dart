import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../tenants/domain/entities/tenant_entity.dart';
import '../../../tenants/domain/usecases/get_tenant_by_unit_usecase.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/usecases/delete_unit_usecase.dart';
import '../../domain/usecases/get_unit_by_id_usecase.dart';

class UnitDetailsBundle {
  const UnitDetailsBundle({required this.unit, this.tenant});

  final UnitEntity unit;
  final TenantEntity? tenant;
}

class UnitDetailsController
    extends GetxController with StateMixin<UnitDetailsBundle> {
  UnitDetailsController(
    this._getUnit,
    this._getTenantByUnit,
    this._deleteUnit,
    this._refresh,
    this._unitId,
  );

  final GetUnitByIdUseCase _getUnit;
  final GetTenantByUnitUseCase _getTenantByUnit;
  final DeleteUnitUseCase _deleteUnit;
  final DataRefreshService _refresh;
  final String _unitId;

  UnitEntity? unit;

  /// Last loaded bundle. Exposed publicly because `StateMixin.value` is
  /// protected and pages only need to read it.
  final Rxn<UnitDetailsBundle> bundle = Rxn<UnitDetailsBundle>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    bundle.value = null;
    change(null, status: RxStatus.loading());
    try {
      final UnitEntity? found = await _getUnit(_unitId);
      if (found == null) {
        unit = null;
        change(null, status: RxStatus.error('unit_not_found'.tr));
        return;
      }
      unit = found;
      final TenantEntity? tenant =
          found.isOccupied ? await _getTenantByUnit(found.id) : null;
      bundle.value = UnitDetailsBundle(unit: found, tenant: tenant);
      change(bundle.value, status: RxStatus.success());
    } catch (_) {
      change(null, status: RxStatus.error('error_units'.tr));
    }
  }

  void edit() {
    final UnitEntity? current = unit;
    if (current == null) {
      return;
    }
    Get.toNamed(
      AppRoutes.unitForm,
      arguments: <String, dynamic>{'unit': current},
    );
  }

  void openTenant(TenantEntity tenant) {
    Get.toNamed(
      AppRoutes.tenantDetails,
      arguments: <String, dynamic>{'tenantId': tenant.id},
    );
  }

  void openPaymentHistory() {
    Get.offAllNamed(
      AppRoutes.main,
      arguments: <String, dynamic>{'tab': 3},
    );
  }

  Future<void> delete() async {
    final UnitEntity? current = unit;
    if (current == null) {
      return;
    }
    try {
      await _deleteUnit(current.id);
      _refresh.notifyChanged();
      Get.back<void>();
      Get.snackbar(
        'app_name'.tr,
        'unit_deleted'.tr,
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
}
