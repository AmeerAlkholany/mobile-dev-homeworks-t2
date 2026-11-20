import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/register_controller.dart';
import '../widgets/auth_scaffold.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return AuthScaffold(
      title: 'register_button'.tr,
      subtitle: 'app_tagline'.tr,
      children: <Widget>[
        Form(
          key: controller.formKey,
          child: Column(
            children: <Widget>[
              AppTextField(
                controller: controller.nameController,
                label: 'full_name'.tr,
                hint: 'name_hint'.tr,
                prefixIcon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
                validator: controller.validateName,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: controller.emailController,
                label: 'email'.tr,
                hint: 'email_hint'.tr,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: controller.validateEmail,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: controller.phoneController,
                label: 'phone'.tr,
                hint: 'phone_hint'.tr,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: controller.validatePhone,
              ),
              const SizedBox(height: 14),
              Obx(
                () => AppTextField(
                  controller: controller.passwordController,
                  label: 'password'.tr,
                  hint: 'password_hint'.tr,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: controller.isPasswordHidden.value,
                  textInputAction: TextInputAction.next,
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
              const SizedBox(height: 14),
              Obx(
                () => AppTextField(
                  controller: controller.confirmPasswordController,
                  label: 'confirm_password'.tr,
                  prefixIcon: Icons.lock_reset_rounded,
                  obscureText: controller.isConfirmHidden.value,
                  textInputAction: TextInputAction.done,
                  validator: controller.validateConfirmPassword,
                  suffixIcon: IconButton(
                    onPressed: controller.toggleConfirmVisibility,
                    icon: Icon(
                      controller.isConfirmHidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => InkWell(
                  onTap: controller.toggleTerms,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: controller.termsAccepted.value,
                          onChanged: (_) => controller.toggleTerms(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'terms_text'.tr,
                              style: text.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => AppButton(
            label: 'register_button'.tr,
            isLoading: controller.isLoading.value,
            onPressed: controller.submit,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'have_account'.tr,
              style: text.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: controller.goToLogin,
              child: Text('sign_in_link'.tr),
            ),
          ],
        ),
      ],
    );
  }
}
