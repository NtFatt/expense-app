import 'package:expense_app/features/transactions/domain/monthly_transaction_summary.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';

/// Immutable intermediate data model for generating a monthly PDF report.
///
/// Bundles the raw monthly transactions and their pre-computed summary so the
/// PDF generator has everything it needs without needing a controller or provider.
class MonthlyReportData {
  const MonthlyReportData({
    required this.selectedMonth,
    required this.generatedAt,
    required this.transactions,
    required this.summary,
  });

  final DateTime selectedMonth;
  final DateTime generatedAt;
  final List<TransactionModel> transactions;
  final MonthlyTransactionSummary summary;

  bool get hasTransactions => transactions.isNotEmpty;
  bool get hasExpenses => summary.totalExpense > 0;
  int get transactionCount => transactions.length;
}
