import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../routes/app_routes.dart';
import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../../properties/domain/entities/property_entity.dart';
import '../../domain/usecases/create_booking_usecase.dart';

class BookingFlowController extends GetxController {
  BookingFlowController(this._createBooking);

  final CreateBookingUseCase _createBooking;

  final Rxn<PropertyEntity> property = Rxn<PropertyEntity>();
  final Rx<DateTime> moveInDate =
      DateTime.now().add(const Duration(days: 14)).obs;
  final RxInt leaseMonths = 12.obs;
  final RxBool isSubmitting = false.obs;
  final TextEditingController notesController = TextEditingController();

  final List<int> leaseOptions = const <int>[3, 6, 12, 24];

  @override
  void onInit() {
    super.onInit();
    final Object? arguments = Get.arguments;
    if (arguments is PropertyEntity) {
      property.value = arguments;
    }
  }

  double get total => (property.value?.monthlyPrice ?? 0) * leaseMonths.value;

  void selectLease(int months) {
    if (leaseMonths.value != months) {
      leaseMonths.value = months;
    }
  }

  Future<void> pickMoveInDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year, now.month, now.day);
    final DateTime initial = moveInDate.value.isBefore(firstDate)
        ? firstDate
        : moveInDate.value;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 2),
      helpText: 'select_move_in'.tr,
      cancelText: 'cancel'.tr,
      confirmText: 'confirm'.tr,
    );
    if (picked != null) {
      moveInDate.value = picked;
    }
  }

  Future<void> submit() async {
    final PropertyEntity? current = property.value;
    if (current == null || isSubmitting.value) {
      return;
    }
    isSubmitting.value = true;
    try {
      await _createBooking(
        property: current,
        moveInDate: moveInDate.value,
        leaseMonths: leaseMonths.value,
        notes: notesController.text,
        tenantName: Get.find<AuthService>().displayName,
      );
      Get.snackbar(
        'booking_created'.tr,
        current.title(isArabicLocale()),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed(
        AppRoutes.main,
        arguments: <String, dynamic>{'tab': 2},
      );
      // The shell may already exist under this route, in which case its
      // controller is not re-created and arguments are ignored.
      Future<void>.delayed(Duration.zero, () {
        if (Get.isRegistered<MainNavController>()) {
          Get.find<MainNavController>().changeTab(2);
        }
      });
    } catch (_) {
      Get.snackbar(
        'app_name'.tr,
        'error_generic'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
