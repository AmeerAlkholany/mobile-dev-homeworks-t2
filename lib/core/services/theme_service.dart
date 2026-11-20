import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_constants.dart';
import 'storage_service.dart';

/// Owns the app [ThemeMode] and persists the user's choice in GetStorage.
class ThemeService extends GetxService {
  ThemeService(this._storage);

  final StorageService _storage;

  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;

  Rx<ThemeMode> get themeModeRx => _themeMode;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDark => _themeMode.value == ThemeMode.dark;

  ThemeService init() {
    final String? saved = _storage.readString(AppConstants.kThemeMode);
    if (saved == 'dark') {
      _themeMode.value = ThemeMode.dark;
    } else if (saved == 'light') {
      _themeMode.value = ThemeMode.light;
    }
    return this;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode.value == mode) {
      return;
    }
    _themeMode.value = mode;
    await _storage.writeString(
      AppConstants.kThemeMode,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> toggleTheme() async {
    await setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
