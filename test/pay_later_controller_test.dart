import 'package:expense_app/features/pay_later/data/in_memory_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/presentation/controllers/pay_later_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PayLaterController', () {
    late InMemoryPayLaterRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = InMemoryPayLaterRepository();
      container = ProviderContainer(
        overrides: [payLaterRepositoryProvider.overrideWithValue(repository)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('addInstallmentPlan updates state', () async {
      await container.read(payLaterControllerProvider.future);

      await container
          .read(payLaterControllerProvider.notifier)
          .addInstallmentPlan(_buildPlan());

      final PayLaterState state = await container.read(
        payLaterControllerProvider.future,
      );

      expect(state.plans, hasLength(1));
      expect(state.summary.activeInstallmentCount, 1);
    });

    test('addInvoice updates state', () async {
      await container.read(payLaterControllerProvider.future);

      await container
          .read(payLaterControllerProvider.notifier)
          .addInvoice(_buildInvoice());

      final PayLaterState state = await container.read(
        payLaterControllerProvider.future,
      );

      expect(state.invoices, hasLength(1));
      expect(state.summary.unpaidInvoiceCount, 1);
    });

    test(
      'recordMinimumPayment updates paid amount and saves payment',
      () async {
        final InstallmentPlan plan = _buildPlan();
        await container
            .read(payLaterControllerProvider.notifier)
            .addInstallmentPlan(plan);

        await container
            .read(payLaterControllerProvider.notifier)
            .recordMinimumPayment(
              targetType: PayLaterTargetType.installmentPlan,
              targetId: plan.id,
            );

        final PayLaterState state = await container.read(
          payLaterControllerProvider.future,
        );

        expect(state.plans.single.paidAmount, 80);
        expect(state.payments, hasLength(1));
        expect(state.payments.single.amount, 80);
      },
    );

    test('recordCustomPayment updates invoice paid amount', () async {
      final PayLaterInvoice invoice = _buildInvoice();
      await container
          .read(payLaterControllerProvider.notifier)
          .addInvoice(invoice);

      await container
          .read(payLaterControllerProvider.notifier)
          .recordCustomPayment(
            targetType: PayLaterTargetType.invoice,
            targetId: invoice.id,
            amount: 120,
          );

      final PayLaterState state = await container.read(
        payLaterControllerProvider.future,
      );

      expect(state.invoices.single.paidAmount, 120);
      expect(state.invoices.single.outstandingAmount, 380);
    });

    test('settleFullAmount marks target as settled/paid', () async {
      final InstallmentPlan plan = _buildPlan();
      await container
          .read(payLaterControllerProvider.notifier)
          .addInstallmentPlan(plan);

      await container
          .read(payLaterControllerProvider.notifier)
          .settleFullAmount(
            targetType: PayLaterTargetType.installmentPlan,
            targetId: plan.id,
          );

      final PayLaterState state = await container.read(
        payLaterControllerProvider.future,
      );

      expect(state.plans.single.outstandingAmount, 0);
      expect(
        state.plans.single.effectiveStatus(DateTime(2026, 5, 6)),
        InstallmentStatus.settled,
      );
    });

    test('custom amount cannot exceed outstanding', () async {
      final InstallmentPlan plan = _buildPlan();
      await container
          .read(payLaterControllerProvider.notifier)
          .addInstallmentPlan(plan);

      await expectLater(
        container
            .read(payLaterControllerProvider.notifier)
            .recordCustomPayment(
              targetType: PayLaterTargetType.installmentPlan,
              targetId: plan.id,
              amount: 9999,
            ),
        throwsA(isA<ArgumentError>()),
      );
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
