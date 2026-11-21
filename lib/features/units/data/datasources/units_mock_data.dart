import '../../../../core/constants/demo_ids.dart';
import '../../domain/entities/unit_entity.dart';
import '../models/unit_model.dart';

/// Realistic demo building used on first launch.
class UnitMockData {
  const UnitMockData._();

  static List<UnitModel> build() {
    return <UnitModel>[
      const UnitModel(
        id: DemoIds.unit101,
        unitNumber: '101',
        floor: 1,
        type: UnitType.apartment,
        monthlyRent: 3500,
        status: UnitStatus.occupied,
        bedrooms: 2,
        areaSqm: 110,
        notes: 'Corner unit with a balcony',
      ),
      const UnitModel(
        id: DemoIds.unit102,
        unitNumber: '102',
        floor: 1,
        type: UnitType.apartment,
        monthlyRent: 3200,
        status: UnitStatus.occupied,
        bedrooms: 2,
        areaSqm: 95,
      ),
      const UnitModel(
        id: DemoIds.unit201,
        unitNumber: '201',
        floor: 2,
        type: UnitType.apartment,
        monthlyRent: 4000,
        status: UnitStatus.occupied,
        bedrooms: 3,
        areaSqm: 130,
      ),
      const UnitModel(
        id: DemoIds.unit202,
        unitNumber: '202',
        floor: 2,
        type: UnitType.apartment,
        monthlyRent: 3800,
        status: UnitStatus.vacant,
        bedrooms: 2,
        areaSqm: 105,
        notes: 'Freshly painted, ready to move in',
      ),
      const UnitModel(
        id: DemoIds.unitShop,
        unitNumber: 'G1',
        floor: 0,
        type: UnitType.shop,
        monthlyRent: 6000,
        status: UnitStatus.occupied,
        areaSqm: 60,
        notes: 'Street-facing commercial shop',
      ),
      const UnitModel(
        id: DemoIds.unit301,
        unitNumber: '301',
        floor: 3,
        type: UnitType.apartment,
        monthlyRent: 4200,
        status: UnitStatus.maintenance,
        bedrooms: 2,
        areaSqm: 100,
        notes: 'Bathroom renovation in progress',
      ),
    ];
  }
}
