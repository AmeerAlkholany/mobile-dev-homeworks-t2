import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';

/// Async bookings list driven by `StateMixin`; `update()` is called so the
/// screen can also be refreshed with `GetBuilder`.
class MyBookingsController extends GetxController
    with StateMixin<List<BookingEntity>> {
  MyBookingsController(this._getBookings, this._cancelBooking);

  final GetBookingsUseCase _getBookings;
  final CancelBookingUseCase _cancelBooking;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings() async {
    change(null, status: RxStatus.loading());
    update();
    try {
      final List<BookingEntity> bookings = await _getBookings();
      change(
        bookings,
        status: bookings.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (_) {
      change(null, status: RxStatus.error('error_bookings'.tr));
    }
    update();
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _cancelBooking(bookingId);
      Get.snackbar(
        'booking_cancelled_message'.tr,
        'app_name'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      await loadBookings();
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
