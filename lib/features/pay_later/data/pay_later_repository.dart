import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';

abstract class PayLaterRepository {
  Future<List<InstallmentPlan>> getInstallmentPlans();

  Future<List<PayLaterInvoice>> getInvoices();

  Future<List<PayLaterPayment>> getPayments();

  Future<void> addInstallmentPlan(InstallmentPlan plan);

  Future<void> updateInstallmentPlan(InstallmentPlan plan);

  Future<void> deleteInstallmentPlan(String id);

  Future<void> addInvoice(PayLaterInvoice invoice);

  Future<void> updateInvoice(PayLaterInvoice invoice);

  Future<void> deleteInvoice(String id);

  Future<void> recordPayment(
    PayLaterPayment payment, {
    InstallmentPlan? updatedPlan,
    PayLaterInvoice? updatedInvoice,
  });

  Future<void> replaceAll({
    required List<InstallmentPlan> plans,
    required List<PayLaterInvoice> invoices,
    required List<PayLaterPayment> payments,
  });
}
