import '../../domain/entities/unit_entity.dart';

/// Serialization boundary for a [UnitEntity] persisted in GetStorage.
class UnitModel extends UnitEntity {
  const UnitModel({
    required super.id,
    required super.unitNumber,
    required super.floor,
    required super.type,
    required super.monthlyRent,
    required super.status,
    super.bedrooms,
    super.areaSqm,
    super.notes,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: (json['id'] as String?) ?? '',
      unitNumber: (json['unit_number'] as String?) ?? '',
      floor: (json['floor'] as num?)?.toInt() ?? 0,
      type: UnitType.fromName(json['type'] as String?),
      monthlyRent: (json['monthly_rent'] as num?)?.toDouble() ?? 0,
      status: UnitStatus.fromName(json['status'] as String?),
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
      areaSqm: (json['area_sqm'] as num?)?.toDouble() ?? 0,
      notes: (json['notes'] as String?) ?? '',
    );
  }

  factory UnitModel.fromEntity(UnitEntity entity) {
    return UnitModel(
      id: entity.id,
      unitNumber: entity.unitNumber,
      floor: entity.floor,
      type: entity.type,
      monthlyRent: entity.monthlyRent,
      status: entity.status,
      bedrooms: entity.bedrooms,
      areaSqm: entity.areaSqm,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'unit_number': unitNumber,
      'floor': floor,
      'type': type.name,
      'monthly_rent': monthlyRent,
      'status': status.name,
      'bedrooms': bedrooms,
      'area_sqm': areaSqm,
      'notes': notes,
    };
  }
}
