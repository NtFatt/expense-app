import 'package:expense_app/features/reports/data/report_file_namer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportFileNamer', () {
    test('CSV filename format is correct', () {
      final dt = DateTime(2026, 5, 4, 22, 10);
      final result = ReportFileNamer.transactionsCsvName(dt);
      expect(result, 'expense_transactions_20260504_2210.csv');
    });

    test('PDF filename format is correct', () {
      final dt = DateTime(2026, 5, 1);
      final result = ReportFileNamer.monthlyPdfName(dt);
      expect(result, 'expense_monthly_report_2026_05.pdf');
    });

    test('zero-pads month', () {
      final dt = DateTime(2026, 1, 5, 9, 5);
      final csv = ReportFileNamer.transactionsCsvName(dt);
      final pdf = ReportFileNamer.monthlyPdfName(dt);
      // CSV format: _YYYYMMDD_HHmm.csv — month 01 is embedded in the date part
      expect(csv, contains('_20260105_'));
      expect(pdf, contains('_2026_01'));
    });

    test('zero-pads day', () {
      final dt = DateTime(2026, 5, 1, 10, 5);
      final result = ReportFileNamer.transactionsCsvName(dt);
      expect(result, contains('_20260501_'));
    });

    test('zero-pads hour', () {
      final dt = DateTime(2026, 5, 4, 7, 30);
      final result = ReportFileNamer.transactionsCsvName(dt);
      expect(result, contains('_0730'));
    });

    test('zero-pads minute', () {
      final dt = DateTime(2026, 5, 4, 22, 3);
      final result = ReportFileNamer.transactionsCsvName(dt);
      expect(result, contains('_2203'));
    });

    test('CSV filename is deterministic', () {
      final dt = DateTime(2026, 5, 4, 22, 10);
      final result1 = ReportFileNamer.transactionsCsvName(dt);
      final result2 = ReportFileNamer.transactionsCsvName(dt);
      expect(result1, result2);
    });

    test('PDF filename is deterministic', () {
      final dt = DateTime(2026, 5, 1);
      final result1 = ReportFileNamer.monthlyPdfName(dt);
      final result2 = ReportFileNamer.monthlyPdfName(dt);
      expect(result1, result2);
    });

    test('different months produce different CSV filenames', () {
      final jan = DateTime(2026, 1, 1, 12, 0);
      final may = DateTime(2026, 5, 4, 12, 0);
      expect(
        ReportFileNamer.transactionsCsvName(jan),
        isNot(ReportFileNamer.transactionsCsvName(may)),
      );
    });

    test('different months produce different PDF filenames', () {
      final jan = DateTime(2026, 1, 1);
      final dec = DateTime(2026, 12, 1);
      expect(
        ReportFileNamer.monthlyPdfName(jan),
        isNot(ReportFileNamer.monthlyPdfName(dec)),
      );
    });

    test('backup JSON filename format is correct', () {
      final dt = DateTime(2026, 5, 8, 14, 30);
      expect(
        ReportFileNamer.backupJsonName(dt),
        'expense_backup_20260508_1430.json',
      );
    });

    test('Pay Later CSV filename format is correct', () {
      final dt = DateTime(2026, 5, 8, 15, 40);
      expect(
        ReportFileNamer.payLaterCsvName(dt),
        'expense_pay_later_20260508_1540.csv',
      );
    });

    test('Pay Later PDF filename format is correct', () {
      final dt = DateTime(2026, 5, 8, 15, 40);
      expect(
        ReportFileNamer.payLaterPdfName(dt),
        'expense_pay_later_report_20260508_1540.pdf',
      );
    });
  });
}
