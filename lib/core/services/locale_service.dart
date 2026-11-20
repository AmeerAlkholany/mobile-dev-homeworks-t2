import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_constants.dart';
import 'storage_service.dart';

/// Owns the active [Locale] (Arabic / English) and persists it. The widget
/// tree gets RTL/LTR layouts automatically because `GetMaterialApp.locale`
/// drives Flutter's [Directionality].
class LocaleService extends GetxService {
  LocaleService(this._storage);

  static const Locale arabic = Locale('ar', 'SA');
  static const Locale english = Locale('en', 'US');
  static const List<Locale> supportedLocales = <Locale>[arabic, english];

  final StorageService _storage;

  final Rx<Locale> _locale = arabic.obs;

  Rx<Locale> get localeRx => _locale;

  Locale get locale => _locale.value;

  bool get isArabic => _locale.value.languageCode == 'ar';

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  LocaleService init() {
    final String? saved = _storage.readString(AppConstants.kLocale);
    if (saved == 'en') {
      _locale.value = english;
    } else if (saved == 'ar') {
      _locale.value = arabic;
    }
    return this;
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale.value == locale) {
      return;
    }
    _locale.value = locale;
    await _storage.writeString(AppConstants.kLocale, locale.languageCode);
  }

  Future<void> toggleLocale() async {
    await setLocale(isArabic ? english : arabic);
  }
}
