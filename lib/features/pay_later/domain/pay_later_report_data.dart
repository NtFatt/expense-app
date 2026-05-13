import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary.dart';

final class PayLaterReportData {
  const PayLaterReportData({
    required this.plans,
    required this.invoices,
    required this.payments,
    required this.summary,
    required this.generatedAt,
  });

  final List<InstallmentPlan> plans;
  final List<PayLaterInvoice> invoices;
  final List<PayLaterPayment> payments;
  final PayLaterSummary summary;
  final DateTime generatedAt;

  bool get isEmpty => plans.isEmpty && invoices.isEmpty && payments.isEmpty;
}
