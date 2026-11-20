import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
  });

  final String titleKey;
  final String descriptionKey;
  final IconData icon;
}

class OnboardingController extends GetxController {
  OnboardingController(this._completeOnboarding);

  final CompleteOnboardingUseCase _completeOnboarding;

  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  bool _finishing = false;

  static const List<OnboardingSlide> _slides = <OnboardingSlide>[
    OnboardingSlide(
      titleKey: 'onboarding_title_1',
      descriptionKey: 'onboarding_desc_1',
      icon: Icons.travel_explore_rounded,
    ),
    OnboardingSlide(
      titleKey: 'onboarding_title_2',
      descriptionKey: 'onboarding_desc_2',
      icon: Icons.verified_user_outlined,
    ),
    OnboardingSlide(
      titleKey: 'onboarding_title_3',
      descriptionKey: 'onboarding_desc_3',
      icon: Icons.event_available_rounded,
    ),
  ];

  List<OnboardingSlide> get slides => _slides;

  bool get isLast => currentIndex.value == _slides.length - 1;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void next() {
    if (isLast) {
      finish();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void skip() => finish();

  Future<void> finish() async {
    if (_finishing) {
      return;
    }
    _finishing = true;
    await _completeOnboarding();
    if (isClosed) {
      return;
    }
    Get.offAllNamed(
      Get.find<AuthService>().isLoggedIn ? AppRoutes.main : AppRoutes.login,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
