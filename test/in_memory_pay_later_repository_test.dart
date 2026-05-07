import 'package:expense_app/features/pay_later/data/in_memory_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemoryPayLaterRepository', () {
    test('recordPayment updates installment plan and stores payment', () async {
      final InMemoryPayLaterRepository repository =
          InMemoryPayLaterRepository();
      final InstallmentPlan plan = _buildPlan();
      final InstallmentPlan updatedPlan = plan.copyWith(
        paidAmount: 80,
        updatedAt: DateTime(2026, 5, 7),
      );

      await repository.addInstallmentPlan(plan);
      await repository.recordPayment(
        _buildPayment(
          targetId: plan.id,
          targetType: PayLaterTargetType.installmentPlan,
          amount: 80,
        ),
        updatedPlan: updatedPlan,
      );

      final List<InstallmentPlan> plans = await repository
          .getInstallmentPlans();
      final List<PayLaterPayment> payments = await repository.getPayments();

      expect(plans.single.paidAmount, 80);
      expect(payments.single.amount, 80);
    });

    test('recordPayment updates invoice and stores payment', () async {
      final InMemoryPayLaterRepository repository =
          InMemoryPayLaterRepository();
      final PayLaterInvoice invoice = _buildInvoice();
      final PayLaterInvoice updatedInvoice = invoice.copyWith(
        paidAmount: 150,
        status: PayLaterInvoiceStatus.partiallyPaid,
        updatedAt: DateTime(2026, 5, 7),
      );

      await repository.addInvoice(invoice);
      await repository.recordPayment(
        _buildPayment(
          targetId: invoice.id,
          targetType: PayLaterTargetType.invoice,
          amount: 150,
        ),
        updatedInvoice: updatedInvoice,
      );

      final List<PayLaterInvoice> invoices = await repository.getInvoices();
      final List<PayLaterPayment> payments = await repository.getPayments();

      expect(invoices.single.paidAmount, 150);
      expect(payments.single.amount, 150);
    });
  });
}

InstallmentPlan _buildPlan() {
  final DateTime now = DateTime(2026, 5, 6);
  return InstallmentPlan(
    id: 'plan_1',
    title: 'Laptop',
    providerName: 'Provider A',
    originalAmount: 600,
    monthlyPaymentAmount: 100,
    minimumPaymentAmount: 80,
    paidAmount: 0,
    totalInstallments: 6,
    paidInstallments: 0,
    startDate: DateTime(2026, 5, 1),
    dueDayOfMonth: 15,
    status: InstallmentStatus.active,
    createdAt: now,
    updatedAt: now,
  );
}

PayLaterInvoice _buildInvoice() {
  final DateTime now = DateTime(2026, 5, 6);
  return PayLaterInvoice(
    id: 'invoice_1',
    providerName: 'Provider B',
    statementMonth: DateTime(2026, 5),
    statementDate: DateTime(2026, 5, 2),
    dueDate: DateTime(2026, 5, 15),
    totalAmount: 500,
    minimumPaymentAmount: 150,
    paidAmount: 0,
    status: PayLaterInvoiceStatus.unpaid,
    createdAt: now,
    updatedAt: now,
  );
}

PayLaterPayment _buildPayment({
  required String targetId,
  required PayLaterTargetType targetType,
  required double amount,
}) {
  final DateTime now = DateTime(2026, 5, 7);
  return PayLaterPayment(
    id: 'payment_${targetType.name}',
    targetId: targetId,
    targetType: targetType,
    amount: amount,
    paymentType: PayLaterPaymentType.customPayment,
    paidAt: now,
    createdAt: now,
  );
}
