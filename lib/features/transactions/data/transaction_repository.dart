import 'package:expense_app/features/transactions/domain/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getTransactions();

  Future<void> addTransaction(TransactionModel transaction);

  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);

  Future<void> clearAll();

  Future<void> replaceAll(List<TransactionModel> transactions);
}
