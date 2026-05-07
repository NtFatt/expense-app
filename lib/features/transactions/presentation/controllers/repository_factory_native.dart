import 'dart:io';

import 'package:expense_app/core/database/app_database_provider.dart';
import 'package:expense_app/features/transactions/data/drift_transaction_repository.dart';
import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:expense_app/features/transactions/data/transaction_repository.dart';
import 'package:flutter/foundation.dart';

TransactionRepository createDefaultTransactionRepository() {
  if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
    return InMemoryTransactionRepository();
  }
  return DriftTransactionRepository(getSharedAppDatabase());
}
