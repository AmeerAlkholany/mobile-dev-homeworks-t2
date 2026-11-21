import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

/// Thin, typed wrapper around [GetStorage]. Every persistent value in Ejary
/// (theme, locale, onboarding flag, session, favorites, bookings) goes through
/// this service so the storage backend stays swappable and testable.
class StorageService extends GetxService {
  /// GetStorage container name, shared by [GetStorage.init] and the box itself.
  static const String _container = 'GetStorage';

  late final GetStorage _box;

  GetStorage get box => _box;

  /// Boots GetStorage. Registered with `Get.putAsync` in `main.dart`.
  ///
  /// The box lives in the app-support directory rather than the platform
  /// default (`Documents` on Windows), which may not exist for the current user
  /// and made GetStorage throw `PathNotFoundException` on startup.
  Future<StorageService> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    // get_storage 2.1.x takes the directory on the box constructor, and
    // `GetStorage.init` only accepts a container name: it reuses the instance
    // already created for that container, so the box must be built first for
    // the init call to honour [dir] instead of the default Documents path.
    _box = GetStorage(_container, dir.path);
    await GetStorage.init(_container);
    return this;
  }

  bool has(String key) => _box.hasData(key);

  String? readString(String key) => _box.read<String>(key);

  Future<void> writeString(String key, String value) async {
    await _box.write(key, value);
  }

  bool readBool(String key, {bool fallback = false}) =>
      _box.read<bool>(key) ?? fallback;

  Future<void> writeBool(String key, bool value) async {
    await _box.write(key, value);
  }

  Map<String, dynamic>? readMap(String key) {
    final Object? raw = _box.read<Object?>(key);
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) async {
    await _box.write(key, value);
  }

  List<Map<String, dynamic>> readListOfMaps(String key) {
    final Object? raw = _box.read<Object?>(key);
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((Map item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  Future<void> writeListOfMaps(
    String key,
    List<Map<String, dynamic>> value,
  ) async {
    await _box.write(key, value);
  }

  List<String> readStringList(String key) {
    final Object? raw = _box.read<Object?>(key);
    if (raw is List) {
      return raw.whereType<String>().toList();
    }
    return <String>[];
  }

  Future<void> writeStringList(String key, List<String> value) async {
    await _box.write(key, value);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clearAll() async {
    await _box.erase();
  }
}
