import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/login_controller.dart';
import '../widgets/auth_scaffold.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return AuthScaffold(
      title: 'login_welcome'.tr,
      subtitle: 'login_subtitle'.tr,
      children: <Widget>[
        Form(
          key: controller.formKey,
          child: Column(
            children: <Widget>[
              AppTextField(
                controller: controller.emailController,
                label: 'email'.tr,
                hint: 'email_hint'.tr,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: controller.validateEmail,
              ),
              const SizedBox(height: 16),
              Obx(
                () => AppTextField(
                  controller: controller.passwordController,
                  label: 'password'.tr,
                  hint: 'password_hint'.tr,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: controller.isPasswordHidden.value,
                  textInputAction: TextInputAction.done,
                  validator: controller.validatePassword,
                  suffixIcon: IconButton(
                    onPressed: controller.togglePasswordVisibility,
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: controller.onForgotPassword,
                  child: Text('forgot_password'.tr),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => AppButton(
            label: 'login_button'.tr,
            isLoading: controller.isLoading.value,
            onPressed: controller.submit,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: scheme.secondaryContainer.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: scheme.onSecondaryContainer,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'demo_hint'.tr,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSecondaryContainer,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'no_account'.tr,
              style: text.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: controller.goToRegister,
              child: Text('create_account'.tr),
            ),
          ],
        ),
      ],
    );
  }
}
