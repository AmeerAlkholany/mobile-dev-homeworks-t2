import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/currency_service.dart';

/// Locale-independent, bidi-safe formatting helpers. Numbers stay in Latin
/// digits so prices read correctly in both Arabic and English layouts.
class AppFormatters {
  const AppFormatters._();

  static final NumberFormat _amount = NumberFormat('#,##0.##', 'en_US');

  static String amount(num value) => _amount.format(value);

  /// Active currency symbol (localized SAR symbol, or the ISO code).
  static String get currencySymbol {
    if (Get.isRegistered<CurrencyService>()) {
      return Get.find<CurrencyService>().symbol;
    }
    return 'currency_symbol'.tr;
  }

  static String price(num value) => '${amount(value)} $currencySymbol';

  /// Example: "15 March 2026" / localized Arabic month name.
  static String fullDate(DateTime date) =>
      '${date.day} ${'month_${date.month}'.tr} ${date.year}';

  static String monthYear(DateTime date) =>
      '${'month_${date.month}'.tr} ${date.year}';

  static String monthLabel(DateTime date) => monthYear(date);

  static DateTime monthStart(DateTime date) => DateTime(date.year, date.month);

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  /// Inclusive day count from [from] to [to]; always zero or positive.
  static int daysUntil(DateTime from, DateTime to) {
    final DateTime start = DateTime(from.year, from.month, from.day);
    final DateTime end = DateTime(to.year, to.month, to.day);
    final int days = end.difference(start).inDays;
    return days < 0 ? 0 : days;
  }
}
