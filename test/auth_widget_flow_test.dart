import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/views/auth/login_page.dart';
import 'package:flutter_application_1/views/auth/reset_password_page.dart';

Widget createTestApp({required Widget child}) {
  return MaterialApp(
    home: child,
  );
}

void main() {
  late AuthRepositoryImpl repository;
  late AuthController controller;

  setUp(() {
    repository = AuthRepositoryImpl(simulatedDelay: Duration.zero);
    controller = AuthController(authRepository: repository);
  });

  group('UI & Navigation Flow Tests', () {
    testWidgets('LoginPage renders correctly and validates empty input', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestApp(child: LoginPage(controller: controller)));

      expect(find.text('Student Portal'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Academic Demo Credentials'), findsOneWidget);

      // Attempt submit without filling fields
      await tester.ensureVisible(find.text('Sign In'));
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Identifier is required.'), findsOneWidget);
      expect(find.text('Password is required.'), findsOneWidget);
    });

    testWidgets('Navigation from LoginPage to RegisterPage', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestApp(child: LoginPage(controller: controller)));

      // Tap Register Here
      await tester.ensureVisible(find.text('Register Here'));
      await tester.tap(find.text('Register Here'));
      await tester.pumpAndSettle();

      expect(find.text('Student Registration'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);

      // Tap Back to Sign In
      await tester.ensureVisible(find.text('Sign In'));
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Student Portal'), findsOneWidget);
    });

    testWidgets('Navigation from LoginPage to ForgotPasswordPage', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestApp(child: LoginPage(controller: controller)));

      // Tap Forgot Password?
      await tester.ensureVisible(find.text('Forgot Password?'));
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.text('Password Recovery'), findsOneWidget);
      expect(find.text('Send Verification Code'), findsOneWidget);

      // Test empty submit on ForgotPasswordPage
      await tester.ensureVisible(find.text('Send Verification Code'));
      await tester.tap(find.text('Send Verification Code'));
      await tester.pumpAndSettle();
      expect(find.text('Identifier is required.'), findsOneWidget);
    });

    testWidgets('ResetPasswordPage renders OTP and password fields', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        createTestApp(
          child: ResetPasswordPage(
            controller: controller,
            initialIdentifier: '2024101234',
          ),
        ),
      );

      expect(find.text('Set New Password'), findsOneWidget);
      expect(find.text('6-Digit Verification Code (OTP)'), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);

      // Tap Update Password with empty OTP/passwords
      await tester.ensureVisible(find.text('Update Password'));
      await tester.tap(find.text('Update Password'));
      await tester.pumpAndSettle();

      expect(find.text('Verification code is required.'), findsOneWidget);
      expect(find.text('Password is required.'), findsOneWidget);
    });
  });
}
