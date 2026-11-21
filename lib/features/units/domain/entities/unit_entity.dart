/// Unit type. The enum carries only localization keys so the domain layer
/// stays free of Flutter and GetX imports.
enum UnitType {
  apartment('type_apartment'),
  shop('type_shop'),
  office('type_office'),
  studio('type_studio');

  const UnitType(this.localizationKey);

  final String localizationKey;

  static UnitType fromName(String? name) {
    return UnitType.values.firstWhere(
      (UnitType type) => type.name == name,
      orElse: () => UnitType.apartment,
    );
  }
}

/// Occupancy state of a unit.
enum UnitStatus {
  occupied('status_occupied'),
  vacant('status_vacant'),
  maintenance('status_maintenance');

  const UnitStatus(this.localizationKey);

  final String localizationKey;

  static UnitStatus fromName(String? name) {
    return UnitStatus.values.firstWhere(
      (UnitStatus status) => status.name == name,
      orElse: () => UnitStatus.vacant,
    );
  }
}

/// A rentable unit (apartment, shop, office or studio) inside the building.
class UnitEntity {
  const UnitEntity({
    required this.id,
    required this.unitNumber,
    required this.floor,
    required this.type,
    required this.monthlyRent,
    required this.status,
    this.bedrooms = 0,
    this.areaSqm = 0,
    this.notes = '',
  });

  final String id;
  final String unitNumber;
  final int floor;
  final UnitType type;
  final double monthlyRent;
  final UnitStatus status;
  final int bedrooms;
  final double areaSqm;
  final String notes;

  bool get isVacant => status == UnitStatus.vacant;

  bool get isOccupied => status == UnitStatus.occupied;

  UnitEntity copyWith({
    String? id,
    String? unitNumber,
    int? floor,
    UnitType? type,
    double? monthlyRent,
    UnitStatus? status,
    int? bedrooms,
    double? areaSqm,
    String? notes,
  }) {
    return UnitEntity(
      id: id ?? this.id,
      unitNumber: unitNumber ?? this.unitNumber,
      floor: floor ?? this.floor,
      type: type ?? this.type,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      status: status ?? this.status,
      bedrooms: bedrooms ?? this.bedrooms,
      areaSqm: areaSqm ?? this.areaSqm,
      notes: notes ?? this.notes,
    );
  }
}
