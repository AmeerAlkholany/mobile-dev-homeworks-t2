import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CancelBookingUseCase {
  const CancelBookingUseCase(this._repository);

  final BookingRepository _repository;

  Future<BookingEntity> call(String bookingId) =>
      _repository.cancelBooking(bookingId);
}
