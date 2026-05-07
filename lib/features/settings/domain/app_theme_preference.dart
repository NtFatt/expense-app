import 'package:flutter/material.dart';

enum AppThemePreference {
  light('light'),
  dark('dark'),
  system('system');

  const AppThemePreference(this.storageValue);

  final String storageValue;

  ThemeMode toThemeMode() {
    return switch (this) {
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
      AppThemePreference.system => ThemeMode.system,
    };
  }

  static AppThemePreference fromStorageValue(String? value) {
    return AppThemePreference.values.firstWhere(
      (AppThemePreference theme) => theme.storageValue == value,
      orElse: () => AppThemePreference.system,
    );
  }
}
