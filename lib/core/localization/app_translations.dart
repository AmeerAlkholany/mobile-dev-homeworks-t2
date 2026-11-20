import 'package:get/get.dart';

import 'locales/ar_sa.dart';
import 'locales/en_us.dart';

/// Central `Translations` map consumed by `GetMaterialApp`. Keys are shared by
/// both dictionaries (verified in `test/localization_test.dart`).
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        'ar_SA': arSa,
        'en_US': enUs,
      };
}
