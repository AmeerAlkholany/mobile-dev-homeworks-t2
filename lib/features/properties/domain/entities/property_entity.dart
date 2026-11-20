/// Property categories exposed by the discovery filters.
enum PropertyCategory { apartment, villa, office, studio }

extension PropertyCategoryX on PropertyCategory {
  String get labelKey => switch (this) {
        PropertyCategory.apartment => 'category_apartment',
        PropertyCategory.villa => 'category_villa',
        PropertyCategory.office => 'category_office',
        PropertyCategory.studio => 'category_studio',
      };
}

/// Whether [PropertyEntity.price] is a monthly or yearly figure.
enum RentPeriod { monthly, yearly }

extension RentPeriodX on RentPeriod {
  bool get isYearly => this == RentPeriod.yearly;

  String get labelKey => isYearly ? 'per_year' : 'per_month';
}

/// Immutable, pure-Dart property domain entity. All user-facing text is stored
/// in both languages so the UI can switch instantly.
class PropertyEntity {
  const PropertyEntity({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.districtEn,
    required this.districtAr,
    required this.cityKey,
    required this.category,
    required this.rentPeriod,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.amenities,
    required this.landlordNameEn,
    required this.landlordNameAr,
    required this.landlordPhone,
    required this.landlordVerified,
    required this.rating,
    required this.reviewsCount,
    required this.availableFrom,
    this.featured = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String districtEn;
  final String districtAr;

  /// Localization key suffix, e.g. `riyadh` -> `city_riyadh`.
  final String cityKey;
  final PropertyCategory category;
  final RentPeriod rentPeriod;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final List<String> amenities;
  final String landlordNameEn;
  final String landlordNameAr;
  final String landlordPhone;
  final bool landlordVerified;
  final double rating;
  final int reviewsCount;
  final DateTime availableFrom;
  final bool featured;

  String title(bool arabic) => arabic ? titleAr : titleEn;

  String description(bool arabic) => arabic ? descriptionAr : descriptionEn;

  String district(bool arabic) => arabic ? districtAr : districtEn;

  String landlordName(bool arabic) => arabic ? landlordNameAr : landlordNameEn;

  String get cityLabelKey => 'city_$cityKey';

  /// Yearly listings are normalized to a monthly figure so filtering, booking
  /// math and the "monthly equivalent" label all agree.
  double get monthlyPrice => rentPeriod.isYearly ? price / 12 : price;

  double totalForMonths(int months) => monthlyPrice * months;

  List<String> get galleryKeys => <String>[
        '$id-cover',
        '$id-living',
        '$id-floorplan',
      ];
}
