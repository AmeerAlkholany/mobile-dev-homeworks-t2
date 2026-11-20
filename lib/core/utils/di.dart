import 'package:get/get.dart';

/// Registers [T] lazily once and keeps it recoverable (`fenix`). Feature
/// bindings call this so shared contracts (repositories, use cases) can be
/// resolved from several screens without duplicate-registration errors.
void registerLazy<T>(T Function() builder) {
  if (!Get.isRegistered<T>()) {
    Get.lazyPut<T>(builder, fenix: true);
  }
}
