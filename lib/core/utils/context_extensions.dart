import 'package:flutter/material.dart';

/// Short accessors used by pages to keep build methods readable.
extension ThemeColorX on BuildContext {
  ColorScheme get scheme => Theme.of(this).colorScheme;

  TextTheme get texts => Theme.of(this).textTheme;
}
