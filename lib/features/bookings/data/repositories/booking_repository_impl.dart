import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/bookings_local_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._localDataSource);

  final BookingsLocalDataSource _localDataSource;

  @override
  Future<List<BookingEntity>> getBookings() async {
    final List<BookingModel> bookings =
        await _localDataSource.fetchBookings();
    final List<BookingModel> sorted = List<BookingModel>.from(bookings)
      ..sort(
        (BookingModel a, BookingModel b) =>
            b.createdAt.compareTo(a.createdAt),
      );
    return sorted;
  }

  @override
  Future<BookingEntity> createBooking(BookingEntity booking) async {
    final List<BookingModel> bookings = await _localDataSource.fetchBookings();
    final List<BookingModel> updated = <BookingModel>[
      BookingModel.fromEntity(booking),
      ...bookings,
    ];
    await _localDataSource.saveBookings(updated);
    return booking;
  }

  @override
  Future<BookingEntity> cancelBooking(String bookingId) async {
    final List<BookingModel> bookings = await _localDataSource.fetchBookings();
    final int index = bookings.indexWhere(
      (BookingModel booking) => booking.id == bookingId,
    );
    if (index == -1) {
      throw const NotFoundException('error_generic');
    }
    final BookingEntity cancelled = bookings[index].copyWith(
      status: BookingStatus.cancelled,
    );
    final List<BookingModel> updated = List<BookingModel>.from(bookings);
    updated[index] = BookingModel.fromEntity(cancelled);
    await _localDataSource.saveBookings(updated);
    return cancelled;
  }
}
