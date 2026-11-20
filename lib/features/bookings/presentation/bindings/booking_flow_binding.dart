import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../controllers/booking_flow_controller.dart';
import 'bookings_dependencies.dart';

class BookingFlowBinding extends Bindings {
  @override
  void dependencies() {
    registerBookingDependencies();
    registerLazy<BookingFlowController>(
      () => BookingFlowController(Get.find<CreateBookingUseCase>()),
    );
  }
}
