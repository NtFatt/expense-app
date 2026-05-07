import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pay later enum codecs', () {
    test('InstallmentStatus codec falls back safely', () {
      expect(
        InstallmentStatusCodec.fromName('overdue'),
        InstallmentStatus.overdue,
      );
      expect(
        InstallmentStatusCodec.fromName('unknown_status'),
        InstallmentStatus.active,
      );
    });

    test('PayLaterInvoiceStatus codec falls back safely', () {
      expect(
        PayLaterInvoiceStatusCodec.fromName('paid'),
        PayLaterInvoiceStatus.paid,
      );
      expect(
        PayLaterInvoiceStatusCodec.fromName('unknown_status'),
        PayLaterInvoiceStatus.unpaid,
      );
    });

    test('PayLaterPaymentType codec falls back safely', () {
      expect(
        PayLaterPaymentTypeCodec.fromName('fullSettlement'),
        PayLaterPaymentType.fullSettlement,
      );
      expect(
        PayLaterPaymentTypeCodec.fromName('unknown_type'),
        PayLaterPaymentType.customPayment,
      );
    });

    test('PayLaterTargetType codec falls back safely', () {
      expect(
        PayLaterTargetTypeCodec.fromName('invoice'),
        PayLaterTargetType.invoice,
      );
      expect(
        PayLaterTargetTypeCodec.fromName('unknown_target'),
        PayLaterTargetType.installmentPlan,
      );
    });
  });
}
