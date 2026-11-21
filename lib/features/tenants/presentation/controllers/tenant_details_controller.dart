import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../payments/domain/usecases/get_tenant_payments_usecase.dart';
import '../../../units/domain/entities/unit_entity.dart';
import '../../../units/domain/usecases/get_unit_by_id_usecase.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/usecases/delete_tenant_usecase.dart';
import '../../domain/usecases/get_tenant_by_id_usecase.dart';

class TenantDetailsBundle {
  const TenantDetailsBundle({
    required this.tenant,
    this.unit,
    required this.payments,
  });

  final TenantEntity tenant;
  final UnitEntity? unit;
  final List<PaymentEntity> payments;

  double get remainingBalance =>
      payments.fold<double>(0, (double sum, PaymentEntity p) => sum + p.balance);
}

class TenantDetailsController
    extends GetxController with StateMixin<TenantDetailsBundle> {
  TenantDetailsController(
    this._getTenant,
    this._getUnit,
    this._getPayments,
    this._deleteTenant,
    this._refresh,
    this._tenantId,
  );

  final GetTenantByIdUseCase _getTenant;
  final GetUnitByIdUseCase _getUnit;
  final GetTenantPaymentsUseCase _getPayments;
  final DeleteTenantUseCase _deleteTenant;
  final DataRefreshService _refresh;

  final String _tenantId;

  TenantEntity? tenant;

  /// Last loaded bundle. Exposed publicly because `StateMixin.value` is
  /// protected and pages only need to read it.
  final Rxn<TenantDetailsBundle> bundle = Rxn<TenantDetailsBundle>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    bundle.value = null;
    change(null, status: RxStatus.loading());
    try {
      final TenantEntity? found = await _getTenant(_tenantId);
      if (found == null) {
        tenant = null;
        change(null, status: RxStatus.error('error_tenants'.tr));
        return;
      }
      tenant = found;
      final UnitEntity? unit = await _getUnit(found.unitId);
      final List<PaymentEntity> payments = await _getPayments(found.id);
      bundle.value = TenantDetailsBundle(
        tenant: found,
        unit: unit,
        payments: payments,
      );
      change(bundle.value, status: RxStatus.success());
    } catch (_) {
      change(null, status: RxStatus.error('error_tenants'.tr));
    }
  }

  void edit() {
    final TenantEntity? current = tenant;
    if (current == null) {
      return;
    }
    Get.toNamed(
      AppRoutes.tenantForm,
      arguments: <String, dynamic>{'tenant': current},
    );
  }

  Future<void> delete() async {
    final TenantEntity? current = tenant;
    if (current == null) {
      return;
    }
    try {
      await _deleteTenant(current.id);
      _refresh.notifyChanged();
      Get.back<void>();
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
}
