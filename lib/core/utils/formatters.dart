import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Locale-independent, bidi-safe formatting helpers. Numbers stay in Latin
/// digits so prices read correctly in both Arabic and English layouts.
class AppFormatters {
  const AppFormatters._();

  static final NumberFormat _amount = NumberFormat('#,##0', 'en_US');

  static String amount(num value) => _amount.format(value);

  static String price(num value) => '${amount(value)} ${'currency_symbol'.tr}';

  /// Example: "15 March 2026" / "١٥ مارس ٢٠٢٦" translated month name.
  static String fullDate(DateTime date) =>
      '${date.day} ${'month_${date.month}'.tr} ${date.year}';

  static String monthYear(DateTime date) =>
      '${'month_${date.month}'.tr} ${date.year}';

  static String moveInLabel(DateTime date) => fullDate(date);
}
