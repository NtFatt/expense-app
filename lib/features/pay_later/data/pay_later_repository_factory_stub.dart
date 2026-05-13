import 'dart:io';

import 'package:expense_app/features/pay_later/data/in_memory_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/data/pay_later_repository.dart';
import 'package:expense_app/features/pay_later/data/shared_preferences_pay_later_repository.dart';

PayLaterRepository createDefaultPayLaterRepository() {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    return InMemoryPayLaterRepository();
  }
  return SharedPreferencesPayLaterRepository();
}
