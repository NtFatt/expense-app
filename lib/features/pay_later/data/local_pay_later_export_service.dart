import 'dart:convert';

import 'package:expense_app/features/pay_later/data/pay_later_csv_exporter.dart';
import 'package:expense_app/features/pay_later/data/pay_later_export_service.dart';
import 'package:expense_app/features/pay_later/data/pay_later_pdf_exporter.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_export_request.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_report_data.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary_builder.dart';
import 'package:expense_app/features/reports/data/report_file_namer.dart';
import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_result.dart';

class LocalPayLaterExportService implements PayLaterExportService {
  const LocalPayLaterExportService({
    required PayLaterCsvExporter csvExporter,
    required PayLaterPdfExporter pdfExporter,
    required ReportFileWriter fileWriter,
    required PayLaterSummaryBuilder summaryBuilder,
  }) : _csvExporter = csvExporter,
       _pdfExporter = pdfExporter,
       _fileWriter = fileWriter,
       _summaryBuilder = summaryBuilder;

  final PayLaterCsvExporter _csvExporter;
  final PayLaterPdfExporter _pdfExporter;
  final ReportFileWriter _fileWriter;
  final PayLaterSummaryBuilder _summaryBuilder;

  @override
  Future<ReportExportResult> exportPayLaterCsv(
    PayLaterExportRequest request,
  ) async {
    final String fileName = ReportFileNamer.payLaterCsvName(
      request.generatedAt,
    );
    final PayLaterReportData data = _buildData(request);
    final List<int> bytes = utf8.encode(_csvExporter.generate(data));
    return _writeResult(
      format: ReportExportFormat.csv,
      fileName: fileName,
      bytes: bytes,
    );
  }

  @override
  Future<ReportExportResult> exportPayLaterPdf(
    PayLaterExportRequest request,
  ) async {
    final String fileName = ReportFileNamer.payLaterPdfName(
      request.generatedAt,
    );
    final PayLaterReportData data = _buildData(request);

    try {
      final List<int> bytes = await _pdfExporter.generate(data);
      return _writeResult(
        format: ReportExportFormat.pdf,
        fileName: fileName,
        bytes: bytes,
      );
    } catch (error) {
      return ReportExportResult(
        format: ReportExportFormat.pdf,
        fileName: fileName,
        status: ReportExportStatus.failed,
        message: 'Pay Later PDF generation failed: $error',
      );
    }
  }

  PayLaterReportData _buildData(PayLaterExportRequest request) {
    return PayLaterReportData(
      plans: List.unmodifiable(request.plans),
      invoices: List.unmodifiable(request.invoices),
      payments: List.unmodifiable(request.payments),
      summary: _summaryBuilder.build(
        plans: request.plans,
        invoices: request.invoices,
        payments: request.payments,
        now: request.generatedAt,
      ),
      generatedAt: request.generatedAt,
    );
  }

  Future<ReportExportResult> _writeResult({
    required ReportExportFormat format,
    required String fileName,
    required List<int> bytes,
  }) async {
    final ReportFileWriteResult? writeResult = await _safeWrite(
      fileName: fileName,
      bytes: bytes,
    );

    if (writeResult == null) {
      return ReportExportResult(
        format: format,
        fileName: fileName,
        status: ReportExportStatus.failed,
        message: 'Could not write export bytes to the selected destination.',
      );
    }

    return switch (writeResult.status) {
      ReportFileWriteStatus.saved => ReportExportResult(
        format: format,
        fileName: fileName,
        status: ReportExportStatus.saved,
        filePath: writeResult.filePath,
        message: format == ReportExportFormat.csv
            ? 'Pay Later CSV export saved.'
            : 'Pay Later PDF export saved.',
      ),
      ReportFileWriteStatus.cancelled => ReportExportResult(
        format: format,
        fileName: fileName,
        status: ReportExportStatus.cancelled,
        message: format == ReportExportFormat.csv
            ? 'Pay Later CSV export cancelled.'
            : 'Pay Later PDF export cancelled.',
      ),
      ReportFileWriteStatus.unsupported => ReportExportResult(
        format: format,
        fileName: fileName,
        status: ReportExportStatus.unsupported,
        message: format == ReportExportFormat.csv
            ? 'Pay Later CSV export is not supported on this platform.'
            : 'Pay Later PDF export is not supported on this platform.',
      ),
    };
  }

  Future<ReportFileWriteResult?> _safeWrite({
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
