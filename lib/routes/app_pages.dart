import 'package:get/get.dart';

import '../features/auth/presentation/bindings/login_binding.dart';
import '../features/auth/presentation/bindings/register_binding.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/main_nav/presentation/bindings/main_nav_binding.dart';
import '../features/main_nav/presentation/pages/main_nav_page.dart';
import '../features/onboarding/presentation/bindings/onboarding_binding.dart';
import '../features/onboarding/presentation/bindings/splash_binding.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/onboarding/presentation/pages/splash_page.dart';
import '../features/tenants/presentation/bindings/tenant_details_binding.dart';
import '../features/tenants/presentation/bindings/tenant_form_binding.dart';
import '../features/tenants/presentation/pages/tenant_details_page.dart';
import '../features/tenants/presentation/pages/tenant_form_page.dart';
import '../features/units/presentation/bindings/unit_details_binding.dart';
import '../features/units/presentation/bindings/unit_form_binding.dart';
import '../features/units/presentation/pages/unit_details_page.dart';
import '../features/units/presentation/pages/unit_form_page.dart';
import 'app_routes.dart';
import 'middlewares/auth_middleware.dart';
import 'middlewares/onboarding_middleware.dart';

/// Route table. Every page carries its own binding and the middleware that
/// guards it.
abstract class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      middlewares: <GetMiddleware>[OnboardingMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      middlewares: <GetMiddleware>[
        AuthMiddleware(redirectWhenAuthenticated: true),
      ],
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
      middlewares: <GetMiddleware>[
        AuthMiddleware(redirectWhenAuthenticated: true),
      ],
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.main,
      page: () => const MainNavPage(),
      binding: MainNavBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.unitForm,
      page: () => const UnitFormPage(),
      binding: UnitFormBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
      transition: Transition.downToUp,
    ),
    GetPage<dynamic>(
      name: AppRoutes.unitDetails,
      page: () => const UnitDetailsPage(),
      binding: UnitDetailsBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
      transition: Transition.cupertino,
    ),
    GetPage<dynamic>(
      name: AppRoutes.tenantForm,
      page: () => const TenantFormPage(),
      binding: TenantFormBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
      transition: Transition.downToUp,
    ),
    GetPage<dynamic>(
      name: AppRoutes.tenantDetails,
      page: () => const TenantDetailsPage(),
      binding: TenantDetailsBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
      transition: Transition.cupertino,
    ),
  ];
}
