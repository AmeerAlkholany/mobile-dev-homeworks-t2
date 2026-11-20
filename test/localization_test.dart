import 'package:flutter_application_1/core/localization/locales/ar_sa.dart';
import 'package:flutter_application_1/core/localization/locales/en_us.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Arabic and English dictionaries expose the same keys', () {
    expect(
      arSa.keys.toSet(),
      equals(enUs.keys.toSet()),
      reason: 'Every UI string needs a translation in both locales.',
    );
  });

  test('no translation is blank', () {
    for (final MapEntry<String, String> entry in enUs.entries) {
      expect(entry.value.trim(), isNotEmpty, reason: 'en_US: ${entry.key}');
    }
    for (final MapEntry<String, String> entry in arSa.entries) {
      expect(entry.value.trim(), isNotEmpty, reason: 'ar_SA: ${entry.key}');
    }
  });
}
