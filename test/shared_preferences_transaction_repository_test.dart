import 'dart:convert';

import 'package:expense_app/features/transactions/data/shared_preferences_transaction_repository.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _transactionsStorageKey = 'expense_app.web.transactions.v1';
const String _transactionsCorruptStorageKey =
    'expense_app.web.transactions.corrupt.v1';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('SharedPreferencesTransactionRepository', () {
    test('returns seeded transactions when storage is empty', () async {
      final SharedPreferencesTransactionRepository repository =
          SharedPreferencesTransactionRepository();

      final List<TransactionModel> transactions = await repository
          .getTransactions();

      expect(transactions, isNotEmpty);
      expect(
        transactions.any((TransactionModel item) => item.category == 'Ăn uống'),
        isTrue,
      );
    });

    test('persists add/update/delete across repository recreation', () async {
      final SharedPreferencesTransactionRepository repository =
          SharedPreferencesTransactionRepository();
      final TransactionModel created = _buildTransaction(
        id: 'web_tx_1',
        amount: 88000,
        note: 'Bữa trưa văn phòng',
      );

      await repository.addTransaction(created);

      final SharedPreferences preferencesAfterAdd =
          await SharedPreferences.getInstance();
      final Map<String, Object?> storedSnapshot = Map<String, Object?>.from(
        jsonDecode(preferencesAfterAdd.getString(_transactionsStorageKey)!)
            as Map,
      );
      expect(storedSnapshot['schemaVersion'], 1);

      final SharedPreferencesTransactionRepository reopenedAfterAdd =
          SharedPreferencesTransactionRepository();
      final List<TransactionModel> afterAdd = await reopenedAfterAdd
          .getTransactions();
      expect(
        afterAdd.any((TransactionModel item) => item.id == created.id),
        isTrue,
      );
      expect(
        afterAdd
            .singleWhere((TransactionModel item) => item.id == created.id)
            .note,
        'Bữa trưa văn phòng',
      );

      final TransactionModel updated = created.copyWith(
        amount: 99000,
        note: 'Bữa trưa cập nhật',
        updatedAt: DateTime(2026, 5, 8, 10, 30),
      );
      await reopenedAfterAdd.updateTransaction(updated);

      final SharedPreferencesTransactionRepository reopenedAfterUpdate =
          SharedPreferencesTransactionRepository();
      final TransactionModel persistedUpdated =
          (await reopenedAfterUpdate.getTransactions()).firstWhere(
            (TransactionModel item) => item.id == created.id,
          );
      expect(persistedUpdated.amount, 99000);
      expect(persistedUpdated.note, 'Bữa trưa cập nhật');
      expect(
        (await reopenedAfterUpdate.getTransactions()).where(
          (TransactionModel item) => item.id == created.id,
        ),
        hasLength(1),
      );

      await reopenedAfterUpdate.deleteTransaction(created.id);

      final SharedPreferencesTransactionRepository reopenedAfterDelete =
          SharedPreferencesTransactionRepository();
      final List<TransactionModel> afterDelete = await reopenedAfterDelete
          .getTransactions();
      expect(
        afterDelete.any((TransactionModel item) => item.id == created.id),
        isFalse,
      );
    });

    test('clearAll persists an empty state', () async {
      final SharedPreferencesTransactionRepository repository =
          SharedPreferencesTransactionRepository();

      await repository.clearAll();

      final SharedPreferencesTransactionRepository reopened =
          SharedPreferencesTransactionRepository();
      expect(await reopened.getTransactions(), isEmpty);
    });

    test('recovers gracefully from corrupt json storage', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        _transactionsStorageKey: '{bad json',
      });

      final SharedPreferencesTransactionRepository repository =
          SharedPreferencesTransactionRepository();

      final List<TransactionModel> recovered = await repository
          .getTransactions();

      expect(recovered, isNotEmpty);
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final Map<String, Object?> repairedPayload = Map<String, Object?>.from(
        jsonDecode(preferences.getString(_transactionsStorageKey)!) as Map,
      );
      expect(repairedPayload['schemaVersion'], 1);
      expect(repairedPayload['transactions'], isA<List<Object?>>());
      expect(
        preferences.getString(_transactionsCorruptStorageKey),
        '{bad json',
      );
    });
  });
}

TransactionModel _buildTransaction({
  required String id,
  required int amount,
  required String note,
}) {
  final DateTime now = DateTime(2026, 5, 8, 9, 0);
  return TransactionModel(
    id: id,
    type: TransactionType.expense,
    amount: amount,
    category: 'Ăn uống',
    note: note,
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );
}
