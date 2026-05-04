/// Pure-Dart file name generators for export files.
///
/// All functions are deterministic and side-effect free, making them
/// straightforward to unit-test without mocking the filesystem.
class ReportFileNamer {
  ReportFileNamer._();

  /// Pads a number to two digits with a leading zero.
  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// Returns the file name for a CSV export of all transactions.
  ///
  /// Format: `expense_transactions_YYYYMMDD_HHmm.csv`
  /// Example: `expense_transactions_20260504_2210.csv`
  static String transactionsCsvName(DateTime generatedAt) {
    final String year = generatedAt.year.toString();
    final String month = _twoDigits(generatedAt.month);
    final String day = _twoDigits(generatedAt.day);
    final String hour = _twoDigits(generatedAt.hour);
    final String minute = _twoDigits(generatedAt.minute);
    final String datePart = year + month + day;
    final String timePart = hour + minute;
    return 'expense_transactions_${datePart}_$timePart.csv';
  }

  /// Returns the file name for a monthly PDF report.
  ///
  /// Format: `expense_monthly_report_YYYY_MM.pdf`
  /// Example: `expense_monthly_report_2026_05.pdf`
  static String monthlyPdfName(DateTime selectedMonth) {
    final String year = selectedMonth.year.toString();
    final String month = _twoDigits(selectedMonth.month);
    return 'expense_monthly_report_${year}_$month.pdf';
  }
}
