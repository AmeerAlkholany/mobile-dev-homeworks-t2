/// App-wide constant values, storage keys and mock-data identifiers.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Ejary';
  static const String appVersion = '1.0.0';
  static const String currencyCode = 'SAR';

  // GetStorage keys.
  static const String kThemeMode = 'app_theme_mode';
  static const String kLocale = 'app_locale';
  static const String kOnboardingCompleted = 'onboarding_completed';
  static const String kAuthToken = 'auth_token';
  static const String kAuthProfile = 'auth_profile';
  static const String kFavoriteIds = 'favorite_property_ids';
  static const String kBookings = 'rental_bookings';
  static const String kBookingsSeeded = 'rental_bookings_seeded';

  // Supported city keys used by mock data and filters.
  static const List<String> cityKeys = <String>[
    'riyadh',
    'jeddah',
    'dammam',
    'makkah',
    'madinah',
    'khobar',
  ];

  static const Duration mockNetworkDelay = Duration(milliseconds: 650);
}
