import 'package:drift/drift.dart';
import 'package:expense_app/core/database/app_database.dart' as database;
import 'package:expense_app/features/transactions/data/transaction_repository.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';

class DriftTransactionRepository implements TransactionRepository {
  DriftTransactionRepository(this._database);

  final database.AppDatabase _database;

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final List<database.Transaction> rows = await _database.getTransactions();
    return rows.map(_mapRowToModel).toList();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _database.insertTransaction(_mapModelToCompanion(transaction));
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final int updatedRows = await _database.updateTransaction(
      _mapModelToCompanion(transaction),
    );

    if (updatedRows == 0) {
      throw StateError('Transaction not found: ${transaction.id}');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _database.deleteTransactionById(id);
  }

  @override
  Future<void> clearAll() async {
    await _database.clearTransactions();
  }

  @override
  Future<void> replaceAll(List<TransactionModel> transactions) async {
    await _database.transaction(() async {
      await _database.clearTransactions();
      for (final TransactionModel transaction in transactions) {
        await _database.insertTransaction(_mapModelToCompanion(transaction));
      }
    });
  }

  TransactionModel _mapRowToModel(database.Transaction row) {
    return TransactionModel(
      id: row.id,
      type: TransactionType.fromName(row.type),
      amount: row.amount,
      category: row.category,
      note: row.note,
      transactionDate: row.transactionDate,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  database.TransactionsCompanion _mapModelToCompanion(
    TransactionModel transaction,
  ) {
    return database.TransactionsCompanion.insert(
      id: transaction.id,
      type: transaction.type.name,
      amount: transaction.amount,
      category: transaction.category,
      note: Value<String?>(transaction.note),
      transactionDate: transaction.transactionDate,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }
}
