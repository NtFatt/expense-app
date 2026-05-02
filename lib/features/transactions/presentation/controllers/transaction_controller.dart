import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:expense_app/features/transactions/data/transaction_repository.dart';
import 'package:expense_app/features/transactions/domain/monthly_transaction_summary.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:expense_app/features/transactions/domain/monthly_transaction_summary.dart'
    show CategoryExpenseSummary;

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (Ref ref) => _createDefaultTransactionRepository(),
);

final transactionControllerProvider =
    AsyncNotifierProvider<TransactionController, TransactionState>(
      TransactionController.new,
    );

class TransactionController extends AsyncNotifier<TransactionState> {
  @override
  Future<TransactionState> build() async {
    return _loadTransactions();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    state = const AsyncLoading<TransactionState>();
    state = await AsyncValue.guard(() async {
      final TransactionRepository repository = ref.read(
        transactionRepositoryProvider,
      );
      await repository.addTransaction(transaction);
      return _loadTransactions();
    });
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    state = const AsyncLoading<TransactionState>();
    state = await AsyncValue.guard(() async {
      final TransactionRepository repository = ref.read(
        transactionRepositoryProvider,
      );
      await repository.updateTransaction(transaction);
      return _loadTransactions();
    });
  }

  Future<void> deleteTransaction(String id) async {
    state = const AsyncLoading<TransactionState>();
    state = await AsyncValue.guard(() async {
      final TransactionRepository repository = ref.read(
        transactionRepositoryProvider,
      );
      await repository.deleteTransaction(id);
      return _loadTransactions();
    });
  }

  Future<void> clearAll() async {
    state = const AsyncLoading<TransactionState>();
    state = await AsyncValue.guard(() async {
      final TransactionRepository repository = ref.read(
        transactionRepositoryProvider,
      );
      await repository.clearAll();
      return _loadTransactions();
    });
  }

  Future<TransactionState> _loadTransactions() async {
    final TransactionRepository repository = ref.read(
      transactionRepositoryProvider,
    );
    final List<TransactionModel> transactions = await repository
        .getTransactions();
    return TransactionState.fromTransactions(transactions);
  }
}

TransactionRepository _createDefaultTransactionRepository() {
  // TODO: Switch to DriftTransactionRepository on native targets after
  // Android/Windows persistence QA. Keep InMemoryTransactionRepository for
  // web demo to avoid native sqlite issues.
  if (kIsWeb) {
    return InMemoryTransactionRepository();
  }

  return InMemoryTransactionRepository();
}

class TransactionState {
  const TransactionState({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  factory TransactionState.fromTransactions(
    List<TransactionModel> transactions,
  ) {
    final List<TransactionModel> copiedTransactions =
        List<TransactionModel>.unmodifiable(transactions);
    final int totalIncome = copiedTransactions
        .where((TransactionModel transaction) => transaction.isIncome)
        .fold<int>(
          0,
          (int total, TransactionModel transaction) =>
              total + transaction.amount,
        );
    final int totalExpense = copiedTransactions
        .where((TransactionModel transaction) => transaction.isExpense)
        .fold<int>(
          0,
          (int total, TransactionModel transaction) =>
              total + transaction.amount,
        );

    return TransactionState(
      transactions: copiedTransactions,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: totalIncome - totalExpense,
    );
  }

  final List<TransactionModel> transactions;
  final int totalIncome;
  final int totalExpense;
  final int balance;

  bool get isEmpty => transactions.isEmpty;

  int get totalTransactions => transactions.length;

  TransactionModel? transactionById(String id) {
    for (final TransactionModel transaction in transactions) {
      if (transaction.id == id) {
        return transaction;
      }
    }

    return null;
  }

  List<CategoryExpenseSummary> get expenseCategorySummaries {
    final Map<String, int> totalsByCategory = <String, int>{};
    for (final TransactionModel transaction in transactions) {
      if (!transaction.isExpense) {
        continue;
      }

      totalsByCategory.update(
        transaction.category,
        (int value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final List<CategoryExpenseSummary> summaries = totalsByCategory.entries
        .map(
          (MapEntry<String, int> entry) =>
              CategoryExpenseSummary(category: entry.key, amount: entry.value),
        )
        .toList();

    summaries.sort(
      (CategoryExpenseSummary left, CategoryExpenseSummary right) =>
          right.amount.compareTo(left.amount),
    );
    return summaries;
  }

  CategoryExpenseSummary? get topExpenseCategory {
    if (expenseCategorySummaries.isEmpty) {
      return null;
    }

    return expenseCategorySummaries.first;
  }

  List<TransactionModel> get sortedTransactions {
    final List<TransactionModel> items = List<TransactionModel>.of(
      transactions,
    );
    items.sort((TransactionModel left, TransactionModel right) {
      final int byDate = right.transactionDate.compareTo(left.transactionDate);
      if (byDate != 0) {
        return byDate;
      }

      return right.createdAt.compareTo(left.createdAt);
    });
    return items;
  }

  List<TransactionModel> recentTransactions({int limit = 5}) {
    return sortedTransactions.take(limit).toList();
  }
}
