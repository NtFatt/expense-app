import 'dart:convert';

import 'package:expense_app/features/reports/data/csv_transaction_exporter.dart';
import 'package:expense_app/features/reports/data/local_report_export_service.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
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

/// Fake file writer for testing — stores last write call and returns a fake path.
class FakeReportFileWriter {
  String? lastFileName;
  List<int>? lastBytes;

  String? writeResult;

  Future<String?> writeBytes({
    required String fileName,
    required List<int> bytes,
  }) async {
    lastFileName = fileName;
    lastBytes = bytes;
    return writeResult;
  }
}

class _FakeReportFileWriterAdapter implements ReportFileWriter {
  _FakeReportFileWriterAdapter(this._fake);

  final FakeReportFileWriter _fake;

  @override
  Future<String?> writeBytes({
    required String fileName,
    required List<int> bytes,
  }) {
    return _fake.writeBytes(fileName: fileName, bytes: bytes);
  }
}

void main() {
  group('LocalReportExportService', () {
    late FakeReportFileWriter fakeWriter;
    late LocalReportExportService service;

    setUp(() {
      fakeWriter = FakeReportFileWriter();
      service = LocalReportExportService(
        csvExporter: const CsvTransactionExporter(),
        fileWriter: _FakeReportFileWriterAdapter(fakeWriter),
      );
    });

    test('exportTransactionsCsv calls writer with expected filename', () async {
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 22, 10),
      );
      fakeWriter.writeResult =
          '/fake/path/expense_transactions_20260504_2210.csv';

      await service.exportTransactionsCsv(request);

      expect(fakeWriter.lastFileName, 'expense_transactions_20260504_2210.csv');
    });

    test('exportTransactionsCsv passes UTF-8 encoded bytes', () async {
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
      fakeWriter.writeResult =
          '/fake/path/expense_transactions_20260504_2210.csv';

      await service.exportTransactionsCsv(request);

      expect(fakeWriter.lastBytes, isNotNull);
      final String csv = utf8.decode(fakeWriter.lastBytes!);
      expect(csv, contains('Ăn uống'));
      expect(csv, contains('35000'));
    });

    test('exportTransactionsCsv result contains format csv', () async {
      fakeWriter.writeResult = '/fake/path/test.csv';
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.format, ReportExportFormat.csv);
    });

    test('exportTransactionsCsv result contains filename', () async {
      fakeWriter.writeResult = '/fake/path/test.csv';
      final request = ReportExportRequest(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4),
      );

      final result = await service.exportTransactionsCsv(request);

      expect(result.fileName, 'expense_transactions_20260504_0000.csv');
    });

    test(
      'exportTransactionsCsv result contains filePath when writer succeeds',
      () async {
        fakeWriter.writeResult =
            '/documents/expense_transactions_20260504_2210.csv';
        final request = ReportExportRequest(
          transactions: [],
          selectedMonth: DateTime(2026, 5),
          generatedAt: DateTime(2026, 5, 4, 22, 10),
        );

        final result = await service.exportTransactionsCsv(request);

        expect(result.filePath, isNotNull);
        expect(result.message, contains('Đã xuất CSV'));
      },
    );

    test(
      'exportTransactionsCsv result contains message when writer returns null (web)',
      () async {
        fakeWriter.writeResult = null;
        final request = ReportExportRequest(
          transactions: [],
          selectedMonth: DateTime(2026, 5),
          generatedAt: DateTime(2026, 5, 4),
        );

        final result = await service.exportTransactionsCsv(request);

        expect(result.filePath, isNull);
        expect(result.message, contains('chưa hỗ trợ'));
      },
    );

    test(
      'exportMonthlyPdf returns pending message and does not throw',
      () async {
        final request = ReportExportRequest(
          transactions: [],
          selectedMonth: DateTime(2026, 5),
          generatedAt: DateTime(2026, 5, 4),
        );

        final result = await service.exportMonthlyPdf(request);

        expect(result.format, ReportExportFormat.pdf);
        expect(result.message, contains('9C'));
        expect(result.filePath, isNull);
      },
    );
  });
}
