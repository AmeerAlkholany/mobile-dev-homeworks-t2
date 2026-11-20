import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.propertyId,
    required super.titleEn,
    required super.titleAr,
    required super.cityKey,
    required super.monthlyPrice,
    required super.leaseMonths,
    required super.moveInDate,
    required super.createdAt,
    required super.totalPrice,
    required super.status,
    required super.notes,
    required super.tenantName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      propertyId: json['property_id'] as String,
      titleEn: json['title_en'] as String,
      titleAr: json['title_ar'] as String,
      cityKey: json['city'] as String,
      monthlyPrice: (json['monthly_price'] as num).toDouble(),
      leaseMonths: (json['lease_months'] as num).toInt(),
      moveInDate: DateTime.parse(json['move_in_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (BookingStatus status) => status.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      notes: (json['notes'] as String?) ?? '',
      tenantName: (json['tenant_name'] as String?) ?? '',
    );
  }

  factory BookingModel.fromEntity(BookingEntity booking) {
    return BookingModel(
      id: booking.id,
      propertyId: booking.propertyId,
      titleEn: booking.titleEn,
      titleAr: booking.titleAr,
      cityKey: booking.cityKey,
      monthlyPrice: booking.monthlyPrice,
      leaseMonths: booking.leaseMonths,
      moveInDate: booking.moveInDate,
      createdAt: booking.createdAt,
      totalPrice: booking.totalPrice,
      status: booking.status,
      notes: booking.notes,
      tenantName: booking.tenantName,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'property_id': propertyId,
      'title_en': titleEn,
      'title_ar': titleAr,
      'city': cityKey,
      'monthly_price': monthlyPrice,
      'lease_months': leaseMonths,
      'move_in_date': moveInDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'total_price': totalPrice,
      'status': status.name,
      'notes': notes,
      'tenant_name': tenantName,
    };
  }
}
