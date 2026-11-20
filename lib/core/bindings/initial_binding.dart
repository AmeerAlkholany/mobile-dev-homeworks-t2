import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../services/locale_service.dart';
import '../services/storage_service.dart';
import '../services/theme_service.dart';

/// Registers app-wide `GetxService`s once, before any route is resolved.
/// [StorageService] is booted asynchronously in `main.dart` so this binding can
/// wire the remaining services synchronously with the resolved instance.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final StorageService storage = Get.find<StorageService>();

    Get.put<ThemeService>(ThemeService(storage).init(), permanent: true);
    Get.put<LocaleService>(LocaleService(storage).init(), permanent: true);
    Get.put<AuthService>(AuthService(storage).init(), permanent: true);
  }
}
