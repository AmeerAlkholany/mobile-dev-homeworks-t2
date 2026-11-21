import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../units/domain/entities/unit_entity.dart';
import '../../../units/domain/usecases/get_units_usecase.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/usecases/save_tenant_usecase.dart';

class TenantFormController extends GetxController {
  TenantFormController(
    this._save,
    this._getUnits,
    this._refresh,
    this._existing,
  ) {
    fullNameController =
        TextEditingController(text: _existing?.fullName ?? '');
    phoneController = TextEditingController(text: _existing?.phone ?? '');
    nationalIdController =
        TextEditingController(text: _existing?.nationalId ?? '');
    rentController = TextEditingController(
      text: _existing == null ? '' : _trimNumber(_existing.monthlyRent),
    );
    notesController = TextEditingController(text: _existing?.notes ?? '');

    selectedUnitId.value = _existing?.unitId;
    leaseStart.value = _existing?.leaseStart ?? DateTime.now();
    leaseEnd.value =
        _existing?.leaseEnd ?? DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
  }

  final SaveTenantUseCase _save;
  final GetUnitsUseCase _getUnits;
  final DataRefreshService _refresh;
  final TenantEntity? _existing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController phoneController;
  late final TextEditingController nationalIdController;
  late final TextEditingController rentController;
  late final TextEditingController notesController;

  final RxList<UnitEntity> units = <UnitEntity>[].obs;
  final RxnString selectedUnitId = RxnString();
  final Rx<DateTime> leaseStart = DateTime.now().obs;
  final Rx<DateTime> leaseEnd = DateTime.now().obs;
  final RxBool isLoading = false.obs;

  bool get isEditing => _existing != null;

  /// Vacant units plus the unit the tenant already holds while editing.
  List<UnitEntity> get availableUnits => units
      .where(
        (UnitEntity unit) =>
            unit.isVacant || unit.id == selectedUnitId.value,
      )
      .toList();

  @override
  void onInit() {
    super.onInit();
    loadUnits();
  }

  Future<void> loadUnits() async {
    try {
      units.assignAll(await _getUnits());
    } catch (_) {
      units.clear();
    }
  }

  void selectUnit(UnitEntity unit) {
    selectedUnitId.value = unit.id;
    if (rentController.text.trim().isEmpty) {
      rentController.text = _trimNumber(unit.monthlyRent);
    }
  }

  String? validateFullName(String? value) => AppValidators.required(value);

  String? validatePhone(String? value) => AppValidators.phone(value);

  String? validateNationalId(String? value) =>
      AppValidators.nationalId(value);

  String? validateRent(String? value) => AppValidators.amount(value);

  Future<void> pickLeaseDate(
    BuildContext context, {
    required bool start,
  }) async {
    final DateTime initial = start ? leaseStart.value : leaseEnd.value;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }
    if (start) {
      leaseStart.value = picked;
      if (!leaseEnd.value.isAfter(picked)) {
        leaseEnd.value =
            DateTime(picked.year + 1, picked.month, picked.day);
      }
    } else {
      leaseEnd.value = picked;
      if (picked.isBefore(leaseStart.value)) {
        leaseStart.value = picked;
      }
    }
  }

  Future<void> submit() async {
    if (isLoading.value) {
      return;
    }
    final FormState? form = formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (selectedUnitId.value == null) {
      Get.snackbar(
        'app_name'.tr,
        'select_unit'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    try {
      final TenantEntity tenant = TenantEntity(
        id: _existing?.id ?? '',
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        nationalId: nationalIdController.text.trim(),
        unitId: selectedUnitId.value!,
        monthlyRent:
            double.tryParse(rentController.text.trim().replaceAll(',', '')) ??
                0,
        leaseStart: leaseStart.value,
        leaseEnd: leaseEnd.value,
        notes: notesController.text.trim(),
      );
      await _save(tenant);
      _refresh.notifyChanged();
      Get.snackbar(
        'app_name'.tr,
        isEditing ? 'tenant_updated'.tr : 'tenant_created'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.back<void>();
    } catch (_) {
      Get.snackbar(
        'app_name'.tr,
        'error_generic'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _trimNumber(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    rentController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
