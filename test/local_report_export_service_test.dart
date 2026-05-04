import 'dart:convert';

import 'package:expense_app/features/reports/data/csv_transaction_exporter.dart';
import 'package:expense_app/features/reports/data/local_report_export_service.dart';
import 'package:expense_app/features/reports/data/monthly_report_data_builder.dart';
import 'package:expense_app/features/reports/data/pdf_monthly_report_exporter.dart';
import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/reports/domain/monthly_report_data.dart';
import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_request.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionModel _tx({
  required String id,
  required TransactionType type,
  required int amount,
  required String category,
  String? note,
  required DateTime date,
  DateTime? createdAt,
}) {
  final ts = createdAt ?? date;
  return TransactionModel(
    id: id,
    type: type,
    amount: amount,
    category: category,
    note: note,
    transactionDate: date,
    createdAt: ts,
    updatedAt: ts,
  );
}

class FakeReportFileWriter implements ReportFileWriter {
  FakeReportFileWriter(this.result);

  ReportFileWriteResult result;
  List<int>? lastBytes;
  String? lastFileName;

  @override
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
  }) async {
    lastFileName = fileName;
    lastBytes = bytes;
    return result;
  }
}

abstract class _FakePdfExporterBase {
  Future<List<int>> generate(MonthlyReportData data);
}

/// A controlled PDF exporter that returns configurable bytes for testing.
class FakePdfMonthlyReportExporter
    implements _FakePdfExporterBase, MonthlyPdfExporter {
  FakePdfMonthlyReportExporter({required this.bytes, this.shouldThrow = false});

  final List<int> bytes;
  final bool shouldThrow;

  @override
  Future<List<int>> generate(MonthlyReportData data) async {
    if (shouldThrow) {
      throw Exception('Simulated PDF generation failure');
    }
    return bytes;
  }
}

