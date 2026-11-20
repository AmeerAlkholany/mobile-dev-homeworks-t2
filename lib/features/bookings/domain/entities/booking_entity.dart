enum BookingStatus { pending, active, cancelled }

extension BookingStatusX on BookingStatus {
  String get labelKey => switch (this) {
        BookingStatus.pending => 'status_pending',
        BookingStatus.active => 'status_active',
        BookingStatus.cancelled => 'status_cancelled',
      };

  bool get isCancelled => this == BookingStatus.cancelled;
}

/// A rental request created from a property. Pure Dart.
class BookingEntity {
  const BookingEntity({
    required this.id,
    required this.propertyId,
    required this.titleEn,
    required this.titleAr,
    required this.cityKey,
    required this.monthlyPrice,
    required this.leaseMonths,
    required this.moveInDate,
    required this.createdAt,
    required this.totalPrice,
    required this.status,
    required this.notes,
    required this.tenantName,
  });

  final String id;
  final String propertyId;
  final String titleEn;
  final String titleAr;
  final String cityKey;
  final double monthlyPrice;
  final int leaseMonths;
  final DateTime moveInDate;
  final DateTime createdAt;
  final double totalPrice;
  final BookingStatus status;
  final String notes;
  final String tenantName;

  String title(bool arabic) => arabic ? titleAr : titleEn;

  String get cityLabelKey => 'city_$cityKey';

  bool get isCancellable => !status.isCancelled;

  BookingEntity copyWith({BookingStatus? status}) {
    return BookingEntity(
      id: id,
      propertyId: propertyId,
      titleEn: titleEn,
      titleAr: titleAr,
      cityKey: cityKey,
      monthlyPrice: monthlyPrice,
      leaseMonths: leaseMonths,
      moveInDate: moveInDate,
      createdAt: createdAt,
      totalPrice: totalPrice,
      status: status ?? this.status,
      notes: notes,
      tenantName: tenantName,
    );
  }
}
