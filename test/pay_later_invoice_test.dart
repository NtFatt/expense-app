import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PayLaterInvoice', () {
    test('outstandingAmount and isPaid are calculated correctly', () {
      final PayLaterInvoice invoice = _buildInvoice(
        totalAmount: 500,
        paidAmount: 200,
      );

      expect(invoice.outstandingAmount, 300);
      expect(invoice.isPaid, isFalse);
    });

    test('invoice can become fully paid', () {
      final PayLaterInvoice invoice = _buildInvoice(
        totalAmount: 500,
        paidAmount: 500,
      );

      expect(invoice.outstandingAmount, 0);
      expect(invoice.isPaid, isTrue);
      expect(
        invoice.effectiveStatus(DateTime(2026, 5, 10)),
        PayLaterInvoiceStatus.paid,
      );
    });

    test('isOverdue returns true when due date already passed', () {
      final PayLaterInvoice invoice = _buildInvoice(
        dueDate: DateTime(2026, 5, 5),
      );

      expect(invoice.isOverdue(DateTime(2026, 5, 8)), isTrue);
      expect(
        invoice.effectiveStatus(DateTime(2026, 5, 8)),
        PayLaterInvoiceStatus.overdue,
      );
    });

    test('isDueSoon returns true for due date within three days', () {
      final PayLaterInvoice invoice = _buildInvoice(
        dueDate: DateTime(2026, 5, 9),
      );

      expect(invoice.isDueSoon(DateTime(2026, 5, 7)), isTrue);
    });
  });
}

PayLaterInvoice _buildInvoice({
  double totalAmount = 600,
  double paidAmount = 0,
  DateTime? dueDate,
}) {
  final DateTime now = DateTime(2026, 5, 6);
  return PayLaterInvoice(
    id: 'invoice_1',
    providerName: 'Provider B',
    statementMonth: DateTime(2026, 5),
    statementDate: DateTime(2026, 5, 3),
    dueDate: dueDate ?? DateTime(2026, 5, 12),
    totalAmount: totalAmount,
    minimumPaymentAmount: 150,
    paidAmount: paidAmount,
    status: PayLaterInvoiceStatus.unpaid,
    createdAt: now,
    updatedAt: now,
  );
}
