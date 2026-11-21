import '../../domain/entities/tenant_entity.dart';

/// Serialization boundary for a [TenantEntity] persisted in GetStorage.
class TenantModel extends TenantEntity {
  const TenantModel({
    required super.id,
    required super.fullName,
    required super.phone,
    required super.nationalId,
    required super.unitId,
    required super.monthlyRent,
    required super.leaseStart,
    required super.leaseEnd,
    super.notes,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: (json['id'] as String?) ?? '',
      fullName: (json['full_name'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      nationalId: (json['national_id'] as String?) ?? '',
      unitId: (json['unit_id'] as String?) ?? '',
      monthlyRent: (json['monthly_rent'] as num?)?.toDouble() ?? 0,
      leaseStart: DateTime.tryParse((json['lease_start'] as String?) ?? '') ??
          DateTime.now(),
      leaseEnd: DateTime.tryParse((json['lease_end'] as String?) ?? '') ??
          DateTime.now(),
      notes: (json['notes'] as String?) ?? '',
    );
  }

  factory TenantModel.fromEntity(TenantEntity entity) {
    return TenantModel(
      id: entity.id,
      fullName: entity.fullName,
      phone: entity.phone,
      nationalId: entity.nationalId,
      unitId: entity.unitId,
      monthlyRent: entity.monthlyRent,
      leaseStart: entity.leaseStart,
      leaseEnd: entity.leaseEnd,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'national_id': nationalId,
      'unit_id': unitId,
      'monthly_rent': monthlyRent,
      'lease_start': leaseStart.toIso8601String(),
      'lease_end': leaseEnd.toIso8601String(),
      'notes': notes,
    };
  }
}
