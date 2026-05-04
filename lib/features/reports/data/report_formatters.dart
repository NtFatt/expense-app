/// Vietnamese month names used in PDF reports.
const List<String> _vietnameseMonths = [
  'Tháng 1',
  'Tháng 2',
  'Tháng 3',
  'Tháng 4',
  'Tháng 5',
  'Tháng 6',
  'Tháng 7',
  'Tháng 8',
  'Tháng 9',
  'Tháng 10',
  'Tháng 11',
  'Tháng 12',
];

/// Pure-Dart formatting utilities for PDF report generation.
///
/// These functions have no Flutter UI or BuildContext dependencies.
class ReportFormatters {
  ReportFormatters._();

  /// Formats a DateTime as `dd/MM/yyyy`, e.g. `05/01/2026`.
  static String shortDate(DateTime date) {
    final String d = date.day.toString().padLeft(2, '0');
    final String m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  /// Formats a DateTime as `dd/MM/yyyy HH:mm`, e.g. `05/01/2026 14:30`.
  static String dateTime(DateTime date) {
    final String d = date.day.toString().padLeft(2, '0');
    final String mo = date.month.toString().padLeft(2, '0');
    final String h = date.hour.toString().padLeft(2, '0');
    final String mi = date.minute.toString().padLeft(2, '0');
    return '$d/$mo/${date.year} $h:$mi';
  }

  /// Formats a month as `Tháng MM/yyyy`, e.g. `Tháng 05/2026`.
  static String monthLabel(DateTime month) {
    return '${_vietnameseMonths[month.month - 1]}/${month.year}';
  }

  /// Formats an amount in Vietnamese currency style: `1.000.000 ₫`.
  /// The [amount] is expected to be positive; use [signedAmount] for signed values.
  static String currency(int amount) {
    final String absStr = amount.abs().toString();
    final StringBuffer result = StringBuffer();
    final int len = absStr.length;

    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) {
        result.write('.');
      }
      result.write(absStr[i]);
    }

    return '$result ₫';
  }

  /// Formats a percentage as a string like `25,5%`.
  static String percentage(double fraction) {
    return '${(fraction * 100).toStringAsFixed(1)}%';
  }
}
