import 'package:expense_app/core/localization/app_strings.dart';
import 'package:flutter/widgets.dart';

extension AppStringsContextX on BuildContext {
  AppStrings get strings => AppStrings.of(this);
}
