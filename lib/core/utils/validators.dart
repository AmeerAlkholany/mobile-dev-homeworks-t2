import 'package:get/get.dart';

/// Reusable form validators. Error strings are localization keys resolved at
/// validation time so they follow the active locale.
class AppValidators {
  const AppValidators._();

  static final RegExp _emailPattern = RegExp(
    r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
  );
  static final RegExp _phonePattern = RegExp(r'^\+?[0-9]{9,15}$');
  static final RegExp _nationalIdPattern = RegExp(r'^[0-9]{10}$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_required'.tr;
    }
    return null;
  }

  static String? email(String? value) {
    final String? empty = required(value);
    if (empty != null) {
      return empty;
    }
    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'validation_email'.tr;
    }
    return null;
  }

  static String? password(String? value) {
    final String? empty = required(value);
    if (empty != null) {
      return empty;
    }
    if (value!.length < 6) {
      return 'validation_password'.tr;
    }
    return null;
  }

  static String? phone(String? value) {
    final String? empty = required(value);
    if (empty != null) {
      return empty;
    }
    final String normalized = value!.replaceAll(RegExp(r'[\s-]'), '');
    if (!_phonePattern.hasMatch(normalized)) {
      return 'validation_phone'.tr;
    }
    return null;
  }

  static String? nationalId(String? value) {
    final String? empty = required(value);
    if (empty != null) {
      return empty;
    }
    if (!_nationalIdPattern.hasMatch(value!.trim())) {
      return 'validation_national_id'.tr;
    }
    return null;
  }

  static String? amount(String? value) {
    final String? empty = required(value);
    if (empty != null) {
      return empty;
    }
    final double? parsed = double.tryParse(value!.trim());
    if (parsed == null || parsed <= 0) {
      return 'validation_amount'.tr;
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final String? empty = required(value);
    if (empty != null) {
      return empty;
    }
    if (value != original) {
      return 'validation_password_mismatch'.tr;
    }
    return null;
  }
}
