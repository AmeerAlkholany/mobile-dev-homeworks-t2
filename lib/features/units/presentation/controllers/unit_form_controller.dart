import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/usecases/save_unit_usecase.dart';

class UnitFormController extends GetxController {
  UnitFormController(this._save, this._refresh, this._existing) {
    unitNumberController = TextEditingController(
      text: _existing?.unitNumber ?? '',
    );
    floorController = TextEditingController(
      text: _existing == null ? '' : '${_existing!.floor}',
    );
    rentController = TextEditingController(
      text: _existing == null ? '' : _trimNumber(_existing!.monthlyRent),
    );
    bedroomsController = TextEditingController(
      text: _existing == null ? '' : '${_existing!.bedrooms}',
    );
    areaController = TextEditingController(
      text: _existing == null ? '' : _trimNumber(_existing!.areaSqm),
    );
    notesController = TextEditingController(text: _existing?.notes ?? '');
    type.value = _existing?.type ?? UnitType.apartment;
    status.value = _existing?.status ?? UnitStatus.vacant;
  }

  final SaveUnitUseCase _save;
  final DataRefreshService _refresh;
  final UnitEntity? _existing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController unitNumberController;
  late final TextEditingController floorController;
  late final TextEditingController rentController;
  late final TextEditingController bedroomsController;
  late final TextEditingController areaController;
  late final TextEditingController notesController;

  final Rx<UnitType> type = UnitType.apartment.obs;
  final Rx<UnitStatus> status = UnitStatus.vacant.obs;
  final RxBool isLoading = false.obs;

  bool get isEditing => _existing != null;

  void setType(UnitType value) => type.value = value;

  void setStatus(UnitStatus value) => status.value = value;

  String? validateUnitNumber(String? value) =>
      AppValidators.required(value);

  String? validateFloor(String? value) {
    final String? empty = AppValidators.required(value);
    if (empty != null) {
      return empty;
    }
    if (int.tryParse(value!.trim()) == null) {
      return 'validation_number'.tr;
    }
    return null;
  }

  String? validateRent(String? value) => AppValidators.amount(value);

  String? validateBedrooms(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (int.tryParse(value.trim()) == null) {
      return 'validation_number'.tr;
    }
    return null;
  }

  String? validateArea(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (double.tryParse(value.trim()) == null) {
      return 'validation_number'.tr;
    }
    return null;
  }

  Future<void> submit() async {
    if (isLoading.value) {
      return;
    }
    final FormState? form = formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    isLoading.value = true;
    try {
      final UnitEntity unit = UnitEntity(
        id: _existing?.id ?? '',
        unitNumber: unitNumberController.text.trim(),
        floor: int.tryParse(floorController.text.trim()) ?? 0,
        type: type.value,
        monthlyRent:
            double.tryParse(rentController.text.trim().replaceAll(',', '')) ??
                0,
        status: status.value,
        bedrooms: int.tryParse(bedroomsController.text.trim()) ?? 0,
        areaSqm:
            double.tryParse(areaController.text.trim().replaceAll(',', '')) ??
                0,
        notes: notesController.text.trim(),
      );
      await _save(unit);
      _refresh.notifyChanged();
      Get.snackbar(
        'app_name'.tr,
        isEditing ? 'unit_updated'.tr : 'unit_created'.tr,
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
    unitNumberController.dispose();
    floorController.dispose();
    rentController.dispose();
    bedroomsController.dispose();
    areaController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
