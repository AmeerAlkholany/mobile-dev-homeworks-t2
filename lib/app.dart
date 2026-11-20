import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/localization/app_translations.dart';
import 'core/services/locale_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

/// Root widget. `Obx` re-renders `GetMaterialApp` whenever the theme mode or
/// locale changes, so both switches are instant and persistent.
class EjaryApp extends StatelessWidget {
  const EjaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();
    final LocaleService localeService = Get.find<LocaleService>();

    return Obx(
      () => GetMaterialApp(
        title: 'app_name'.tr,
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: localeService.localeRx.value,
        fallbackLocale: LocaleService.english,
        supportedLocales: LocaleService.supportedLocales,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeService.themeModeRx.value,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        defaultTransition: Transition.cupertino,
      ),
    );
  }
}
