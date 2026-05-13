import 'dart:convert';

import 'package:expense_app/features/pay_later/data/pay_later_pdf_exporter.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_report_data.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary_builder.dart';
import 'package:expense_app/features/reports/data/pdf_font_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_data/backup_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'PdfPayLaterExporter generates a PDF document for Vietnamese data',
    () async {
      final backup = buildBackupFixture();
      final PayLaterReportData data = PayLaterReportData(
        plans: backup.data.payLater.plans,
        invoices: backup.data.payLater.invoices,
        payments: backup.data.payLater.payments,
        summary: const PayLaterSummaryBuilder().build(
          plans: backup.data.payLater.plans,
          invoices: backup.data.payLater.invoices,
          payments: backup.data.payLater.payments,
          now: backup.exportedAt,
        ),
        generatedAt: backup.exportedAt,
      );

      final List<int> bytes = await const PdfPayLaterExporter(
        fontLoader: PdfFontLoader(),
      ).generate(data);

      final String header = ascii.decode(bytes.take(4).toList());
      expect(header, '%PDF');
      expect(bytes.length, greaterThan(1000));
    },
  );
}
