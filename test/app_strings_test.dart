import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStrings', () {
    test('returns Vietnamese labels for vi locale', () {
      final AppStrings strings = AppStrings(AppLocale.vi);

      expect(strings.t(AppStringKey.navSettings), 'Cài đặt');
      expect(strings.t(AppStringKey.lightMode), 'Sáng');
    });

    test('returns English labels for en locale', () {
      final AppStrings strings = AppStrings(AppLocale.en);

      expect(strings.t(AppStringKey.navSettings), 'Settings');
      expect(strings.t(AppStringKey.lightMode), 'Light');
      expect(strings.t(AppStringKey.loadingData), 'Loading data...');
    });

    test('formats relative date safely', () {
      final AppStrings strings = AppStrings(AppLocale.en);
      final DateTime now = DateTime(2026, 5, 6);

      expect(strings.relativeDate(now, now: now), 'Today');
      expect(strings.relativeDate(DateTime(2026, 5, 5), now: now), 'Yesterday');
      expect(
        strings.relativeDate(DateTime(2026, 5, 1), now: now),
        '05/01/2026',
      );
    });
  });
}
