import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../tenants/domain/entities/tenant_entity.dart';
import '../../../tenants/domain/usecases/get_tenant_by_unit_usecase.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/usecases/get_unit_by_id_usecase.dart';

class UnitDetailsBundle {
  const UnitDetailsBundle({required this.unit, this.tenant});

  final UnitEntity unit;
  final TenantEntity? tenant;
}

class UnitDetailsController
    extends GetxController with StateMixin<UnitDetailsBundle> {
  UnitDetailsController(this._getUnit, this._getTenantByUnit, this._unitId);

  final GetUnitByIdUseCase _getUnit;
  final GetTenantByUnitUseCase _getTenantByUnit;
  final String _unitId;

  UnitEntity? unit;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
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
      change(
        UnitDetailsBundle(unit: found, tenant: tenant),
        status: RxStatus.success(),
      );
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
}
