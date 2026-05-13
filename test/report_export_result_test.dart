import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportExportResult', () {
    test('saved result is treated as success', () {
      const ReportExportResult result = ReportExportResult(
        format: ReportExportFormat.csv,
        fileName: 'report.csv',
        status: ReportExportStatus.saved,
        message: 'CSV export saved.',
        filePath: 'C:/reports/report.csv',
      );

      expect(result.isSuccess, true);
      expect(result.isCancelled, false);
      expect(result.isUnsupported, false);
      expect(result.isFailure, false);
    });

    test('failed result is treated as failure', () {
      const ReportExportResult result = ReportExportResult(
        format: ReportExportFormat.pdf,
        fileName: 'report.pdf',
        status: ReportExportStatus.failed,
        message: 'PDF generation failed.',
      );

      expect(result.isSuccess, false);
      expect(result.isFailure, true);
    });
  });
}
