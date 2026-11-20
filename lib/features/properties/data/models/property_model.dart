import '../../domain/entities/property_entity.dart';

/// Serialization boundary for [PropertyEntity].
class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.titleEn,
    required super.titleAr,
    required super.descriptionEn,
    required super.descriptionAr,
    required super.districtEn,
    required super.districtAr,
    required super.cityKey,
    required super.category,
    required super.rentPeriod,
    required super.price,
    required super.bedrooms,
    required super.bathrooms,
    required super.area,
    required super.amenities,
    required super.landlordNameEn,
    required super.landlordNameAr,
    required super.landlordPhone,
    required super.landlordVerified,
    required super.rating,
    required super.reviewsCount,
    required super.availableFrom,
    super.featured,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      titleEn: json['title_en'] as String,
      titleAr: json['title_ar'] as String,
      descriptionEn: json['description_en'] as String,
      descriptionAr: json['description_ar'] as String,
      districtEn: json['district_en'] as String,
      districtAr: json['district_ar'] as String,
      cityKey: json['city'] as String,
      category: _categoryFrom(json['category'] as String?),
      rentPeriod: (json['rent_period'] as String?) == 'yearly'
          ? RentPeriod.yearly
          : RentPeriod.monthly,
      price: (json['price'] as num).toDouble(),
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
      area: (json['area'] as num).toDouble(),
      amenities: (json['amenities'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(),
      landlordNameEn: json['landlord_name_en'] as String,
      landlordNameAr: json['landlord_name_ar'] as String,
      landlordPhone: json['landlord_phone'] as String,
      landlordVerified: json['landlord_verified'] as bool? ?? false,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: (json['reviews'] as num).toInt(),
      availableFrom: DateTime.parse(json['available_from'] as String),
      featured: json['featured'] as bool? ?? false,
    );
  }

  factory PropertyModel.fromEntity(PropertyEntity entity) {
    return PropertyModel(
      id: entity.id,
      titleEn: entity.titleEn,
      titleAr: entity.titleAr,
      descriptionEn: entity.descriptionEn,
      descriptionAr: entity.descriptionAr,
      districtEn: entity.districtEn,
      districtAr: entity.districtAr,
      cityKey: entity.cityKey,
      category: entity.category,
      rentPeriod: entity.rentPeriod,
      price: entity.price,
      bedrooms: entity.bedrooms,
      bathrooms: entity.bathrooms,
      area: entity.area,
      amenities: entity.amenities,
      landlordNameEn: entity.landlordNameEn,
      landlordNameAr: entity.landlordNameAr,
      landlordPhone: entity.landlordPhone,
      landlordVerified: entity.landlordVerified,
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,
      availableFrom: entity.availableFrom,
      featured: entity.featured,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title_en': titleEn,
      'title_ar': titleAr,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'district_en': districtEn,
      'district_ar': districtAr,
      'city': cityKey,
      'category': category.name,
      'rent_period': rentPeriod.name,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'amenities': amenities,
      'landlord_name_en': landlordNameEn,
      'landlord_name_ar': landlordNameAr,
      'landlord_phone': landlordPhone,
      'landlord_verified': landlordVerified,
      'rating': rating,
      'reviews': reviewsCount,
      'available_from': availableFrom.toIso8601String(),
      'featured': featured,
    };
  }

  static PropertyCategory _categoryFrom(String? value) {
    return PropertyCategory.values.firstWhere(
      (PropertyCategory category) => category.name == value,
      orElse: () => PropertyCategory.apartment,
    );
  }
}
