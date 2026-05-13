import 'dart:convert';

import 'package:expense_app/features/pay_later/data/shared_preferences_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _payLaterStorageKey = 'expense_app.web.pay_later.v1';
const String _payLaterCorruptStorageKey =
    'expense_app.web.pay_later.corrupt.v1';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('SharedPreferencesPayLaterRepository', () {
    test(
      'persists plans, invoices, and payments across repository recreation',
      () async {
        final SharedPreferencesPayLaterRepository repository =
            SharedPreferencesPayLaterRepository();
        final InstallmentPlan plan = _buildPlan();
        final PayLaterInvoice invoice = _buildInvoice();
        final PayLaterPayment payment = _buildPayment(
          targetId: plan.id,
          targetType: PayLaterTargetType.installmentPlan,
          amount: 80,
        );
        final InstallmentPlan updatedPlan = plan.copyWith(
          paidAmount: 80,
          updatedAt: DateTime(2026, 5, 8, 11, 0),
        );

        await repository.addInstallmentPlan(plan);
        await repository.addInvoice(invoice);
        await repository.recordPayment(payment, updatedPlan: updatedPlan);

        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        final Map<String, Object?> storedSnapshot = Map<String, Object?>.from(
          jsonDecode(preferences.getString(_payLaterStorageKey)!) as Map,
        );
        expect(storedSnapshot['schemaVersion'], 1);

        final SharedPreferencesPayLaterRepository reopened =
            SharedPreferencesPayLaterRepository();
        final List<InstallmentPlan> plans = await reopened
            .getInstallmentPlans();
        final List<PayLaterInvoice> invoices = await reopened.getInvoices();
        final List<PayLaterPayment> payments = await reopened.getPayments();

        expect(plans.single.paidAmount, 80);
        expect(plans.single.title, 'Trả góp điện thoại');
        expect(plans.single.providerName, 'Cửa hàng Điện Máy');
        expect(invoices.single.providerName, 'Thẻ tín dụng Nội địa');
        expect(payments.single.amount, 80);
        expect(payments.single.targetId, plan.id);
        expect(payments.single.note, 'Đóng tối thiểu');
      },
    );

    test(
      'persists invoice updates and deletions across repository recreation',
      () async {
        final SharedPreferencesPayLaterRepository repository =
            SharedPreferencesPayLaterRepository();
        final PayLaterInvoice invoice = _buildInvoice();

        await repository.addInvoice(invoice);
        await repository.updateInvoice(
          invoice.copyWith(
            paidAmount: 150,
            status: PayLaterInvoiceStatus.partiallyPaid,
            updatedAt: DateTime(2026, 5, 8, 12, 0),
          ),
        );

        final SharedPreferencesPayLaterRepository reopenedAfterUpdate =
            SharedPreferencesPayLaterRepository();
        final List<PayLaterInvoice> invoicesAfterUpdate =
            await reopenedAfterUpdate.getInvoices();
        expect(invoicesAfterUpdate.single.paidAmount, 150);
        expect(invoicesAfterUpdate, hasLength(1));

        await reopenedAfterUpdate.deleteInvoice(invoice.id);

        final SharedPreferencesPayLaterRepository reopenedAfterDelete =
            SharedPreferencesPayLaterRepository();
        expect(await reopenedAfterDelete.getInvoices(), isEmpty);
      },
    );

    test('recovers gracefully from corrupt json storage', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        _payLaterStorageKey: '{"plans":',
      });

      final SharedPreferencesPayLaterRepository repository =
          SharedPreferencesPayLaterRepository();

      expect(await repository.getInstallmentPlans(), isEmpty);
      expect(await repository.getInvoices(), isEmpty);
      expect(await repository.getPayments(), isEmpty);

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final Map<String, Object?> repairedPayload = Map<String, Object?>.from(
        jsonDecode(preferences.getString(_payLaterStorageKey)!) as Map,
      );
      expect(repairedPayload['schemaVersion'], 1);
      expect(repairedPayload['plans'], isEmpty);
      expect(repairedPayload['invoices'], isEmpty);
      expect(repairedPayload['payments'], isEmpty);
      expect(preferences.getString(_payLaterCorruptStorageKey), '{"plans":');
    });
  });
}

InstallmentPlan _buildPlan() {
  final DateTime now = DateTime(2026, 5, 8, 9, 0);
  return InstallmentPlan(
    id: 'plan_web_1',
    title: 'Trả góp điện thoại',
    providerName: 'Cửa hàng Điện Máy',
    originalAmount: 600,
    monthlyPaymentAmount: 100,
    minimumPaymentAmount: 80,
    paidAmount: 0,
    totalInstallments: 6,
    paidInstallments: 0,
    startDate: DateTime(2026, 5, 1),
    dueDayOfMonth: 15,
    status: InstallmentStatus.active,
    note: 'Kỳ đầu tiên',
    createdAt: now,
    updatedAt: now,
  );
}

PayLaterInvoice _buildInvoice() {
  final DateTime now = DateTime(2026, 5, 8, 9, 0);
  return PayLaterInvoice(
    id: 'invoice_web_1',
    providerName: 'Thẻ tín dụng Nội địa',
    statementMonth: DateTime(2026, 5),
    statementDate: DateTime(2026, 5, 2),
    dueDate: DateTime(2026, 5, 15),
    totalAmount: 500,
    minimumPaymentAmount: 150,
    paidAmount: 0,
    status: PayLaterInvoiceStatus.unpaid,
    note: 'Hóa đơn tháng Năm',
    createdAt: now,
    updatedAt: now,
  );
}

PayLaterPayment _buildPayment({
  required String targetId,
  required PayLaterTargetType targetType,
  required double amount,
}) {
  final DateTime now = DateTime(2026, 5, 8, 10, 0);
  return PayLaterPayment(
    id: 'payment_${targetType.name}_$targetId',
    targetId: targetId,
    targetType: targetType,
    amount: amount,
    paymentType: PayLaterPaymentType.customPayment,
    paidAt: now,
    note: 'Đóng tối thiểu',
    createdAt: now,
  );
}
