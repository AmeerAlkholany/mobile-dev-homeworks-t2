import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/models/login_request.dart';
import 'package:flutter_application_1/models/password_reset_request.dart';
import 'package:flutter_application_1/models/register_request.dart';
import 'package:flutter_application_1/repositories/auth_repository_impl.dart';

void main() {
  late AuthRepositoryImpl repository;
  late AuthController controller;

  setUp(() {
    // Use 0ms delay for fast deterministic testing
    repository = AuthRepositoryImpl(simulatedDelay: Duration.zero);
    controller = AuthController(authRepository: repository);
  });

  group('AuthRepository & AuthController - Login', () {
    test('Successful login with Academic ID and correct password', () async {
      await controller.login(
        const LoginRequest(
          identifier: '2024101234',
          password: 'Password123',
        ),
      );

      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentUser, isNotNull);
      expect(controller.currentUser!.academicId, '2024101234');
      expect(controller.currentUser!.fullName, 'Ahmad Al-Mansoor');
      expect(controller.errorMessage, isNull);
      expect(controller.successMessage, contains('Welcome back'));
    });

    test('Successful login with Email and correct password', () async {
      await controller.login(
        const LoginRequest(
          identifier: 'student@university.edu',
          password: 'Password123',
        ),
      );

      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentUser!.email, 'student@university.edu');
    });

    test('Failed login with wrong password', () async {
      await controller.login(
        const LoginRequest(
          identifier: '2024101234',
          password: 'WrongPassword99',
        ),
      );

      expect(controller.isAuthenticated, isFalse);
      expect(controller.currentUser, isNull);
      expect(controller.errorMessage, 'Invalid password. Please check your credentials.');
    });

    test('Failed login with non-existent student', () async {
      await controller.login(
        const LoginRequest(
          identifier: '9999999999',
          password: 'Password123',
        ),
      );

      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage, contains('No student account found'));
    });
  });

  group('AuthRepository & AuthController - Registration', () {
    test('Successful registration of a new student', () async {
      await controller.register(
        const RegisterRequest(
          fullName: 'Fatima Al-Zahra',
          academicId: '2024109876',
          universityEmail: 'fatima@university.edu',
          password: 'Password123',
        ),
      );

      expect(controller.isSuccess, isTrue);
      expect(controller.errorMessage, isNull);
      expect(controller.successMessage, contains('Registration successful'));

      // Now verify the newly registered student can log in
      await controller.login(
        const LoginRequest(
          identifier: '2024109876',
          password: 'Password123',
        ),
      );

      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentUser!.fullName, 'Fatima Al-Zahra');
    });

    test('Registration fails on duplicate Academic ID', () async {
      await controller.register(
        const RegisterRequest(
          fullName: 'Duplicate Student',
          academicId: '2024101234', // Already exists in seeded data
          universityEmail: 'newemail@university.edu',
          password: 'Password123',
        ),
      );

      expect(controller.isSuccess, isFalse);
      expect(controller.hasError, isTrue);
      expect(controller.errorMessage, contains('already registered'));
    });

    test('Registration fails on duplicate University Email', () async {
      await controller.register(
        const RegisterRequest(
          fullName: 'Duplicate Student',
          academicId: '2024103333',
          universityEmail: 'student@university.edu', // Already exists in seeded data
          password: 'Password123',
        ),
      );

      expect(controller.isSuccess, isFalse);
      expect(controller.hasError, isTrue);
      expect(controller.errorMessage, contains('already registered'));
    });
  });

  group('AuthRepository & AuthController - Password Recovery & Reset', () {
    test('Send reset code fails for unknown student', () async {
      await controller.sendPasswordResetCode('unknown@university.edu');

      expect(controller.hasError, isTrue);
      expect(controller.errorMessage, contains('No registered student account was found'));
    });

    test('Send reset code succeeds for existing student', () async {
      await controller.sendPasswordResetCode('2024101234');

      expect(controller.isSuccess, isTrue);
      expect(controller.successMessage, contains('123456'));
    });

    test('Reset password fails with incorrect OTP', () async {
      await controller.resetPassword(
        const PasswordResetRequest(
          identifier: '2024101234',
          verificationCode: '000000', // Incorrect
          newPassword: 'NewPassword999',
        ),
      );

      expect(controller.hasError, isTrue);
      expect(controller.errorMessage, contains('Invalid verification code'));
    });

    test('Reset password succeeds with correct development OTP (123456)', () async {
      await controller.resetPassword(
        const PasswordResetRequest(
          identifier: '2024101234',
          verificationCode: '123456',
          newPassword: 'NewPassword999',
        ),
      );

      expect(controller.isSuccess, isTrue);
      expect(controller.successMessage, contains('Password has been successfully updated'));

      // Verify student can now login with the NEW password
      await controller.login(
        const LoginRequest(
          identifier: '2024101234',
          password: 'NewPassword999',
        ),
      );
      expect(controller.isAuthenticated, isTrue);

      // Verify old password no longer works
      controller.logout();
      await controller.login(
        const LoginRequest(
          identifier: '2024101234',
          password: 'Password123',
        ),
      );
      expect(controller.isAuthenticated, isFalse);
    });
  });
}

