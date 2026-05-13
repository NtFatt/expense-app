import 'dart:io';

import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:expense_app/features/transactions/data/shared_preferences_transaction_repository.dart';
import 'package:expense_app/features/transactions/data/transaction_repository.dart';

TransactionRepository createDefaultTransactionRepository() {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    return InMemoryTransactionRepository();
  }
  return SharedPreferencesTransactionRepository();
}
