import 'package:expense_app/features/pay_later/data/pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';

class InMemoryPayLaterRepository implements PayLaterRepository {
  final List<InstallmentPlan> _plans = <InstallmentPlan>[];
  final List<PayLaterInvoice> _invoices = <PayLaterInvoice>[];
  final List<PayLaterPayment> _payments = <PayLaterPayment>[];

  @override
  Future<List<InstallmentPlan>> getInstallmentPlans() async {
    return List<InstallmentPlan>.unmodifiable(_plans);
  }

  @override
  Future<List<PayLaterInvoice>> getInvoices() async {
    return List<PayLaterInvoice>.unmodifiable(_invoices);
  }

  @override
  Future<List<PayLaterPayment>> getPayments() async {
    return List<PayLaterPayment>.unmodifiable(_payments);
  }

  @override
  Future<void> addInstallmentPlan(InstallmentPlan plan) async {
    _plans.add(plan);
  }

  @override
  Future<void> updateInstallmentPlan(InstallmentPlan plan) async {
    final int index = _plans.indexWhere(
      (InstallmentPlan item) => item.id == plan.id,
    );
    if (index == -1) {
      throw StateError('Installment plan not found: ${plan.id}');
    }

    _plans[index] = plan;
  }

  @override
  Future<void> deleteInstallmentPlan(String id) async {
    _plans.removeWhere((InstallmentPlan plan) => plan.id == id);
  }

  @override
  Future<void> addInvoice(PayLaterInvoice invoice) async {
    _invoices.add(invoice);
  }

  @override
  Future<void> updateInvoice(PayLaterInvoice invoice) async {
    final int index = _invoices.indexWhere(
      (PayLaterInvoice item) => item.id == invoice.id,
    );
    if (index == -1) {
      throw StateError('Pay later invoice not found: ${invoice.id}');
    }

    _invoices[index] = invoice;
  }

  @override
  Future<void> deleteInvoice(String id) async {
    _invoices.removeWhere((PayLaterInvoice invoice) => invoice.id == id);
  }

  @override
  Future<void> recordPayment(
    PayLaterPayment payment, {
    InstallmentPlan? updatedPlan,
    PayLaterInvoice? updatedInvoice,
  }) async {
    if (payment.targetType == PayLaterTargetType.installmentPlan) {
      if (updatedPlan == null ||
          updatedPlan.id != payment.targetId ||
          updatedInvoice != null) {
        throw ArgumentError(
          'An updated installment plan is required for payment ${payment.id}.',
        );
      }

      final int index = _plans.indexWhere(
        (InstallmentPlan item) => item.id == payment.targetId,
      );
      if (index == -1) {
        throw StateError('Installment plan not found: ${payment.targetId}');
      }

      _plans[index] = updatedPlan;
    } else {
      if (updatedInvoice == null ||
          updatedInvoice.id != payment.targetId ||
          updatedPlan != null) {
        throw ArgumentError(
          'An updated invoice is required for payment ${payment.id}.',
        );
      }

      final int index = _invoices.indexWhere(
        (PayLaterInvoice item) => item.id == payment.targetId,
      );
      if (index == -1) {
        throw StateError('Pay later invoice not found: ${payment.targetId}');
      }

      _invoices[index] = updatedInvoice;
    }

    _payments.add(payment);
  }

  @override
  Future<void> replaceAll({
    required List<InstallmentPlan> plans,
    required List<PayLaterInvoice> invoices,
    required List<PayLaterPayment> payments,
  }) async {
    _plans
      ..clear()
      ..addAll(plans);
    _invoices
      ..clear()
      ..addAll(invoices);
    _payments
      ..clear()
      ..addAll(payments);
  }
}
