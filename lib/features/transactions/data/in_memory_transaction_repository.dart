import 'package:expense_app/features/transactions/data/transaction_repository.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';

class InMemoryTransactionRepository implements TransactionRepository {
  InMemoryTransactionRepository()
    : _transactions = <TransactionModel>[..._seedTransactions()];

  final List<TransactionModel> _transactions;

  @override
  Future<List<TransactionModel>> getTransactions() async {
    return List<TransactionModel>.unmodifiable(_transactions);
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    _transactions.add(transaction);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final int transactionIndex = _transactions.indexWhere(
      (TransactionModel item) => item.id == transaction.id,
    );

    if (transactionIndex == -1) {
      throw StateError('Transaction not found: ${transaction.id}');
    }

    _transactions[transactionIndex] = transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere(
      (TransactionModel transaction) => transaction.id == id,
    );
  }

  @override
  Future<void> clearAll() async {
    _transactions.clear();
  }

  static List<TransactionModel> _seedTransactions() {
    final DateTime now = DateTime.now();
    return <TransactionModel>[
      TransactionModel(
        id: 'seed_income_salary',
        type: TransactionType.income,
        amount: 1500000,
        category: 'Lương',
        note: 'Lương part-time',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        id: 'seed_expense_breakfast',
        type: TransactionType.expense,
        amount: 35000,
        category: 'Ăn uống',
        note: 'Ăn sáng',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        id: 'seed_expense_coffee',
        type: TransactionType.expense,
        amount: 45000,
        category: 'Giải trí',
        note: 'Cà phê',
        transactionDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
