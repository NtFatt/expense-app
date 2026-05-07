import 'package:expense_app/core/constants/app_constants.dart';
import 'package:intl/intl.dart';

final NumberFormat _currencyNumberFormat = NumberFormat.decimalPattern('vi_VN');

String formatCurrency(num amount, {bool withSign = true}) {
  final String prefix;
  if (!withSign) {
    prefix = '';
  } else if (amount > 0) {
    prefix = '+';
  } else if (amount < 0) {
    prefix = '-';
  } else {
    prefix = '';
  }

  return '$prefix${_currencyNumberFormat.format(amount.abs())}${AppConstants.currencySymbol}';
}
