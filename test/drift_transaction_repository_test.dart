import 'dart:io';

import 'package:drift/native.dart';
import 'package:expense_app/core/database/app_database.dart' as database;
import 'package:expense_app/features/transactions/data/drift_transaction_repository.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('DriftTransactionRepository', () {
    test('persists transactions across database reopen', () async {
      final Directory tempDirectory = await Directory.systemTemp.createTemp(
        'expense_app_transactions_',
      );
      final File databaseFile = File(
        path.join(tempDirectory.path, 'expense_app.sqlite'),
      );
      database.AppDatabase? appDatabase;

      try {
        appDatabase = database.AppDatabase(
          executor: NativeDatabase(databaseFile),
        );
        DriftTransactionRepository repository = DriftTransactionRepository(
          appDatabase,
        );

        final TransactionModel breakfast = _buildTransaction(
          id: 'tx_breakfast',
          type: TransactionType.expense,
          amount: 35000,
          category: 'Ăn uống',
          note: 'Ăn sáng',
          transactionDate: DateTime(2026, 5, 7),
          createdAt: DateTime(2026, 5, 7, 8, 0),
        );
        final TransactionModel salary = _buildTransaction(
          id: 'tx_salary',
          type: TransactionType.income,
          amount: 1500000,
          category: 'Lương',
          note: 'Lương part-time',
          transactionDate: DateTime(2026, 5, 8),
          createdAt: DateTime(2026, 5, 8, 9, 0),
        );

        await repository.addTransaction(breakfast);
        await repository.addTransaction(salary);

        await appDatabase.close();
        appDatabase = null;

        appDatabase = database.AppDatabase(
          executor: NativeDatabase(databaseFile),
        );
        repository = DriftTransactionRepository(appDatabase);

        final List<TransactionModel> transactions = await repository
            .getTransactions();

        expect(transactions, hasLength(2));
        expect(transactions.first.id, 'tx_salary');
        expect(transactions.last.id, 'tx_breakfast');
        expect(transactions.first.note, 'Lương part-time');
      } finally {
        await appDatabase?.close();
        await tempDirectory.delete(recursive: true);
      }
    });

    test('updateTransaction persists updated fields', () async {
      final database.AppDatabase appDatabase = database.AppDatabase(
        executor: NativeDatabase.memory(),
      );
      final DriftTransactionRepository repository = DriftTransactionRepository(
        appDatabase,
      );

      try {
        final TransactionModel transaction = _buildTransaction(
          id: 'tx_1',
          type: TransactionType.expense,
          amount: 20000,
          category: 'Di chuyển',
          note: 'Xe ôm',
          transactionDate: DateTime(2026, 5, 6),
          createdAt: DateTime(2026, 5, 6, 8, 0),
        );

        await repository.addTransaction(transaction);
        await repository.updateTransaction(
          transaction.copyWith(
            amount: 45000,
            category: 'Giải trí',
            note: 'Cafe và xem phim',
            updatedAt: DateTime(2026, 5, 6, 9, 30),
          ),
        );

        final List<TransactionModel> transactions = await repository
            .getTransactions();
        expect(transactions.single.amount, 45000);
        expect(transactions.single.category, 'Giải trí');
        expect(transactions.single.note, 'Cafe và xem phim');
      } finally {
        await appDatabase.close();
      }
    });

    test('deleteTransaction removes the matching row only', () async {
      final database.AppDatabase appDatabase = database.AppDatabase(
        executor: NativeDatabase.memory(),
      );
      final DriftTransactionRepository repository = DriftTransactionRepository(
        appDatabase,
      );

      try {
        await repository.addTransaction(
          _buildTransaction(
            id: 'tx_keep',
            type: TransactionType.income,
            amount: 100000,
            category: 'Thưởng',
            transactionDate: DateTime(2026, 5, 9),
            createdAt: DateTime(2026, 5, 9, 8, 0),
          ),
        );
        await repository.addTransaction(
          _buildTransaction(
            id: 'tx_delete',
            type: TransactionType.expense,
            amount: 20000,
            category: 'Ăn uống',
            transactionDate: DateTime(2026, 5, 8),
            createdAt: DateTime(2026, 5, 8, 8, 0),
          ),
        );

        await repository.deleteTransaction('tx_delete');
        final List<TransactionModel> transactions = await repository
            .getTransactions();

        expect(transactions, hasLength(1));
        expect(transactions.single.id, 'tx_keep');
      } finally {
        await appDatabase.close();
      }
    });

    test('updateTransaction throws when row does not exist', () async {
      final database.AppDatabase appDatabase = database.AppDatabase(
        executor: NativeDatabase.memory(),
      );
      final DriftTransactionRepository repository = DriftTransactionRepository(
        appDatabase,
      );

      try {
        await expectLater(
          repository.updateTransaction(
            _buildTransaction(
              id: 'missing',
              type: TransactionType.expense,
              amount: 1000,
              category: 'Khác',
              transactionDate: DateTime(2026, 5, 1),
              createdAt: DateTime(2026, 5, 1, 8, 0),
            ),
          ),
          throwsA(isA<StateError>()),
        );
      } finally {
        await appDatabase.close();
      }
    });
  });
}

TransactionModel _buildTransaction({
  required String id,
  required TransactionType type,
  required int amount,
  required String category,
  String? note,
  required DateTime transactionDate,
  required DateTime createdAt,
}) {
  return TransactionModel(
    id: id,
    type: type,
    amount: amount,
    category: category,
    note: note,
    transactionDate: transactionDate,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}
