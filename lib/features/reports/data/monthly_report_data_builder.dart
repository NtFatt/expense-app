import 'package:expense_app/features/reports/domain/monthly_report_data.dart';
import 'package:expense_app/features/transactions/domain/monthly_transaction_summary.dart';
import 'package:expense_app/features/transactions/domain/transaction_filters.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';

/// Pure-Dart builder that transforms a raw transaction list into
/// [MonthlyReportData] ready for PDF generation.
class MonthlyReportDataBuilder {
  const MonthlyReportDataBuilder();

  /// Builds [MonthlyReportData] for the given [selectedMonth].
  ///
  /// The [transactions] list is filtered to only those within [selectedMonth]
  /// using [filterTransactionsByMonth]. No mutations occur.
  MonthlyReportData build({
    required List<TransactionModel> transactions,
    required DateTime selectedMonth,
    required DateTime generatedAt,
  }) {
    final monthlyTransactions = filterTransactionsByMonth(
      transactions: transactions,
      selectedMonth: selectedMonth,
    );

    return MonthlyReportData(
      selectedMonth: selectedMonth,
      generatedAt: generatedAt,
      transactions: monthlyTransactions,
      summary: MonthlyTransactionSummary(transactions: monthlyTransactions),
    );
  }
}
