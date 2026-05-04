import 'package:expense_app/features/transactions/domain/transaction_model.dart';

/// Pure-Dart CSV serializer for transaction data.
///
/// Does not import `dart:io`, Flutter UI, or use `BuildContext`.
/// UTF-8 BOM is prepended so Excel opens Vietnamese text correctly.
class CsvTransactionExporter {
  const CsvTransactionExporter();

  /// Converts [transactions] to a CSV string with UTF-8 BOM.
  ///
  /// The output is sorted newest-first by `transactionDate`, then by
  /// `createdAt` descending. The original list is not mutated.
  ///
  /// Columns: id, date, type, category, amount, signed_amount, note,
  ///          created_at, updated_at
  String generate(List<TransactionModel> transactions) {
    final sorted = List<TransactionModel>.from(transactions)
      ..sort((TransactionModel a, TransactionModel b) {
        final int byDate = b.transactionDate.compareTo(a.transactionDate);
        if (byDate != 0) return byDate;
        return b.createdAt.compareTo(a.createdAt);
      });

    final buffer = StringBuffer();
    buffer.write(_utf8Bom);
    buffer.writeln(_header);

    for (final tx in sorted) {
      buffer.writeln(_row(tx));
    }

    return buffer.toString();
  }

  static const String _utf8Bom = '\uFEFF';
  static const String _header =
      'id,date,type,category,amount,signed_amount,note,created_at,updated_at';

  String _row(TransactionModel tx) {
    return <String>[
      _escapeCsvCell(tx.id),
      _escapeCsvCell(_formatDate(tx.transactionDate)),
      _escapeCsvCell(tx.type.name),
      _escapeCsvCell(tx.category),
      _escapeCsvCell(tx.amount.toString()),
      _escapeCsvCell(tx.signedAmount.toString()),
      _escapeCsvCell(tx.note ?? ''),
      _escapeCsvCell(tx.createdAt.toIso8601String()),
      _escapeCsvCell(tx.updatedAt.toIso8601String()),
    ].join(',');
  }

  String _formatDate(DateTime d) {
    final String y = d.year.toString();
    final String m = d.month.toString().padLeft(2, '0');
    final String day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  /// Escapes a CSV cell: wraps in double quotes if it contains comma,
  /// double quote, newline, or carriage return; doubles any embedded quotes.
  String _escapeCsvCell(String value) {
    final bool needsQuote =
        value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r');

    if (!needsQuote) return value;

    final String escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
