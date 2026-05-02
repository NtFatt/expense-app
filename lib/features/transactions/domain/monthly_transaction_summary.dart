import 'package:expense_app/features/transactions/domain/transaction_model.dart';

/// Aggregates transaction data for a specific month (month-only, no type/search filter).
/// Used by Dashboard and Statistics pages to display monthly summaries.
class MonthlyTransactionSummary {
  const MonthlyTransactionSummary({required this.transactions});

  final List<TransactionModel> transactions;

  int get totalIncome => transactions
      .where((TransactionModel t) => t.isIncome)
      .fold<int>(0, (int sum, TransactionModel t) => sum + t.amount);

  int get totalExpense => transactions
      .where((TransactionModel t) => t.isExpense)
      .fold<int>(0, (int sum, TransactionModel t) => sum + t.amount);

  int get balance => totalIncome - totalExpense;

  int get totalTransactions => transactions.length;

  List<TransactionModel> recentTransactions({int limit = 5}) {
    return transactions.take(limit).toList();
  }

  Map<String, int> get expenseByCategory {
    final result = <String, int>{};
    for (final transaction in transactions) {
      if (!transaction.isExpense) continue;
      result.update(
        transaction.category,
        (int value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    return result;
  }

  /// Returns category summaries sorted by amount descending.
  List<CategoryExpenseSummary> get expenseCategorySummaries {
    final entries = expenseByCategory.entries.toList()
      ..sort((MapEntry<String, int> a, MapEntry<String, int> b) =>
          b.value.compareTo(a.value));
    return entries
        .map((MapEntry<String, int> e) =>
            CategoryExpenseSummary(category: e.key, amount: e.value))
        .toList();
  }

  /// Returns the highest-spending category or null if no expenses exist.
  CategoryExpenseSummary? get topExpenseCategory {
    final summaries = expenseCategorySummaries;
    if (summaries.isEmpty) return null;
    return summaries.first;
  }
}

/// A named pair of category name and total expense amount.
class CategoryExpenseSummary {
  const CategoryExpenseSummary({
    required this.category,
    required this.amount,
  });

  final String category;
  final int amount;

  double percentageOf(int totalExpense) {
    if (totalExpense == 0) return 0;
    return amount / totalExpense;
  }
}