void main() {
  group('LocalReportExportService', () {
    late FakeReportFileWriter fakeWriter;
    late FakePdfMonthlyReportExporter fakePdfExporter;
    late LocalReportExportService service;

    setUp(() {
      fakeWriter = FakeReportFileWriter(
        const ReportFileWriteResult.saved('/documents/report.csv'),
      );
      fakePdfExporter = FakePdfMonthlyReportExporter(
        bytes: [0x25, 0x50, 0x44, 0x46], // %PDF fake header
      );
      service = LocalReportExportService(
        csvExporter: const CsvTransactionExporter(),
        fileWriter: fakeWriter,
        monthlyReportDataBuilder: const MonthlyReportDataBuilder(),
        pdfExporter: fakePdfExporter,
      );
    });

    test('saved result: writer is called with correct filename', () async {
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      await service.exportTransactionsCsv(request);

      expect(fakeWriter.lastFileName, 'expense_transactions_20260504_2210.csv');
    });

    test('saved result: CSV bytes contain UTF-8 BOM and header', () async {
      final request = ReportExportRequest(
        transactions: [
          _tx(
            id: 'a',
            type: TransactionType.expense,
            amount: 35000,
            category: 'Ăn uống',
            note: 'Ăn sáng',
            date: DateTime(2026, 1, 1),
          ),
        ],
        selectedMonth: DateTime(2026, 1),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      await service.exportTransactionsCsv(request);

      expect(fakeWriter.lastBytes, isNotNull);
      final String csv = utf8.decode(fakeWriter.lastBytes!);
      expect(csv, contains('Ăn uống'));
      expect(csv, contains('35000'));
    });

    test('saved result: filePath is populated', () async {
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.filePath, isNotNull);
      expect(result.format, ReportExportFormat.csv);
    });

    test('saved result: message contains filename', () async {
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.message, contains('Đã xuất CSV'));
      expect(
        result.message,
        contains('expense_transactions_20260504_2210.csv'),
      );
    });

    test('cancelled result: writer is called', () async {
      fakeWriter.result = const ReportFileWriteResult.cancelled();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      await service.exportTransactionsCsv(request);

      expect(fakeWriter.lastFileName, isNotNull);
    });

    test('cancelled result: filePath is null', () async {
      fakeWriter.result = const ReportFileWriteResult.cancelled();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.filePath, isNull);
    });

    test('cancelled result: message indicates cancellation', () async {
      fakeWriter.result = const ReportFileWriteResult.cancelled();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.message, contains('Đã hủy xuất CSV.'));
    });

    test('cancelled result: does not throw', () async {
      fakeWriter.result = const ReportFileWriteResult.cancelled();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      expect(() => service.exportTransactionsCsv(request), returnsNormally);
    });

    test('unsupported result: writer is called', () async {
      fakeWriter.result = const ReportFileWriteResult.unsupported();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      await service.exportTransactionsCsv(request);

      expect(fakeWriter.lastFileName, isNotNull);
    });

    test('unsupported result: filePath is null', () async {
      fakeWriter.result = const ReportFileWriteResult.unsupported();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.filePath, isNull);
    });

    test('unsupported result: message indicates unsupported', () async {
      fakeWriter.result = const ReportFileWriteResult.unsupported();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.message, contains('chưa hỗ trợ'));
    });

    // PDF export tests

    test('exportMonthlyPdf saved: writer called with .pdf filename', () async {
      fakeWriter.result = const ReportFileWriteResult.saved(
        '/documents/report.pdf',
      );
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      await service.exportMonthlyPdf(request);

      expect(fakeWriter.lastFileName, 'expense_monthly_report_2026_05.pdf');
      expect(fakeWriter.lastBytes, isNotNull);
    });

    test('exportMonthlyPdf saved: filePath is populated', () async {
      fakeWriter.result = const ReportFileWriteResult.saved(
        '/documents/report.pdf',
      );
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportMonthlyPdf(request);

      expect(result.filePath, isNotNull);
      expect(result.format, ReportExportFormat.pdf);
    });

    test('exportMonthlyPdf saved: success message', () async {
      fakeWriter.result = const ReportFileWriteResult.saved(
        '/documents/report.pdf',
      );
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportMonthlyPdf(request);

      expect(result.message, contains('Đã xuất PDF'));
      expect(result.message, contains('expense_monthly_report_2026_05.pdf'));
    });

    test('exportMonthlyPdf cancelled: filePath is null', () async {
      fakeWriter.result = const ReportFileWriteResult.cancelled();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportMonthlyPdf(request);

      expect(result.filePath, isNull);
    });

    test('exportMonthlyPdf cancelled: cancel message', () async {
      fakeWriter.result = const ReportFileWriteResult.cancelled();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportMonthlyPdf(request);

      expect(result.message, contains('Đã hủy xuất PDF.'));
    });

    test('exportMonthlyPdf unsupported: filePath is null', () async {
      fakeWriter.result = const ReportFileWriteResult.unsupported();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportMonthlyPdf(request);

      expect(result.filePath, isNull);
    });

    test('exportMonthlyPdf unsupported: unsupported message', () async {
      fakeWriter.result = const ReportFileWriteResult.unsupported();
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportMonthlyPdf(request);

      expect(result.message, contains('chưa hỗ trợ'));
    });

    test(
      'exportMonthlyPdf PDF generation failure: returns error message',
      () async {
        fakePdfExporter = FakePdfMonthlyReportExporter(
          bytes: [],
          shouldThrow: true,
        );
        service = LocalReportExportService(
          csvExporter: const CsvTransactionExporter(),
          fileWriter: fakeWriter,
          monthlyReportDataBuilder: const MonthlyReportDataBuilder(),
          pdfExporter: fakePdfExporter,
        );
        final request = ReportExportRequest(
          transactions: [],
          selectedMonth: DateTime(2026, 5),
          generatedAt: DateTime(2026, 5, 4, 22, 10),
        );

        final result = await service.exportMonthlyPdf(request);

        expect(result.format, ReportExportFormat.pdf);
        expect(result.message, contains('Không thể tạo PDF'));
        expect(result.filePath, isNull);
      },
    );

    test('exportMonthlyPdf uses selectedMonth for filtering', () async {
      fakeWriter.result = const ReportFileWriteResult.saved(
        '/documents/report.pdf',
      );
      final request = ReportExportRequest(
        transactions: [
          _tx(
            id: 'jan',
            type: TransactionType.expense,
            amount: 10000,
            category: 'Food',
            date: DateTime(2026, 1, 15),
          ),
          _tx(
            id: 'may',
            type: TransactionType.expense,
            amount: 20000,
            category: 'Transport',
            date: DateTime(2026, 5, 10),
          ),
        ],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );

      final result = await service.exportMonthlyPdf(request);

      expect(result.format, ReportExportFormat.pdf);
    });

    test('CSV export preserves existing behavior', () async {
      final request = ReportExportRequest(
        transactions: [
          _tx(
            id: 'b',
            type: TransactionType.income,
            amount: 100000,
            category: 'Lương',
            note: 'Tháng 1',
            date: DateTime(2026, 1, 5),
          ),
        ],
        selectedMonth: DateTime(2026, 1),
        generatedAt: DateTime(2026, 1, 10, 9, 0),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.format, ReportExportFormat.csv);
      expect(result.fileName, 'expense_transactions_20260110_0900.csv');
      expect(result.filePath, '/documents/report.csv');
    });
  });
}
