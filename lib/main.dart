import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'core/bindings/initial_binding.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Persistent services are booted before the first frame so theme, locale and
  // session are already resolved when the splash screen appears.
  await Get.putAsync<StorageService>(
    () => StorageService().init(),
    permanent: true,
  );

  // The remaining app-wide services must exist before the root widget builds,
  // because `EjaryApp` reads the theme and locale there.
  InitialBinding().dependencies();

  runApp(const EjaryApp());
}
