import 'package:expense_app/features/transactions/domain/transaction_model.dart';

/// Immutable input for an export operation.
///
/// Passed to [ReportExportService] methods. The caller is responsible for
/// populating the [transactions] list appropriately for the export format:
///
/// - **CSV export**: pass the full unfiltered list of all persisted transactions
///   (sourced from `transactionControllerProvider`).
///
/// - **PDF monthly report**: pass transactions filtered to the currently selected
///   month (use `filterTransactionsByMonth` from `transaction_filters.dart`),
///   using `selectedMonth` from `transactionFilterControllerProvider`.
///
/// This model does **not** filter or mutate the transaction list.
final class ReportExportRequest {
  const ReportExportRequest({
    required this.transactions,
    required this.selectedMonth,
    required this.generatedAt,
  });

  /// All transactions to include in the export.
  ///
  /// For CSV: the complete list from the repository.
  /// For PDF: the month-filtered list (filtering done by the caller/UI layer).
  final List<TransactionModel> transactions;

  /// The month the report covers (used for PDF report header and file naming).
  final DateTime selectedMonth;

  /// Wall-clock timestamp when the export request was created.
  final DateTime generatedAt;
}
