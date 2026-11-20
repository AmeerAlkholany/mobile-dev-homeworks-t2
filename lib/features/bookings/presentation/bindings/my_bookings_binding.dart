import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../controllers/my_bookings_controller.dart';
import 'bookings_dependencies.dart';

class MyBookingsBinding extends Bindings {
  @override
  void dependencies() {
    registerBookingDependencies();
    registerLazy<MyBookingsController>(
      () => MyBookingsController(
        Get.find<GetBookingsUseCase>(),
        Get.find<CancelBookingUseCase>(),
      ),
    );
  }
}
