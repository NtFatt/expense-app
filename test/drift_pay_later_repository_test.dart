import 'dart:io';

import 'package:drift/native.dart';
import 'package:expense_app/core/database/app_database.dart' as database;
import 'package:expense_app/features/pay_later/data/drift_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('DriftPayLaterRepository', () {
    test('persists pay later data across database reopen', () async {
      final Directory tempDirectory = await Directory.systemTemp.createTemp(
        'expense_app_pay_later_',
      );
      final File databaseFile = File(
        path.join(tempDirectory.path, 'expense_app.sqlite'),
      );
      database.AppDatabase? appDatabase;

      try {
        appDatabase = database.AppDatabase(
          executor: NativeDatabase(databaseFile),
        );
        DriftPayLaterRepository repository = DriftPayLaterRepository(
          appDatabase,
        );

        final InstallmentPlan plan = _buildPlan();
        final InstallmentPlan updatedPlan = plan.copyWith(
          paidAmount: 1234.56,
          updatedAt: DateTime(2026, 5, 7, 8, 30),
        );
        final PayLaterInvoice invoice = _buildInvoice();

        await repository.addInstallmentPlan(plan);
        await repository.addInvoice(invoice);
        await repository.recordPayment(
          _buildPayment(
            targetId: plan.id,
            targetType: PayLaterTargetType.installmentPlan,
            amount: 1234.56,
          ),
          updatedPlan: updatedPlan,
        );

        await appDatabase.close();
        appDatabase = null;
        appDatabase = database.AppDatabase(
          executor: NativeDatabase(databaseFile),
        );
        repository = DriftPayLaterRepository(appDatabase);

        final List<InstallmentPlan> plans = await repository
            .getInstallmentPlans();
        final List<PayLaterInvoice> invoices = await repository.getInvoices();
        final List<PayLaterPayment> payments = await repository.getPayments();

        expect(plans, hasLength(1));
        expect(plans.single.paidAmount, 1234.56);
        expect(invoices, hasLength(1));
        expect(invoices.single.totalAmount, 5000.75);
        expect(payments, hasLength(1));
        expect(payments.single.amount, 1234.56);
      } finally {
        await appDatabase?.close();
        await tempDirectory.delete(recursive: true);
      }
    });

    test('updateInstallmentPlan throws when plan does not exist', () async {
      final database.AppDatabase appDatabase = database.AppDatabase(
        executor: NativeDatabase.memory(),
      );
      final DriftPayLaterRepository repository = DriftPayLaterRepository(
        appDatabase,
      );

      try {
        await expectLater(
          repository.updateInstallmentPlan(_buildPlan()),
          throwsA(isA<StateError>()),
        );
      } finally {
        await appDatabase.close();
      }
    });
  });
}

InstallmentPlan _buildPlan() {
  final DateTime now = DateTime(2026, 5, 6, 9, 0);
  return InstallmentPlan(
    id: 'plan_1',
    title: 'Phone',
    providerName: 'Provider A',
    originalAmount: 9000.5,
    monthlyPaymentAmount: 1500.25,
    minimumPaymentAmount: 500.75,
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
  final DateTime now = DateTime(2026, 5, 6, 9, 0);
  return PayLaterInvoice(
    id: 'invoice_1',
    providerName: 'Provider B',
    statementMonth: DateTime(2026, 5),
    statementDate: DateTime(2026, 5, 2),
    dueDate: DateTime(2026, 5, 20),
    totalAmount: 5000.75,
    minimumPaymentAmount: 1200.5,
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
  final DateTime now = DateTime(2026, 5, 7, 8, 30);
  return PayLaterPayment(
    id: 'payment_1',
    targetId: targetId,
    targetType: targetType,
    amount: amount,
    paymentType: PayLaterPaymentType.customPayment,
    paidAt: now,
    createdAt: now,
  );
}
