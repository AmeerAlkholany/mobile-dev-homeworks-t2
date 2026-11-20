import 'package:get/get.dart';

import '../constants/app_constants.dart';
import 'storage_service.dart';

/// Holds the signed-in session and exposes it reactively. Any feature can
/// listen to [isLoggedInRx] or read [profile] without knowing how the session
/// is persisted.
class AuthService extends GetxService {
  AuthService(this._storage);

  final StorageService _storage;

  final RxBool _isLoggedIn = false.obs;
  final RxMap<String, dynamic> _profile = <String, dynamic>{}.obs;

  RxBool get isLoggedInRx => _isLoggedIn;

  RxMap<String, dynamic> get profileRx => _profile;

  bool get isLoggedIn => _isLoggedIn.value;

  Map<String, dynamic>? get profile {
    if (_profile.isEmpty) {
      return null;
    }
    return Map<String, dynamic>.unmodifiable(
      Map<String, dynamic>.from(_profile),
    );
  }

  String? get token => _storage.readString(AppConstants.kAuthToken);

  String get displayName {
    final Map<String, dynamic>? data = profile;
    final String name = (data?['name'] as String?)?.trim() ?? '';
    return name;
  }

  AuthService init() {
    final Map<String, dynamic>? saved = _storage.readMap(
      AppConstants.kAuthProfile,
    );
    if (saved != null && saved.isNotEmpty && token != null) {
      _profile.assignAll(saved);
      _isLoggedIn.value = true;
    }
    return this;
  }

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> profile,
  }) async {
    await _storage.writeString(AppConstants.kAuthToken, token);
    await _storage.writeMap(AppConstants.kAuthProfile, profile);
    _profile
      ..clear()
      ..assignAll(profile);
    _isLoggedIn.value = true;
  }

  Future<void> clearSession() async {
    await _storage.remove(AppConstants.kAuthToken);
    await _storage.remove(AppConstants.kAuthProfile);
    _profile.clear();
    _isLoggedIn.value = false;
  }
}
