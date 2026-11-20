import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/auth_service.dart';
import '../app_routes.dart';

/// Guards protected routes, and (optionally) keeps authenticated users out of
/// the auth screens.
class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({this.redirectWhenAuthenticated = false});

  final bool redirectWhenAuthenticated;

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AuthService auth = Get.find<AuthService>();
    if (redirectWhenAuthenticated && auth.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.main);
    }
    if (!redirectWhenAuthenticated && !auth.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
