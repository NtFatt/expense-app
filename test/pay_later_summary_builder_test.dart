import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PayLaterSummaryBuilder', () {
    const PayLaterSummaryBuilder builder = PayLaterSummaryBuilder();

    test('builds totals, counts, and next due correctly', () {
      final DateTime now = DateTime(2026, 5, 6);
      final InstallmentPlan plan = InstallmentPlan(
        id: 'plan_1',
        title: 'Phone',
        providerName: 'Provider A',
        originalAmount: 1200,
        monthlyPaymentAmount: 100,
        minimumPaymentAmount: 80,
        paidAmount: 0,
        totalInstallments: 12,
        paidInstallments: 0,
        startDate: DateTime(2026, 5, 1),
        dueDayOfMonth: 8,
        status: InstallmentStatus.active,
        createdAt: now,
        updatedAt: now,
      );
      final PayLaterInvoice invoice = PayLaterInvoice(
        id: 'invoice_1',
        providerName: 'Provider B',
        statementMonth: DateTime(2026, 5),
        statementDate: DateTime(2026, 5, 2),
        dueDate: DateTime(2026, 5, 5),
        totalAmount: 500,
        minimumPaymentAmount: 150,
        paidAmount: 100,
        status: PayLaterInvoiceStatus.partiallyPaid,
        createdAt: now,
        updatedAt: now,
      );
      final PayLaterPayment payment = PayLaterPayment(
        id: 'payment_1',
        targetId: 'invoice_1',
        targetType: PayLaterTargetType.invoice,
        amount: 100,
        paymentType: PayLaterPaymentType.customPayment,
        paidAt: now,
        createdAt: now,
      );

      final summary = builder.build(
        plans: <InstallmentPlan>[plan],
        invoices: <PayLaterInvoice>[invoice],
        payments: <PayLaterPayment>[payment],
        now: now,
      );

      expect(summary.totalOutstanding, 1600);
      expect(summary.totalMinimumDue, 230);
      expect(summary.totalPaidThisMonth, 100);
      expect(summary.activeInstallmentCount, 1);
      expect(summary.unpaidInvoiceCount, 1);
      expect(summary.overdueCount, 1);
      expect(summary.dueSoonCount, 1);
      expect(summary.nextDueDate, DateTime(2026, 5, 5));
      expect(summary.nextDueAmount, 150);
    });

    test('returns zero summary for empty lists', () {
      final summary = builder.build(
        plans: const <InstallmentPlan>[],
        invoices: const <PayLaterInvoice>[],
        payments: const <PayLaterPayment>[],
        now: DateTime(2026, 5, 6),
      );

      expect(summary.totalOutstanding, 0);
      expect(summary.totalMinimumDue, 0);
      expect(summary.overdueCount, 0);
      expect(summary.dueSoonCount, 0);
      expect(summary.nextDueDate, isNull);
      expect(summary.nextDueAmount, 0);
    });
  });
}
