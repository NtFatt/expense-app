import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';

final class AppPreferences {
  const AppPreferences({required this.locale, required this.theme});

  final AppLocale locale;
  final AppThemePreference theme;

  static const AppPreferences defaults = AppPreferences(
    locale: AppLocale.vi,
    theme: AppThemePreference.system,
  );

  AppPreferences copyWith({AppLocale? locale, AppThemePreference? theme}) {
    return AppPreferences(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
    );
  }
}
