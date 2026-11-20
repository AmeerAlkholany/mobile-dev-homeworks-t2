import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginController extends GetxController {
  LoginController(this._login);

  final LoginUseCase _login;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordHidden = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> submit() async {
    if (isLoading.value) {
      return;
    }
    final FormState? form = formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    isLoading.value = true;
    try {
      await _login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      Get.offAllNamed(AppRoutes.main);
    } on AppException {
      _showError('error_login_failed'.tr);
    } catch (_) {
      _showError('error_generic'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  void onForgotPassword() {
    Get.snackbar(
      'forgot_password'.tr,
      'demo_hint'.tr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'app_name'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  String? validateEmail(String? value) => AppValidators.email(value);

  String? validatePassword(String? value) => AppValidators.password(value);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
