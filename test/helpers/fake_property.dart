import 'package:flutter_application_1/features/properties/domain/entities/property_entity.dart';

/// Shared fixture for repository / use case / controller tests.
PropertyEntity fakeProperty({
  String id = 'p1',
  String cityKey = 'riyadh',
  PropertyCategory category = PropertyCategory.apartment,
  RentPeriod rentPeriod = RentPeriod.yearly,
  double price = 78000,
  String titleEn = 'Test apartment',
  String titleAr = 'شقة تجريبية',
}) {
  return PropertyEntity(
    id: id,
    titleEn: titleEn,
    titleAr: titleAr,
    descriptionEn: 'A test listing.',
    descriptionAr: 'عقار تجريبي.',
    districtEn: 'Al Olaya',
    districtAr: 'العليا',
    cityKey: cityKey,
    category: category,
    rentPeriod: rentPeriod,
    price: price,
    bedrooms: 2,
    bathrooms: 2,
    area: 120,
    amenities: const <String>['wifi', 'parking'],
    landlordNameEn: 'Test Landlord',
    landlordNameAr: 'مالك تجريبي',
    landlordPhone: '+966500000000',
    landlordVerified: true,
    rating: 4.5,
    reviewsCount: 10,
    availableFrom: DateTime(2027, 1, 1),
    featured: false,
  );
}
