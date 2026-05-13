import 'dart:convert';

import 'package:expense_app/features/reports/data/csv_transaction_exporter.dart';
import 'package:expense_app/features/reports/data/monthly_report_data_builder.dart';
import 'package:expense_app/features/reports/data/pdf_monthly_report_exporter.dart';
import 'package:expense_app/features/reports/data/report_file_namer.dart';
import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_request.dart';
import 'package:expense_app/features/reports/domain/report_export_result.dart';

import 'report_export_service.dart';

/// Concrete implementation of [ReportExportService] for native platforms.
///
/// The CSV/PDF legs delegate file delivery to a platform-aware writer:
/// desktop opens Save As, Android saves into app documents, and web downloads
/// in-browser. This class lives in the [data] layer and has no `BuildContext`
/// or Flutter UI dependencies.
class LocalReportExportService implements ReportExportService {
  const LocalReportExportService({
    required CsvTransactionExporter csvExporter,
    required ReportFileWriter fileWriter,
    required MonthlyReportDataBuilder monthlyReportDataBuilder,
    required MonthlyPdfExporter pdfExporter,
  }) : _csvExporter = csvExporter,
       _fileWriter = fileWriter,
       _monthlyReportDataBuilder = monthlyReportDataBuilder,
       _pdfExporter = pdfExporter;

  final CsvTransactionExporter _csvExporter;
  final ReportFileWriter _fileWriter;
  final MonthlyReportDataBuilder _monthlyReportDataBuilder;
  final MonthlyPdfExporter _pdfExporter;

  @override
  Future<ReportExportResult> exportTransactionsCsv(
    ReportExportRequest request,
  ) async {
    final String fileName = ReportFileNamer.transactionsCsvName(
      request.generatedAt,
    );
    final String csv = _csvExporter.generate(request.transactions);
    final List<int> bytes = utf8.encode(csv);
    final writeResult = await _writeFile(fileName: fileName, bytes: bytes);

    if (writeResult == null) {
      return ReportExportResult(
        format: ReportExportFormat.csv,
        fileName: fileName,
        status: ReportExportStatus.failed,
        filePath: null,
        message: 'Could not write CSV bytes to the selected destination.',
      );
    }

    switch (writeResult.status) {
      case ReportFileWriteStatus.saved:
        return ReportExportResult(
          format: ReportExportFormat.csv,
          fileName: fileName,
          status: ReportExportStatus.saved,
          filePath: writeResult.filePath,
          message: 'CSV export saved.',
        );
      case ReportFileWriteStatus.cancelled:
        return ReportExportResult(
          format: ReportExportFormat.csv,
          fileName: fileName,
          status: ReportExportStatus.cancelled,
          filePath: null,
          message: 'CSV export cancelled.',
        );
      case ReportFileWriteStatus.unsupported:
        return ReportExportResult(
          format: ReportExportFormat.csv,
          fileName: fileName,
          status: ReportExportStatus.unsupported,
          filePath: null,
          message: 'CSV export is not supported on this platform.',
        );
    }
  }

  @override
  Future<ReportExportResult> exportMonthlyPdf(
    ReportExportRequest request,
  ) async {
    final String fileName = ReportFileNamer.monthlyPdfName(
      request.selectedMonth,
    );

    final monthlyData = _monthlyReportDataBuilder.build(
      transactions: request.transactions,
      selectedMonth: request.selectedMonth,
      generatedAt: request.generatedAt,
    );

    List<int> pdfBytes;
    try {
      pdfBytes = await _pdfExporter.generate(monthlyData);
    } catch (e) {
      return ReportExportResult(
        format: ReportExportFormat.pdf,
        fileName: fileName,
        status: ReportExportStatus.failed,
        filePath: null,
        message: 'PDF generation failed: $e',
      );
    }

    final writeResult = await _writeFile(fileName: fileName, bytes: pdfBytes);

    if (writeResult == null) {
      return ReportExportResult(
        format: ReportExportFormat.pdf,
        fileName: fileName,
        status: ReportExportStatus.failed,
        filePath: null,
        message: 'Could not write PDF bytes to the selected destination.',
      );
    }

    switch (writeResult.status) {
      case ReportFileWriteStatus.saved:
        return ReportExportResult(
          format: ReportExportFormat.pdf,
          fileName: fileName,
          status: ReportExportStatus.saved,
          filePath: writeResult.filePath,
          message: 'PDF export saved.',
        );
      case ReportFileWriteStatus.cancelled:
        return ReportExportResult(
          format: ReportExportFormat.pdf,
          fileName: fileName,
          status: ReportExportStatus.cancelled,
          filePath: null,
          message: 'PDF export cancelled.',
        );
      case ReportFileWriteStatus.unsupported:
        return ReportExportResult(
          format: ReportExportFormat.pdf,
          fileName: fileName,
          status: ReportExportStatus.unsupported,
          filePath: null,
          message: 'PDF export is not supported on this platform.',
        );
    }
  }

  Future<ReportFileWriteResult?> _writeFile({
    required String fileName,
    required List<int> bytes,
  }) async {
    try {
      return await _fileWriter.writeBytes(fileName: fileName, bytes: bytes);
    } catch (_) {
      return null;
    }
  }
}
