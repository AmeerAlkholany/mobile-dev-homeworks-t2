import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingsUseCase {
  const GetBookingsUseCase(this._repository);

  final BookingRepository _repository;

  Future<List<BookingEntity>> call() => _repository.getBookings();
}
