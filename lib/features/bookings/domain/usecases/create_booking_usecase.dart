import '../../../properties/domain/entities/property_entity.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

/// Builds a pending rental request with the agreed lease terms and total
/// price, then persists it through the repository.
class CreateBookingUseCase {
  const CreateBookingUseCase(this._repository);

  final BookingRepository _repository;

  Future<BookingEntity> call({
    required PropertyEntity property,
    required DateTime moveInDate,
    required int leaseMonths,
    required String notes,
    required String tenantName,
  }) {
    final BookingEntity booking = BookingEntity(
      id: 'bk-${DateTime.now().microsecondsSinceEpoch}',
      propertyId: property.id,
      titleEn: property.titleEn,
      titleAr: property.titleAr,
      cityKey: property.cityKey,
      monthlyPrice: property.monthlyPrice,
      leaseMonths: leaseMonths,
      moveInDate: moveInDate,
      createdAt: DateTime.now(),
      totalPrice: property.totalForMonths(leaseMonths),
      status: BookingStatus.pending,
      notes: notes.trim(),
      tenantName: tenantName,
    );
    return _repository.createBooking(booking);
  }
}
