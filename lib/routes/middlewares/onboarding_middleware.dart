import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../app_routes.dart';

/// Keeps first-launch users inside the onboarding walkthrough and sends
/// returning users straight to sign-in (or the app shell when already signed
/// in).
class OnboardingMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final bool completed = Get.find<StorageService>().readBool(
      AppConstants.kOnboardingCompleted,
    );
    if (!completed) {
      return null;
    }
    final bool loggedIn = Get.find<AuthService>().isLoggedIn;
    return RouteSettings(name: loggedIn ? AppRoutes.main : AppRoutes.login);
  }
}
