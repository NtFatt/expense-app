import '../domain/report_export_request.dart';
import '../domain/report_export_result.dart';

/// Abstract interface for exporting transaction reports.
///
/// Implementations in Phase 9B (CSV) and Phase 9C (PDF) provide concrete
/// generators and file-save strategies. This interface lives in the [data]
/// layer and has no Flutter UI or [BuildContext] dependencies.
abstract interface class ReportExportService {
  /// Exports all transactions to a CSV file.
  ///
  /// [request.transactions] should be the complete unfiltered transaction list.
  /// The generated file is saved to the platform-appropriate location
  /// (native filesystem or web download) and the result carries the file path.
  Future<ReportExportResult> exportTransactionsCsv(ReportExportRequest request);

  /// Exports a monthly summary report to a PDF file.
  ///
  /// [request.transactions] should be filtered to [request.selectedMonth]
  /// by the caller before calling this method. The PDF includes the monthly
  /// totals, category breakdown, and top-spending category.
  Future<ReportExportResult> exportMonthlyPdf(ReportExportRequest request);
}
