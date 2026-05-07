import 'package:flutter/widgets.dart';

enum AppLocale {
  vi('vi'),
  en('en');

  const AppLocale(this.languageCode);

  final String languageCode;

  static const List<Locale> supportedLocales = <Locale>[
    Locale('vi'),
    Locale('en'),
  ];

  Locale toLocale() => Locale(languageCode);

  static AppLocale fromCode(String? code) {
    return AppLocale.values.firstWhere(
      (AppLocale locale) => locale.languageCode == code,
      orElse: () => AppLocale.vi,
    );
  }

  static AppLocale fromLocale(Locale? locale) {
    return fromCode(locale?.languageCode);
  }
}
