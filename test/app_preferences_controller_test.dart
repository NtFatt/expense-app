import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/features/settings/data/app_preferences_repository.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:expense_app/features/settings/presentation/controllers/app_preferences_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPreferencesController', () {
    test('setLocale updates state and persists value', () async {
      final FakeAppPreferencesRepository repository =
          FakeAppPreferencesRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          appPreferencesRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(appPreferencesControllerProvider.future);
      await container
          .read(appPreferencesControllerProvider.notifier)
          .setLocale(AppLocale.en);

      final AppPreferences preferences = container.read(
        resolvedAppPreferencesProvider,
      );

      expect(preferences.locale, AppLocale.en);
      expect(repository.saved.locale, AppLocale.en);
    });

    test('setTheme updates state and persists value', () async {
      final FakeAppPreferencesRepository repository =
          FakeAppPreferencesRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          appPreferencesRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(appPreferencesControllerProvider.future);
      await container
          .read(appPreferencesControllerProvider.notifier)
          .setTheme(AppThemePreference.dark);

      final AppPreferences preferences = container.read(
        resolvedAppPreferencesProvider,
      );

      expect(preferences.theme, AppThemePreference.dark);
      expect(repository.saved.theme, AppThemePreference.dark);
    });
  });
}

class FakeAppPreferencesRepository implements AppPreferencesRepository {
  AppPreferences saved = AppPreferences.defaults;

  @override
  Future<AppPreferences> loadPreferences() async {
    return saved;
  }

  @override
  Future<void> savePreferences(AppPreferences preferences) async {
    saved = preferences;
  }
}
