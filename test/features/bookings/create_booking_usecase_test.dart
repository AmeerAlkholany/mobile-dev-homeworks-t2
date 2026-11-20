import 'package:flutter_application_1/features/bookings/domain/entities/booking_entity.dart';
import 'package:flutter_application_1/features/bookings/domain/repositories/booking_repository.dart';
import 'package:flutter_application_1/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:flutter_application_1/features/properties/domain/entities/property_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_property.dart';

class _RecordingBookingRepository implements BookingRepository {
  final List<BookingEntity> created = <BookingEntity>[];

  @override
  Future<BookingEntity> createBooking(BookingEntity booking) async {
    created.add(booking);
    return booking;
  }

  @override
  Future<List<BookingEntity>> getBookings() async =>
      List<BookingEntity>.from(created);

  @override
  Future<BookingEntity> cancelBooking(String bookingId) async {
    final BookingEntity booking =
        created.firstWhere((BookingEntity item) => item.id == bookingId);
    return booking.copyWith(status: BookingStatus.cancelled);
  }
}

void main() {
  late _RecordingBookingRepository repository;
  late CreateBookingUseCase useCase;

  setUp(() {
    repository = _RecordingBookingRepository();
    useCase = CreateBookingUseCase(repository);
  });

  test('derives monthly price and total from a yearly listing', () async {
    final BookingEntity booking = await useCase(
      property: fakeProperty(price: 78000, rentPeriod: RentPeriod.yearly),
      moveInDate: DateTime(2027, 1, 15),
      leaseMonths: 6,
      notes: '  Need parking  ',
      tenantName: 'Ameer',
    );

    expect(booking.monthlyPrice, 6500);
    expect(booking.totalPrice, 39000);
    expect(booking.status, BookingStatus.pending);
    expect(booking.notes, 'Need parking');
    expect(booking.leaseMonths, 6);
    expect(booking.tenantName, 'Ameer');
    expect(repository.created, hasLength(1));
    expect(repository.created.single.id, booking.id);
  });

  test('uses the monthly price directly for monthly listings', () async {
    final BookingEntity booking = await useCase(
      property: fakeProperty(price: 4200, rentPeriod: RentPeriod.monthly),
      moveInDate: DateTime(2027, 2, 1),
      leaseMonths: 3,
      notes: '',
      tenantName: 'Tenant',
    );

    expect(booking.monthlyPrice, 4200);
    expect(booking.totalPrice, 12600);
  });
}
