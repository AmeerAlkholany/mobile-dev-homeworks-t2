/// App-wide constant values, GetStorage keys and demo-data settings.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Ejary Landlord';
  static const String appVersion = '1.0.0';
  static const String defaultCurrency = 'SAR';

  /// Currencies the landlord can pick for the building profile.
  static const List<String> currencies = <String>['SAR', 'USD', 'AED'];

  // GetStorage keys.
  static const String kThemeMode = 'app_theme_mode';
  static const String kLocale = 'app_locale';
  static const String kOnboardingCompleted = 'onboarding_completed';
  static const String kAuthToken = 'auth_token';
  static const String kAuthProfile = 'auth_profile';

  // Landlord / building profile.
  static const String kOwnerName = 'landlord_owner_name';
  static const String kBuildingName = 'landlord_building_name';
  static const String kCurrency = 'landlord_currency';

  // Estate data.
  static const String kUnits = 'estate_units';
  static const String kUnitsSeeded = 'estate_units_seeded';
  static const String kTenants = 'estate_tenants';
  static const String kTenantsSeeded = 'estate_tenants_seeded';
  static const String kRecordedPayments = 'rent_recorded_payments';
  static const String kPaymentsSeeded = 'rent_payments_seeded';

  /// Simulated latency so loading states are visible and believable.
  static const Duration mockNetworkDelay = Duration(milliseconds: 420);

  /// A lease whose end date falls within this window is "ending soon".
  static const int leaseEndingSoonDays = 60;

  /// Maximum number of monthly obligations generated per lease.
  static const int ledgerLookbackMonths = 12;
}
