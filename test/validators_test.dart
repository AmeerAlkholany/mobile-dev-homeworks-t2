import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/utils/form_validators.dart';

void main() {
  group('FormValidators - Login', () {
    test('Empty identifier should fail', () {
      expect(FormValidators.validateLoginIdentifier(''), 'Identifier is required.');
      expect(FormValidators.validateLoginIdentifier('   '), 'Identifier is required.');
      expect(FormValidators.validateLoginIdentifier(null), 'Identifier is required.');
    });

    test('Identifier shorter than 5 chars should fail', () {
      expect(FormValidators.validateLoginIdentifier('1234'),
          'Identifier must contain at least 5 characters.');
    });

    test('Valid identifier should pass', () {
      expect(FormValidators.validateLoginIdentifier('2024101234'), isNull);
      expect(FormValidators.validateLoginIdentifier('student@university.edu'), isNull);
    });

    test('Empty or short password should fail', () {
      expect(FormValidators.validateLoginPassword(''), 'Password is required.');
      expect(FormValidators.validateLoginPassword(null), 'Password is required.');
      expect(FormValidators.validateLoginPassword('12345'),
          'Password must contain at least 6 characters.');
    });

    test('Valid password should pass', () {
      expect(FormValidators.validateLoginPassword('123456'), isNull);
      expect(FormValidators.validateLoginPassword('Password123'), isNull);
    });
  });

  group('FormValidators - Registration', () {
    test('Full name validation', () {
      expect(FormValidators.validateFullName(''), 'Full name is required.');
      expect(FormValidators.validateFullName('Ab'),
          'Full name must contain at least 3 characters.');
      expect(FormValidators.validateFullName('Ahmad Al-Mansoor'), isNull);
    });

    test('Academic ID validation (digits only, exactly 9 or 10 digits)', () {
      expect(FormValidators.validateAcademicId(''), 'Academic ID is required.');
      expect(FormValidators.validateAcademicId('12345678'),
          'Academic ID must contain exactly 9 or 10 digits.');
      expect(FormValidators.validateAcademicId('12345678901'),
          'Academic ID must contain exactly 9 or 10 digits.');
      expect(FormValidators.validateAcademicId('20241A123'),
          'Academic ID must contain digits only.');
      expect(FormValidators.validateAcademicId('123456789'), isNull); // 9 digits
      expect(FormValidators.validateAcademicId('2024101234'), isNull); // 10 digits
    });

    test('University email regex validation', () {
      expect(FormValidators.validateUniversityEmail(''),
          'University email is required.');
      expect(FormValidators.validateUniversityEmail('plainaddress'),
          'Please enter a valid university email address.');
      expect(FormValidators.validateUniversityEmail('missingatsign.com'),
          'Please enter a valid university email address.');
      expect(FormValidators.validateUniversityEmail('@missingusername.com'),
          'Please enter a valid university email address.');
      expect(FormValidators.validateUniversityEmail('student@university.edu'), isNull);
      expect(FormValidators.validateUniversityEmail('user.name@sub.domain.edu'), isNull);
    });

    test('Registration strong password policy', () {
      expect(FormValidators.validateRegisterPassword(''), 'Password is required.');
      expect(FormValidators.validateRegisterPassword('Pass1'),
          'Password must contain at least 8 characters.');
      expect(FormValidators.validateRegisterPassword('password123'),
          'Password must include at least one uppercase letter.');
      expect(FormValidators.validateRegisterPassword('PasswordABC'),
          'Password must include at least one digit.');
      expect(FormValidators.validateRegisterPassword('Password123'), isNull);
    });

    test('Confirm password match validation', () {
      expect(FormValidators.validateConfirmPassword('', 'Password123'),
          'Please confirm your password.');
      expect(FormValidators.validateConfirmPassword('Different123', 'Password123'),
          'Passwords do not match.');
      expect(FormValidators.validateConfirmPassword('Password123', 'Password123'),
          isNull);
    });

    test('Terms acceptance validation', () {
      expect(FormValidators.validateTerms(false),
          'You must accept the terms and conditions.');
      expect(FormValidators.validateTerms(true), isNull);
    });
  });

  group('FormValidators - Password Reset', () {
    test('Reset identifier validation', () {
      expect(FormValidators.validateResetIdentifier(''), 'Identifier is required.');
      expect(FormValidators.validateResetIdentifier('123'),
          'Identifier must contain at least 5 characters.');
      expect(FormValidators.validateResetIdentifier('2024101234'), isNull);
    });

    test('OTP validation (must be exactly 6 digits)', () {
      expect(FormValidators.validateOtp(''), 'Verification code is required.');
      expect(FormValidators.validateOtp('12345'),
          'OTP must contain exactly 6 digits.');
      expect(FormValidators.validateOtp('1234567'),
          'OTP must contain exactly 6 digits.');
      expect(FormValidators.validateOtp('12A456'),
          'OTP must contain exactly 6 digits.');
      expect(FormValidators.validateOtp('123456'), isNull);
    });

    test('New password and confirm new password validation', () {
      expect(FormValidators.validateNewPassword('weak'),
          'Password must contain at least 8 characters.');
      expect(FormValidators.validateNewPassword('SecurePass99'), isNull);
      expect(FormValidators.validateConfirmNewPassword('Mismatch1', 'SecurePass99'),
          'Passwords do not match.');
      expect(FormValidators.validateConfirmNewPassword('SecurePass99', 'SecurePass99'),
          isNull);
    });
  });
}

