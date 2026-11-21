/// Lease state derived from the contract end date.
enum TenantStatus {
  active('tenant_status_active'),
  endingSoon('tenant_status_ending_soon'),
  ended('tenant_status_ended');

  const TenantStatus(this.localizationKey);

  final String localizationKey;
}

/// A tenant together with the lease contract for the assigned unit.
class TenantEntity {
  const TenantEntity({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.nationalId,
    required this.unitId,
    required this.monthlyRent,
    required this.leaseStart,
    required this.leaseEnd,
    this.notes = '',
  });

  final String id;
  final String fullName;
  final String phone;
  final String nationalId;
  final String unitId;
  final double monthlyRent;
  final DateTime leaseStart;
  final DateTime leaseEnd;
  final String notes;

  String get initials {
    final List<String> parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'E';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  int remainingDays(DateTime today) {
    final DateTime end = DateTime(leaseEnd.year, leaseEnd.month, leaseEnd.day);
    final DateTime now = DateTime(today.year, today.month, today.day);
    final int days = end.difference(now).inDays;
    return days < 0 ? 0 : days;
  }

  TenantStatus statusOn(DateTime today, {int endingSoonDays = 60}) {
    final DateTime end = DateTime(leaseEnd.year, leaseEnd.month, leaseEnd.day);
    final DateTime now = DateTime(today.year, today.month, today.day);
    if (end.isBefore(now)) {
      return TenantStatus.ended;
    }
    if (end.difference(now).inDays <= endingSoonDays) {
      return TenantStatus.endingSoon;
    }
    return TenantStatus.active;
  }

  TenantEntity copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? nationalId,
    String? unitId,
    double? monthlyRent,
    DateTime? leaseStart,
    DateTime? leaseEnd,
    String? notes,
  }) {
    return TenantEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      unitId: unitId ?? this.unitId,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      leaseStart: leaseStart ?? this.leaseStart,
      leaseEnd: leaseEnd ?? this.leaseEnd,
      notes: notes ?? this.notes,
    );
  }
}
