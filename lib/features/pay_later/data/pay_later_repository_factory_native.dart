import 'dart:io';

import 'package:expense_app/core/database/app_database_provider.dart';
import 'package:expense_app/features/pay_later/data/drift_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/data/in_memory_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/data/pay_later_repository.dart';
import 'package:flutter/foundation.dart';

PayLaterRepository createDefaultPayLaterRepository() {
  if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
    return InMemoryPayLaterRepository();
  }
  return DriftPayLaterRepository(getSharedAppDatabase());
}
