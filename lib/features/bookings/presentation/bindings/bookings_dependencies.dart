import 'package:get/get.dart';

import '../../../../core/utils/di.dart';
import '../../data/datasources/bookings_local_data_source.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';

/// Shared bookings wiring reused by the flow and "My bookings" bindings.
void registerBookingDependencies() {
  registerLazy<BookingsLocalDataSource>(
    () => BookingsStorageDataSource(Get.find()),
  );
  registerLazy<BookingRepository>(
    () => BookingRepositoryImpl(Get.find<BookingsLocalDataSource>()),
  );
  registerLazy<GetBookingsUseCase>(
    () => GetBookingsUseCase(Get.find<BookingRepository>()),
  );
  registerLazy<CreateBookingUseCase>(
    () => CreateBookingUseCase(Get.find<BookingRepository>()),
  );
  registerLazy<CancelBookingUseCase>(
    () => CancelBookingUseCase(Get.find<BookingRepository>()),
  );
}
