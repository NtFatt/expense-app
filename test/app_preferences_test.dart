import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPreferences', () {
    test('defaults are correct', () {
      expect(AppPreferences.defaults.locale, AppLocale.vi);
      expect(AppPreferences.defaults.theme, AppThemePreference.system);
    });

    test('copyWith updates provided values only', () {
      const AppPreferences initial = AppPreferences.defaults;

      final AppPreferences updated = initial.copyWith(
        locale: AppLocale.en,
        theme: AppThemePreference.dark,
      );

      expect(updated.locale, AppLocale.en);
      expect(updated.theme, AppThemePreference.dark);
    });
  });
}
