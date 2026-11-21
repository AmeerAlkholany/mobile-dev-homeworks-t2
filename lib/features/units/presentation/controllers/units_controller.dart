import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/data_refresh_service.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/usecases/delete_unit_usecase.dart';
import '../../domain/usecases/get_units_usecase.dart';

class UnitsController extends GetxController with StateMixin<List<UnitEntity>> {
  UnitsController(this._getUnits, this._deleteUnit, this._refresh);

  final GetUnitsUseCase _getUnits;
  final DeleteUnitUseCase _deleteUnit;
  final DataRefreshService _refresh;

  final RxList<UnitEntity> units = <UnitEntity>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<UnitStatus?> statusFilter = Rxn<UnitStatus>();
  final TextEditingController searchController = TextEditingController();

  Worker? _refreshWorker;

  @override
  void onInit() {
    super.onInit();
    _refreshWorker = _refresh.listen((int _) => loadUnits());
    loadUnits();
  }

  Future<void> loadUnits() async {
    change(null, status: RxStatus.loading());
    try {
      final List<UnitEntity> list = await _getUnits();
      units.assignAll(list);
      change(
        list,
        status: list.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (_) {
      change(null, status: RxStatus.error('error_units'.tr));
    }
  }

  List<UnitEntity> get filteredUnits {
    final String query = searchQuery.value.trim().toLowerCase();
    return units.where((UnitEntity unit) {
      if (statusFilter.value != null && unit.status != statusFilter.value) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final String haystack = <String>[
        unit.unitNumber,
        unit.type.localizationKey.tr,
        unit.notes,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void setStatusFilter(UnitStatus? status) {
    statusFilter.value = status;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  Future<void> deleteUnit(String id) async {
    try {
      await _deleteUnit(id);
      _refresh.notifyChanged();
      Get.snackbar(
        'app_name'.tr,
        'unit_deleted'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      _showError();
    }
  }

  void openUnitForm({UnitEntity? unit}) {
    Get.toNamed(
      AppRoutes.unitForm,
      arguments: unit == null
          ? null
          : <String, dynamic>{'unit': unit},
    );
  }

  void openUnitDetails(UnitEntity unit) {
    Get.toNamed(
      AppRoutes.unitDetails,
      arguments: <String, dynamic>{'unitId': unit.id},
    );
  }

  void _showError() {
    Get.snackbar(
      'app_name'.tr,
      'error_generic'.tr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    _refreshWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }
}
