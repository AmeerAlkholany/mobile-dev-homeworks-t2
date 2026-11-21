import 'package:get/get.dart';

import '../constants/app_constants.dart';
import 'storage_service.dart';

/// Holds the building's currency code (SAR / USD / AED). Formatting helpers
/// resolve the symbol from here, so changing it in the profile instantly
/// updates every amount in the app.
class CurrencyService extends GetxService {
  CurrencyService(this._storage);

  final StorageService _storage;

  final RxString _code = AppConstants.defaultCurrency.obs;

  CurrencyService init() {
    final String? saved = _storage.readString(AppConstants.kCurrency);
    if (saved != null && AppConstants.currencies.contains(saved)) {
      _code.value = saved;
    }
    return this;
  }

  String get code => _code.value;

  String get symbol => code == AppConstants.defaultCurrency
      ? 'currency_symbol'.tr
      : code;

  Future<void> setCurrency(String code) async {
    if (!AppConstants.currencies.contains(code) || _code.value == code) {
      return;
    }
    _code.value = code;
    await _storage.writeString(AppConstants.kCurrency, code);
  }
}
