import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/usecases/get_onboarding_status_usecase.dart';

/// Waits for the minimum splash animation window, then routes to onboarding,
/// login or the app shell based on persisted state.
class SplashController extends GetxController {
  SplashController(this._getOnboardingStatus, this._auth);

  final GetOnboardingStatusUseCase _getOnboardingStatus;
  final AuthService _auth;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final Future<void> minimumDelay = Future<void>.delayed(
      const Duration(milliseconds: 1700),
    );
    final bool completed = await _getOnboardingStatus();
    await minimumDelay;
    if (isClosed) {
      return;
    }
    if (!completed) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }
    Get.offAllNamed(_auth.isLoggedIn ? AppRoutes.main : AppRoutes.login);
  }
}
