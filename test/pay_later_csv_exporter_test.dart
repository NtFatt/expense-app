import 'package:expense_app/features/pay_later/data/pay_later_csv_exporter.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_report_data.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_data/backup_fixture.dart';

void main() {
  group('PayLaterCsvExporter', () {
    test('includes UTF-8 BOM, Vietnamese content, and summary sections', () {
      final backup = buildBackupFixture();
      final data = PayLaterReportData(
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

      final String csv = const PayLaterCsvExporter().generate(data);

      expect(csv.startsWith('\uFEFFsection,metric,value'), isTrue);
      expect(csv, contains('Trả góp điện thoại'));
      expect(csv, contains('Thẻ tín dụng Nội địa'));
      expect(csv, contains('Đóng tối thiểu'));
      expect(csv, contains('summary,total_outstanding'));
      expect(csv, contains('plans,id,title'));
      expect(csv, contains('payments,id,target_type'));
    });

    test('escapes comma quote and newline in notes', () {
      final backup = buildBackupFixture();
      final mutatedPlan = backup.data.payLater.plans.single.copyWith(
        note: 'Tháng 5, "ưu tiên"\nđợt 1',
      );
      final data = PayLaterReportData(
        plans: <InstallmentPlan>[mutatedPlan],
        invoices: backup.data.payLater.invoices,
        payments: backup.data.payLater.payments,
        summary: const PayLaterSummaryBuilder().build(
          plans: <InstallmentPlan>[mutatedPlan],
          invoices: backup.data.payLater.invoices,
          payments: backup.data.payLater.payments,
          now: backup.exportedAt,
        ),
        generatedAt: backup.exportedAt,
      );

      final String csv = const PayLaterCsvExporter().generate(data);

      expect(csv, contains('"Tháng 5, ""ưu tiên""\nđợt 1"'));
    });

    test('empty data still exports section headers', () {
      final data = PayLaterReportData(
        plans: const <InstallmentPlan>[],
        invoices: const <PayLaterInvoice>[],
        payments: const <PayLaterPayment>[],
        summary: const PayLaterSummaryBuilder().build(
          plans: const <InstallmentPlan>[],
          invoices: const <PayLaterInvoice>[],
          payments: const <PayLaterPayment>[],
          now: DateTime(2026, 5, 8),
        ),
        generatedAt: DateTime(2026, 5, 8),
      );

      final String csv = const PayLaterCsvExporter().generate(data);

      expect(csv, contains('plans,id,title'));
      expect(csv, contains('invoices,id,provider_name'));
      expect(csv, contains('payments,id,target_type'));
    });
  });
}
