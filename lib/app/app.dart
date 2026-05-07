import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/app_locale.dart';
import '../core/localization/app_string_key.dart';
import '../core/localization/app_strings.dart';
import '../features/settings/presentation/controllers/app_preferences_controller.dart';
import 'router.dart';
import 'theme.dart';

class ExpenseApp extends ConsumerWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(resolvedAppPreferencesProvider);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) {
        return AppStrings.of(context).t(AppStringKey.appName);
      },
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: preferences.theme.toThemeMode(),
      locale: preferences.locale.toLocale(),
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}
