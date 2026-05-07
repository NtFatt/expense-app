import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/features/settings/data/shared_preferences_app_preferences_repository.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('SharedPreferencesAppPreferencesRepository', () {
    test('returns defaults when storage is empty', () async {
      final repository = SharedPreferencesAppPreferencesRepository();

      final preferences = await repository.loadPreferences();

      expect(preferences.locale, AppLocale.vi);
      expect(preferences.theme, AppThemePreference.system);
    });

    test('falls back safely for invalid stored values', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'expense_app.language_code': 'fr',
        'expense_app.theme_mode': 'sepia',
      });

      final repository = SharedPreferencesAppPreferencesRepository();
      final preferences = await repository.loadPreferences();

      expect(preferences.locale, AppLocale.vi);
      expect(preferences.theme, AppThemePreference.system);
    });

    test('loads saved preferences', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'expense_app.language_code': 'en',
        'expense_app.theme_mode': 'dark',
      });

      final repository = SharedPreferencesAppPreferencesRepository();
      final preferences = await repository.loadPreferences();

      expect(preferences.locale, AppLocale.en);
      expect(preferences.theme, AppThemePreference.dark);
    });
  });
}
