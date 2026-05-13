import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_result.dart';
import 'package:expense_app/features/reports/presentation/report_export_feedback.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildReportExportFeedback', () {
    const AppStrings strings = AppStrings(AppLocale.vi);

    test('returns saved location for successful CSV export', () {
      const ReportExportResult result = ReportExportResult(
        format: ReportExportFormat.csv,
        fileName: 'expense_transactions_20260508_0900.csv',
        status: ReportExportStatus.saved,
        message: 'CSV export saved.',
        filePath: 'C:/reports/expense_transactions_20260508_0900.csv',
      );

      expect(
        buildReportExportFeedback(strings, result),
        'Đã xuất CSV: C:/reports/expense_transactions_20260508_0900.csv',
      );
    });

    test('returns cancelled message for PDF export', () {
      const ReportExportResult result = ReportExportResult(
        format: ReportExportFormat.pdf,
        fileName: 'expense_monthly_report_2026_05.pdf',
        status: ReportExportStatus.cancelled,
        message: 'PDF export cancelled.',
      );

      expect(
        buildReportExportFeedback(strings, result),
        strings.t(AppStringKey.pdfExportCancelled),
      );
    });

    test('appends failure details when export fails', () {
      const ReportExportResult result = ReportExportResult(
        format: ReportExportFormat.pdf,
        fileName: 'expense_monthly_report_2026_05.pdf',
        status: ReportExportStatus.failed,
        message: 'PDF generation failed: missing font asset',
      );

      expect(
        buildReportExportFeedback(strings, result),
        contains('PDF generation failed: missing font asset'),
      );
      expect(
        buildReportExportFeedback(strings, result),
        startsWith(strings.t(AppStringKey.couldNotExportPdf)),
      );
    });
  });
}
