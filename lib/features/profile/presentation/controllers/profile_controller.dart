import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/locale_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';

class ProfileController extends GetxController {
  ProfileController(
    this._getCurrentUser,
    this._logout,
    this.theme,
    this.locale,
  );

  final GetCurrentUserUseCase _getCurrentUser;
  final LogoutUseCase _logout;

  final ThemeService theme;
  final LocaleService locale;

  final Rxn<UserEntity> user = Rxn<UserEntity>();
  final RxBool isLoading = true.obs;
  final RxBool isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    isLoading.value = true;
    try {
      user.value = await _getCurrentUser();
    } catch (_) {
      user.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTheme() => theme.toggleTheme();

  Future<void> toggleLocale() => locale.toggleLocale();

  Future<void> setLocale(Locale locale) => this.locale.setLocale(locale);

  Future<void> logout() async {
    if (isLoggingOut.value) {
      return;
    }
    isLoggingOut.value = true;
    try {
      await _logout();
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoggingOut.value = false;
    }
  }
}
