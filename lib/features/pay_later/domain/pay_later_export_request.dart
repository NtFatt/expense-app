import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';

final class PayLaterExportRequest {
  const PayLaterExportRequest({
    required this.plans,
    required this.invoices,
    required this.payments,
    required this.generatedAt,
  });

  final List<InstallmentPlan> plans;
  final List<PayLaterInvoice> invoices;
  final List<PayLaterPayment> payments;
  final DateTime generatedAt;
}
