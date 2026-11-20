import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 16, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'app_name'.tr,
                    style: text.titleMedium?.copyWith(color: scheme.primary),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: controller.skip,
                    child: Text('skip'.tr),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.slides.length,
                itemBuilder: (BuildContext context, int index) {
                  final OnboardingSlide slide = controller.slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 260,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                scheme.primaryContainer,
                                scheme.secondaryContainer,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(
                            slide.icon,
                            size: 104,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          slide.titleKey.tr,
                          textAlign: TextAlign.center,
                          style: text.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.descriptionKey.tr,
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int index = 0;
                      index < controller.slides.length;
                      index++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 7,
                      width: controller.currentIndex.value == index ? 22 : 7,
                      decoration: BoxDecoration(
                        color: controller.currentIndex.value == index
                            ? scheme.primary
                            : scheme.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
              child: Obx(
                () => AppButton(
                  label: controller.isLast ? 'get_started'.tr : 'next'.tr,
                  icon: controller.isLast
                      ? Icons.check_circle_outline_rounded
                      : Icons.arrow_forward_rounded,
                  onPressed: controller.next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
