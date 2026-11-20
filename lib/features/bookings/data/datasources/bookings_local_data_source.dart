import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/booking_entity.dart';
import '../models/booking_model.dart';

abstract class BookingsLocalDataSource {
  Future<List<BookingModel>> fetchBookings();

  Future<void> saveBookings(List<BookingModel> bookings);
}

/// Persists rental requests in GetStorage. On a fresh install it seeds two
/// demo bookings so "My bookings" is never an empty shell on first launch.
class BookingsStorageDataSource implements BookingsLocalDataSource {
  const BookingsStorageDataSource(this._storage);

  final StorageService _storage;

  @override
  Future<List<BookingModel>> fetchBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    final List<Map<String, dynamic>> raw = _storage.readListOfMaps(
      AppConstants.kBookings,
    );
    if (raw.isEmpty &&
        !_storage.readBool(AppConstants.kBookingsSeeded)) {
      final List<BookingModel> seeded = _seedBookings();
      await saveBookings(seeded);
      await _storage.writeBool(AppConstants.kBookingsSeeded, true);
      return seeded;
    }
    return raw.map(BookingModel.fromJson).toList();
  }

  @override
  Future<void> saveBookings(List<BookingModel> bookings) {
    return _storage.writeListOfMaps(
      AppConstants.kBookings,
      bookings.map((BookingModel booking) => booking.toJson()).toList(),
    );
  }

  List<BookingModel> _seedBookings() {
    return <BookingModel>[
      BookingModel(
        id: 'bk-seed-1',
        propertyId: 'pr-1001',
        titleEn: 'Luxury 2-bedroom apartment in Al Olaya',
        titleAr: 'شقة فاخرة بغرفتين في العليا',
        cityKey: 'riyadh',
        monthlyPrice: 6500,
        leaseMonths: 12,
        moveInDate: DateTime(2026, 12, 20),
        createdAt: DateTime(2026, 11, 2),
        totalPrice: 78000,
        status: BookingStatus.active,
        notes: 'Furnished kitchen requested before move-in.',
        tenantName: 'Ejary Tenant',
      ),
      BookingModel(
        id: 'bk-seed-2',
        propertyId: 'pr-1004',
        titleEn: 'Sea-view studio in Al Shati',
        titleAr: 'استوديو بإطلالة بحرية في الشاطئ',
        cityKey: 'jeddah',
        monthlyPrice: 4200,
        leaseMonths: 3,
        moveInDate: DateTime(2027, 1, 10),
        createdAt: DateTime(2026, 11, 18),
        totalPrice: 12600,
        status: BookingStatus.pending,
        notes: '',
        tenantName: 'Ejary Tenant',
      ),
    ];
  }
}
