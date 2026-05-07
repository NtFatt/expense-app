import 'package:expense_app/features/settings/data/app_preferences_repository.dart';
import 'package:expense_app/features/settings/data/shared_preferences_app_preferences_repository.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_locale.dart';

final appPreferencesRepositoryProvider = Provider<AppPreferencesRepository>(
  (Ref ref) => const SharedPreferencesAppPreferencesRepository(),
);

final appPreferencesControllerProvider =
    AsyncNotifierProvider<AppPreferencesController, AppPreferences>(
      AppPreferencesController.new,
    );

final resolvedAppPreferencesProvider = Provider<AppPreferences>((Ref ref) {
  return ref.watch(appPreferencesControllerProvider).asData?.value ??
      AppPreferences.defaults;
});

class AppPreferencesController extends AsyncNotifier<AppPreferences> {
  @override
  Future<AppPreferences> build() async {
    return ref.read(appPreferencesRepositoryProvider).loadPreferences();
  }

  Future<void> setLocale(AppLocale locale) async {
    final AppPreferences current =
        state.asData?.value ?? AppPreferences.defaults;
    if (current.locale == locale) {
      return;
    }

    await _persist(current.copyWith(locale: locale));
  }

  Future<void> setTheme(AppThemePreference theme) async {
    final AppPreferences current =
        state.asData?.value ?? AppPreferences.defaults;
    if (current.theme == theme) {
      return;
    }

    await _persist(current.copyWith(theme: theme));
  }

  Future<void> _persist(AppPreferences next) async {
    state = AsyncData<AppPreferences>(next);
    await ref.read(appPreferencesRepositoryProvider).savePreferences(next);
  }
}
