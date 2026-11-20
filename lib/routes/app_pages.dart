import 'package:get/get.dart';

import '../features/auth/presentation/bindings/login_binding.dart';
import '../features/auth/presentation/bindings/register_binding.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/bookings/presentation/bindings/booking_flow_binding.dart';
import '../features/bookings/presentation/pages/booking_flow_page.dart';
import '../features/main_nav/presentation/bindings/main_nav_binding.dart';
import '../features/main_nav/presentation/pages/main_nav_page.dart';
import '../features/onboarding/presentation/bindings/onboarding_binding.dart';
import '../features/onboarding/presentation/bindings/splash_binding.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/onboarding/presentation/pages/splash_page.dart';
import '../features/properties/presentation/bindings/property_details_binding.dart';
import '../features/properties/presentation/pages/property_details_page.dart';
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
      name: AppRoutes.propertyDetails,
      page: () => const PropertyDetailsPage(),
      binding: PropertyDetailsBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
      transition: Transition.cupertino,
    ),
    GetPage<dynamic>(
      name: AppRoutes.bookingFlow,
      page: () => const BookingFlowPage(),
      binding: BookingFlowBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
      transition: Transition.downToUp,
    ),
  ];
}
