import '../../../../core/constants/demo_ids.dart';
import '../models/tenant_model.dart';

/// Demo tenants with leases relative to today, so statuses always look fresh
/// (active, ending soon, shop tenant).
class TenantMockData {
  const TenantMockData._();

  static List<TenantModel> build() {
    final DateTime now = DateTime.now();

    return <TenantModel>[
      TenantModel(
        id: DemoIds.tenantSaad,
        fullName: 'سعد الحربي',
        phone: '+966551234567',
        nationalId: '1023456789',
        unitId: DemoIds.unit101,
        monthlyRent: 3500,
        leaseStart: DateTime(now.year, now.month - 10, 1),
        leaseEnd: DateTime(now.year, now.month + 2, 1),
        notes: 'Pays by bank transfer',
      ),
      TenantModel(
        id: DemoIds.tenantNoura,
        fullName: 'نورة القحطاني',
        phone: '+966505551234',
        nationalId: '1087654321',
        unitId: DemoIds.unit102,
        monthlyRent: 3200,
        leaseStart: DateTime(now.year, now.month - 12, 1),
        leaseEnd: DateTime(now.year, now.month, now.day + 18),
      ),
      TenantModel(
        id: DemoIds.tenantFahad,
        fullName: 'فهد الشمري',
        phone: '+966533334444',
        nationalId: '1055566677',
        unitId: DemoIds.unit201,
        monthlyRent: 4000,
        leaseStart: DateTime(now.year, now.month - 6, 1),
        leaseEnd: DateTime(now.year, now.month + 14, 1),
      ),
      TenantModel(
        id: DemoIds.tenantCompany,
        fullName: 'مؤسسة رواد التسويق',
        phone: '+966544445555',
        nationalId: '3012345678',
        unitId: DemoIds.unitShop,
        monthlyRent: 6000,
        leaseStart: DateTime(now.year, now.month - 8, 1),
        leaseEnd: DateTime(now.year, now.month + 4, 1),
        notes: 'Commercial lease, annual escalation',
      ),
    ];
  }
}
