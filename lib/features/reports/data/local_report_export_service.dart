import 'dart:convert';

import 'package:expense_app/features/reports/data/csv_transaction_exporter.dart';
import 'package:expense_app/features/reports/data/report_file_namer.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_request.dart';
import 'package:expense_app/features/reports/domain/report_export_result.dart';

import 'report_export_service.dart';

/// Concrete implementation of [ReportExportService] for native platforms.
///
/// The CSV leg is fully implemented. The PDF leg returns a pending message
/// (deferred to Phase 9C). This class lives in the [data] layer and has
/// no `BuildContext` or Flutter UI dependencies.
class LocalReportExportService implements ReportExportService {
  const LocalReportExportService({
    required CsvTransactionExporter csvExporter,
    required ReportFileWriter fileWriter,
  }) : _csvExporter = csvExporter,
       _fileWriter = fileWriter;

  final CsvTransactionExporter _csvExporter;
  final ReportFileWriter _fileWriter;

  @override
  Future<ReportExportResult> exportTransactionsCsv(
    ReportExportRequest request,
  ) async {
    final String fileName = ReportFileNamer.transactionsCsvName(
      request.generatedAt,
    );
    final String csv = _csvExporter.generate(request.transactions);
    final List<int> bytes = utf8.encode(csv);
    final String? filePath = await _fileWriter.writeBytes(
      fileName: fileName,
      bytes: bytes,
    );

    return ReportExportResult(
      format: ReportExportFormat.csv,
      fileName: fileName,
      filePath: filePath,
      message: filePath != null
          ? 'Đã xuất CSV: $fileName'
          : 'Đã tạo CSV nhưng lưu file chưa hỗ trợ trên nền tảng này.',
    );
  }

  @override
  Future<ReportExportResult> exportMonthlyPdf(
    ReportExportRequest request,
  ) async {
    final String fileName = ReportFileNamer.monthlyPdfName(
      request.selectedMonth,
    );
    return ReportExportResult(
      format: ReportExportFormat.pdf,
      fileName: fileName,
      filePath: null,
      message: 'Xuất PDF sẽ được triển khai ở Phase 9C.',
    );
  }
}
