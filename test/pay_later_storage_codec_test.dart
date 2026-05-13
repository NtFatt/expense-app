import 'dart:convert';

import 'package:expense_app/core/persistence/unsupported_schema_version_exception.dart';
import 'package:expense_app/features/pay_later/data/pay_later_storage_codec.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pay_later_storage_codec', () {
    test('encodes schemaVersion and round-trips Vietnamese content', () {
      final InstallmentPlan plan = _buildPlan();
      final PayLaterInvoice invoice = _buildInvoice();
      final PayLaterPayment payment = _buildPayment();

      final String encoded = encodePayLaterStorageJson(
        plans: <InstallmentPlan>[plan],
        invoices: <PayLaterInvoice>[invoice],
        payments: <PayLaterPayment>[payment],
      );
      final Map<String, Object?> payload = Map<String, Object?>.from(
        jsonDecode(encoded) as Map,
      );

      expect(payload['schemaVersion'], payLaterStorageSchemaVersion);
      expect(payload['plans'], isA<List<Object?>>());
      expect(payload['invoices'], isA<List<Object?>>());
      expect(payload['payments'], isA<List<Object?>>());

      final (
        :List<InstallmentPlan> plans,
        :List<PayLaterInvoice> invoices,
        :List<PayLaterPayment> payments,
      ) = decodePayLaterStorageJson(
        encoded,
      );

      expect(plans.single.title, 'Trả góp điện thoại');
      expect(invoices.single.providerName, 'Thẻ tín dụng Nội địa');
      expect(payments.single.note, 'Đóng tối thiểu');
    });

    test('decodes legacy object payload without schemaVersion', () {
      final String legacyPayload = jsonEncode(<String, Object?>{
        'plans': <Map<String, Object?>>[
          <String, Object?>{
            'id': 'legacy_plan_1',
            'title': 'Trả góp laptop',
            'providerName': 'Cửa hàng A',
            'originalAmount': 1200,
            'monthlyPaymentAmount': 200,
            'minimumPaymentAmount': 150,
            'paidAmount': 300,
            'totalInstallments': 6,
            'paidInstallments': 1,
            'startDate': '2026-05-01T00:00:00.000',
            'dueDayOfMonth': 15,
            'status': 'active',
            'note': 'Payload cũ',
            'createdAt': '2026-05-08T09:00:00.000',
            'updatedAt': '2026-05-08T09:00:00.000',
          },
        ],
        'invoices': <Map<String, Object?>>[],
        'payments': <Map<String, Object?>>[],
      });

      final (
        :List<InstallmentPlan> plans,
        :List<PayLaterInvoice> invoices,
        :List<PayLaterPayment> payments,
      ) = decodePayLaterStorageJson(
        legacyPayload,
      );

      expect(plans.single.id, 'legacy_plan_1');
      expect(plans.single.note, 'Payload cũ');
      expect(invoices, isEmpty);
      expect(payments, isEmpty);
    });

    test('throws gracefully for corrupt payload shape', () {
      expect(
        () => decodePayLaterStorageJson(
          '{"schemaVersion":1,"plans":{},"invoices":[],"payments":[]}',
        ),
        throwsFormatException,
      );
    });

    test('rejects unsupported future schema version', () {
      expect(
        () => decodePayLaterStorageJson(
          '{"schemaVersion":9,"plans":[],"invoices":[],"payments":[]}',
        ),
        throwsA(isA<UnsupportedSchemaVersionException>()),
      );
    });
  });
}

InstallmentPlan _buildPlan() {
  final DateTime now = DateTime(2026, 5, 8, 9, 0);
  return InstallmentPlan(
    id: 'codec_plan_1',
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
    id: 'codec_invoice_1',
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

PayLaterPayment _buildPayment() {
  final DateTime now = DateTime(2026, 5, 8, 10, 0);
  return PayLaterPayment(
    id: 'codec_payment_1',
    targetId: 'codec_plan_1',
    targetType: PayLaterTargetType.installmentPlan,
    amount: 80,
    paymentType: PayLaterPaymentType.customPayment,
    paidAt: now,
    note: 'Đóng tối thiểu',
    createdAt: now,
  );
}
