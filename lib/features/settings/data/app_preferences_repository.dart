import 'package:expense_app/features/settings/domain/app_preferences.dart';

abstract interface class AppPreferencesRepository {
  Future<AppPreferences> loadPreferences();

  Future<void> savePreferences(AppPreferences preferences);
}
