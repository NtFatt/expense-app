import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:expense_app/features/settings/presentation/controllers/app_preferences_controller.dart';
import 'package:expense_app/shared/widgets/app_bottom_navigation.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _setLocale(
    BuildContext context,
    WidgetRef ref,
    AppLocale locale,
  ) async {
    await ref.read(appPreferencesControllerProvider.notifier).setLocale(locale);
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.strings.t(AppStringKey.preferencesSaved))),
    );
  }

  Future<void> _setTheme(
    BuildContext context,
    WidgetRef ref,
    AppThemePreference theme,
  ) async {
    await ref.read(appPreferencesControllerProvider.notifier).setTheme(theme);
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.strings.t(AppStringKey.preferencesSaved))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPreferences preferences = ref.watch(
      resolvedAppPreferencesProvider,
    );
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AppScaffold(
      title: context.strings.t(AppStringKey.settingsTitle),
      bottomNavigationBar: const AppBottomNavigation(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.strings.t(AppStringKey.settingsSubtitle),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          _SettingsSection(
            title: context.strings.t(AppStringKey.language),
            child: Column(
              children: <Widget>[
                _PreferenceOptionTile<AppLocale>(
                  title: context.strings.t(AppStringKey.vietnamese),
                  value: AppLocale.vi,
                  groupValue: preferences.locale,
                  onSelected: (AppLocale value) {
                    _setLocale(context, ref, value);
                  },
                ),
                const Divider(height: 1),
                _PreferenceOptionTile<AppLocale>(
                  title: context.strings.t(AppStringKey.english),
                  value: AppLocale.en,
                  groupValue: preferences.locale,
                  onSelected: (AppLocale value) {
                    _setLocale(context, ref, value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: context.strings.t(AppStringKey.appearance),
            child: Column(
              children: <Widget>[
                _PreferenceOptionTile<AppThemePreference>(
                  title: context.strings.t(AppStringKey.lightMode),
                  value: AppThemePreference.light,
                  groupValue: preferences.theme,
                  onSelected: (AppThemePreference value) {
                    _setTheme(context, ref, value);
                  },
                ),
                const Divider(height: 1),
                _PreferenceOptionTile<AppThemePreference>(
                  title: context.strings.t(AppStringKey.darkMode),
                  value: AppThemePreference.dark,
                  groupValue: preferences.theme,
                  onSelected: (AppThemePreference value) {
                    _setTheme(context, ref, value);
                  },
                ),
                const Divider(height: 1),
                _PreferenceOptionTile<AppThemePreference>(
                  title: context.strings.t(AppStringKey.systemMode),
                  value: AppThemePreference.system,
                  groupValue: preferences.theme,
                  onSelected: (AppThemePreference value) {
                    _setTheme(context, ref, value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: context.strings.t(AppStringKey.savedLocally),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.strings.t(AppStringKey.appName),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.strings.t(AppStringKey.localPreferencesDescription),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _PreferenceOptionTile<T> extends StatelessWidget {
  const _PreferenceOptionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isSelected = value == groupValue;

    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
