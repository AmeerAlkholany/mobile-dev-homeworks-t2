import 'package:flutter/material.dart';

/// Design tokens shared by the home screen and both counter screens.
abstract final class AppTheme {
  /// Accent used by the GetX implementation.
  static const Color getxAccent = Color(0xFF4F46E5);

  /// Accent used by the Riverpod implementation.
  static const Color riverpodAccent = Color(0xFF0D9488);

  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF312E81));

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
