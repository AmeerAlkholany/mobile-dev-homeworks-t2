import 'package:flutter_application_1/features/bookings/domain/entities/booking_entity.dart';
import 'package:flutter_application_1/features/bookings/domain/repositories/booking_repository.dart';
import 'package:flutter_application_1/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:flutter_application_1/features/bookings/domain/usecases/get_bookings_usecase.dart';
import 'package:flutter_application_1/features/bookings/presentation/controllers/my_bookings_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _InMemoryBookingRepository implements BookingRepository {
  _InMemoryBookingRepository(this.bookings);

  final List<BookingEntity> bookings;

  @override
  Future<List<BookingEntity>> getBookings() async =>
      List<BookingEntity>.from(bookings);

  @override
  Future<BookingEntity> createBooking(BookingEntity booking) async {
    bookings.add(booking);
    return booking;
  }

  @override
  Future<BookingEntity> cancelBooking(String bookingId) async {
    final int index =
        bookings.indexWhere((BookingEntity item) => item.id == bookingId);
    bookings[index] = bookings[index].copyWith(
      status: BookingStatus.cancelled,
    );
    return bookings[index];
  }
}

BookingEntity _booking(String id) {
  return BookingEntity(
    id: id,
    propertyId: 'p1',
    titleEn: 'Test apartment',
    titleAr: 'شقة تجريبية',
    cityKey: 'riyadh',
    monthlyPrice: 6500,
    leaseMonths: 12,
    moveInDate: DateTime(2027, 1, 15),
    createdAt: DateTime(2026, 11, 1),
    totalPrice: 78000,
    status: BookingStatus.pending,
    notes: '',
    tenantName: 'Tenant',
  );
}

void main() {
  test('moves from loading to success, then to empty', () async {
    final _InMemoryBookingRepository repository =
        _InMemoryBookingRepository(<BookingEntity>[_booking('b1')]);
    final MyBookingsController controller = MyBookingsController(
      GetBookingsUseCase(repository),
      CancelBookingUseCase(repository),
    );

    expect(controller.status.isLoading, isTrue);

    final Future<void> loading = controller.loadBookings();
    expect(controller.status.isLoading, isTrue);
    await loading;

    expect(controller.status.isSuccess, isTrue);
    expect(controller.state, hasLength(1));
    expect(controller.state!.first.id, 'b1');

    repository.bookings.clear();
    await controller.loadBookings();
    expect(controller.status.isEmpty, isTrue);

    controller.dispose();
  });
}
