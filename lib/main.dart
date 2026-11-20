import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Persistent services are booted before the first frame so theme, locale and
  // session are already resolved when the splash screen appears.
  await Get.putAsync<StorageService>(
    () => StorageService().init(),
    permanent: true,
  );

  runApp(const EjaryApp());
}
