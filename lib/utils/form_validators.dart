/// Pure validation functions for the Student Authentication System.
///
/// Each validator returns `null` if the input is valid, or a descriptive
/// error string if the validation fails.
class FormValidators {
  // Disallow instantiation
  FormValidators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _digitsOnlyRegExp = RegExp(r'^\d+$');
  static final RegExp _uppercaseRegExp = RegExp(r'[A-Z]');
  static final RegExp _digitRegExp = RegExp(r'[0-9]');
  static final RegExp _sixDigitsRegExp = RegExp(r'^\d{6}$');

  // ==========================================
  // Login Validators
  // ==========================================

  /// Validates the login identifier (Academic ID or University Email).
  static String? validateLoginIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Identifier is required.';
    }
    if (value.trim().length < 5) {
      return 'Identifier must contain at least 5 characters.';
    }
    return null;
  }

  /// Validates the login password.
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must contain at least 6 characters.';
    }
    return null;
  }

  // ==========================================
  // Registration Validators
  // ==========================================

  /// Validates student full name.
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required.';
    }
    if (value.trim().length < 3) {
      return 'Full name must contain at least 3 characters.';
    }
    return null;
  }

  /// Validates student Academic ID (digits only, exactly 9 or 10 digits).
  static String? validateAcademicId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Academic ID is required.';
    }
    final trimmed = value.trim();
    if (!_digitsOnlyRegExp.hasMatch(trimmed)) {
      return 'Academic ID must contain digits only.';
    }
    if (trimmed.length != 9 && trimmed.length != 10) {
      return 'Academic ID must contain exactly 9 or 10 digits.';
    }
    return null;
  }

  /// Validates university email format.
  static String? validateUniversityEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'University email is required.';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid university email address.';
    }
    return null;
  }

  /// Validates registration password against strong password policy:
  /// - At least 8 characters
  /// - At least one uppercase letter
  /// - At least one digit
  static String? validateRegisterPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must contain at least 8 characters.';
    }
    if (!_uppercaseRegExp.hasMatch(value)) {
      return 'Password must include at least one uppercase letter.';
    }
    if (!_digitRegExp.hasMatch(value)) {
      return 'Password must include at least one digit.';
    }
    return null;
  }

  /// Validates confirm password against the original password.
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != password) {
      return 'Passwords do not match.';
    }
    return null;
  }

  /// Validates acceptance of terms and conditions.
  static String? validateTerms(bool accepted) {
    if (!accepted) {
      return 'You must accept the terms and conditions.';
    }
    return null;
  }

  // ==========================================
  // Password Reset Validators
  // ==========================================

  /// Validates the identifier for password reset (min 5 chars).
  static String? validateResetIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Identifier is required.';
    }
    if (value.trim().length < 5) {
      return 'Identifier must contain at least 5 characters.';
    }
    return null;
  }

  /// Validates the 6-digit OTP verification code.
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Verification code is required.';
    }
    final trimmed = value.trim();
    if (!_sixDigitsRegExp.hasMatch(trimmed)) {
      return 'OTP must contain exactly 6 digits.';
    }
    return null;
  }

  /// Validates new password with the strong password policy.
  static String? validateNewPassword(String? value) {
    return validateRegisterPassword(value);
  }

  /// Validates confirm new password matches new password.
  static String? validateConfirmNewPassword(String? value, String newPassword) {
    return validateConfirmPassword(value, newPassword);
  }
}

