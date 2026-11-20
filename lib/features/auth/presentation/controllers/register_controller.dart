import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterController extends GetxController {
  RegisterController(this._register);

  final RegisterUseCase _register;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmHidden = true.obs;
  final RxBool termsAccepted = false.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmVisibility() {
    isConfirmHidden.value = !isConfirmHidden.value;
  }

  void toggleTerms() {
    termsAccepted.value = !termsAccepted.value;
  }

  Future<void> submit() async {
    if (isLoading.value) {
      return;
    }
    final FormState? form = formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (!termsAccepted.value) {
      Get.snackbar(
        'app_name'.tr,
        'validation_terms'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    isLoading.value = true;
    try {
      await _register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
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

  void goToLogin() {
    Get.back<void>();
  }

  void _showError(String message) {
    Get.snackbar(
      'app_name'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  String? validateName(String? value) => AppValidators.required(value);

  String? validateEmail(String? value) => AppValidators.email(value);

  String? validatePhone(String? value) => AppValidators.phone(value);

  String? validatePassword(String? value) => AppValidators.password(value);

  String? validateConfirmPassword(String? value) =>
      AppValidators.confirmPassword(value, passwordController.text);

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
