import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'tables/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: <Type>[Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Transaction>> getTransactions() {
    return (select(transactions)..orderBy(<OrderingTerm Function(Transactions)>[
          (Transactions table) => OrderingTerm.desc(table.transactionDate),
          (Transactions table) => OrderingTerm.desc(table.createdAt),
        ]))
        .get();
  }

  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  Future<int> updateTransaction(TransactionsCompanion transaction) {
    return (update(
          transactions,
        )..where((Transactions table) => table.id.equals(transaction.id.value)))
        .write(transaction);
  }

  Future<int> deleteTransactionById(String id) {
    return (delete(
      transactions,
    )..where((Transactions table) => table.id.equals(id))).go();
  }

  Future<int> clearTransactions() {
    return delete(transactions).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Enable Drift repository after Android/Windows target is selected.',
      );
    }

    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File(path.join(directory.path, 'expense_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
