import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'home/home_page.dart';
import 'shared/theme/app_theme.dart';

void main() {
  // ProviderScope provides the Riverpod container; GetMaterialApp provides the
  // GetX routing/snackbar infrastructure. They coexist without interference.
  runApp(const ProviderScope(child: CounterApp()));
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Interactive Counter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}
