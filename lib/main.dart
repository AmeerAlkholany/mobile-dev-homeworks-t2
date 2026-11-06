import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate Repository and inject into Controller (Dependency Injection)
  final authRepository = AuthRepositoryImpl();
  final authController = AuthController(authRepository: authRepository);

  runApp(StudentAuthApp(controller: authController));
}

/// Root Application Widget for the Student Authentication System.
class StudentAuthApp extends StatelessWidget {
  final AuthController controller;

  const StudentAuthApp({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const navyPrimary = Color(0xFF1E3A8A); // Academic Navy Blue
    const lightSurface = Color(0xFFF8FAFC);

    return MaterialApp(
      title: 'Student Authentication Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navyPrimary,
          primary: navyPrimary,
          surface: lightSurface,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: lightSurface,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
          elevation: 0.5,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: navyPrimary, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.8),
          ),
          labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: navyPrimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        fontFamily: null,
      ),
      home: LoginPage(controller: controller),
    );
  }
}
