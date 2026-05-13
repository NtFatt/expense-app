import 'dart:convert';

import 'package:expense_app/features/pay_later/data/local_pay_later_export_service.dart';
import 'package:expense_app/features/pay_later/data/pay_later_csv_exporter.dart';
import 'package:expense_app/features/pay_later/data/pay_later_pdf_exporter.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_export_request.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_report_data.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary_builder.dart';
import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_result.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_data/backup_fixture.dart';

void main() {
  group('LocalPayLaterExportService', () {
    late RecordingWriter writer;
    late FakePayLaterPdfExporter pdfExporter;
    late LocalPayLaterExportService service;
    late PayLaterExportRequest request;

    setUp(() {
      writer = RecordingWriter();
      pdfExporter = FakePayLaterPdfExporter();
      final backup = buildBackupFixture();
      request = PayLaterExportRequest(
        plans: backup.data.payLater.plans,
        invoices: backup.data.payLater.invoices,
        payments: backup.data.payLater.payments,
        generatedAt: DateTime(2026, 5, 8, 15, 40),
      );
      service = LocalPayLaterExportService(
        csvExporter: const PayLaterCsvExporter(),
        pdfExporter: pdfExporter,
        fileWriter: writer,
        summaryBuilder: const PayLaterSummaryBuilder(),
      );
    });

    test(
      'exports CSV with deterministic filename and Vietnamese content',
      () async {
        final ReportExportResult result = await service.exportPayLaterCsv(
          request,
        );

        expect(result.status, ReportExportStatus.saved);
        expect(result.format, ReportExportFormat.csv);
        expect(writer.lastFileName, 'expense_pay_later_20260508_1540.csv');
        expect(utf8.decode(writer.lastBytes!), contains('Trả góp điện thoại'));
      },
    );

    test('exports PDF with deterministic filename', () async {
      final ReportExportResult result = await service.exportPayLaterPdf(
        request,
      );

      expect(result.status, ReportExportStatus.saved);
      expect(result.format, ReportExportFormat.pdf);
      expect(writer.lastFileName, 'expense_pay_later_report_20260508_1540.pdf');
      expect(writer.lastBytes, pdfExporter.bytes);
    });

    test('returns cancelled result when writer is cancelled', () async {
      writer.result = const ReportFileWriteResult.cancelled();

      final ReportExportResult result = await service.exportPayLaterCsv(
        request,
      );

      expect(result.status, ReportExportStatus.cancelled);
      expect(result.filePath, isNull);
    });

    test('returns unsupported result when writer is unsupported', () async {
      writer.result = const ReportFileWriteResult.unsupported();

      final ReportExportResult result = await service.exportPayLaterPdf(
        request,
      );

      expect(result.status, ReportExportStatus.unsupported);
      expect(result.filePath, isNull);
    });

    test('supports empty exports without failure', () async {
      final ReportExportResult result = await service.exportPayLaterCsv(
        PayLaterExportRequest(
          plans: const <InstallmentPlan>[],
          invoices: const <PayLaterInvoice>[],
          payments: const <PayLaterPayment>[],
          generatedAt: DateTime(2026, 5, 8, 15, 40),
        ),
      );

      expect(result.status, ReportExportStatus.saved);
      expect(
        utf8.decode(writer.lastBytes!),
        contains('summary,total_outstanding'),
      );
    });
  });
}

class RecordingWriter implements ReportFileWriter {
  ReportFileWriteResult result = const ReportFileWriteResult.saved(
    '/tmp/pay_later.csv',
  );
  String? lastFileName;
  List<int>? lastBytes;

  @override
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
    String androidDirectoryName = 'reports',
  }) async {
    lastFileName = fileName;
    lastBytes = bytes;
    return result;
  }
}

class FakePayLaterPdfExporter implements PayLaterPdfExporter {
  final List<int> bytes = <int>[0x25, 0x50, 0x44, 0x46];

  @override
  Future<List<int>> generate(PayLaterReportData data) async => bytes;
}
