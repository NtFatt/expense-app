import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/features/settings/data/app_preferences_repository.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesAppPreferencesRepository
    implements AppPreferencesRepository {
  const SharedPreferencesAppPreferencesRepository();

  static const String _languageCodeKey = 'expense_app.language_code';
  static const String _themeModeKey = 'expense_app.theme_mode';

  Future<SharedPreferences> get _preferences async {
    return SharedPreferences.getInstance();
  }

  @override
  Future<AppPreferences> loadPreferences() async {
    final SharedPreferences preferences = await _preferences;

    return AppPreferences(
      locale: AppLocale.fromCode(preferences.getString(_languageCodeKey)),
      theme: AppThemePreference.fromStorageValue(
        preferences.getString(_themeModeKey),
      ),
    );
  }

  @override
  Future<void> savePreferences(AppPreferences preferences) async {
    final SharedPreferences sharedPreferences = await _preferences;

    await sharedPreferences.setString(
      _languageCodeKey,
      preferences.locale.languageCode,
    );
    await sharedPreferences.setString(
      _themeModeKey,
      preferences.theme.storageValue,
    );
  }
}
