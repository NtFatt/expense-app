import 'package:expense_app/core/localization/app_locale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocale.fromCode', () {
    test('returns vi for vi code', () {
      expect(AppLocale.fromCode('vi'), AppLocale.vi);
    });

    test('returns en for en code', () {
      expect(AppLocale.fromCode('en'), AppLocale.en);
    });

    test('falls back to vi for invalid code', () {
      expect(AppLocale.fromCode('fr'), AppLocale.vi);
      expect(AppLocale.fromCode(null), AppLocale.vi);
    });
  });
}
