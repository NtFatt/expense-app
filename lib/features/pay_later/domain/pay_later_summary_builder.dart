import 'installment_plan.dart';
import 'pay_later_enums.dart';
import 'pay_later_invoice.dart';
import 'pay_later_payment.dart';
import 'pay_later_summary.dart';

class PayLaterSummaryBuilder {
  const PayLaterSummaryBuilder();

  PayLaterSummary build({
    required List<InstallmentPlan> plans,
    required List<PayLaterInvoice> invoices,
    required List<PayLaterPayment> payments,
    required DateTime now,
  }) {
    if (plans.isEmpty && invoices.isEmpty && payments.isEmpty) {
      return PayLaterSummary.empty;
    }

    final List<InstallmentPlan> openPlans = plans.where((InstallmentPlan plan) {
      final InstallmentStatus status = plan.effectiveStatus(now);
      return status != InstallmentStatus.cancelled &&
          status != InstallmentStatus.settled;
    }).toList();

    final List<PayLaterInvoice> openInvoices = invoices.where((
      PayLaterInvoice invoice,
    ) {
      return invoice.effectiveStatus(now) != PayLaterInvoiceStatus.paid;
    }).toList();

    final double totalOutstanding =
        openPlans.fold<double>(
          0,
          (double total, InstallmentPlan plan) =>
              total + plan.outstandingAmount,
        ) +
        openInvoices.fold<double>(
          0,
          (double total, PayLaterInvoice invoice) =>
              total + invoice.outstandingAmount,
        );

    final double totalMinimumDue =
        openPlans.fold<double>(
          0,
          (double total, InstallmentPlan plan) => total + plan.minimumAmountDue,
        ) +
        openInvoices.fold<double>(
          0,
          (double total, PayLaterInvoice invoice) =>
              total + invoice.minimumAmountDue,
        );

    final double totalPaidThisMonth = payments
        .where(
          (PayLaterPayment payment) =>
              payment.paidAt.year == now.year &&
              payment.paidAt.month == now.month,
        )
        .fold<double>(
          0,
          (double total, PayLaterPayment payment) => total + payment.amount,
        );

    final int overdueCount =
        openPlans.where((InstallmentPlan plan) => plan.isOverdue(now)).length +
        openInvoices
            .where((PayLaterInvoice invoice) => invoice.isOverdue(now))
            .length;

    final int dueSoonCount =
        openPlans.where((InstallmentPlan plan) => plan.isDueSoon(now)).length +
        openInvoices
            .where((PayLaterInvoice invoice) => invoice.isDueSoon(now))
            .length;

    DateTime? nextDueDate;
    double nextDueAmount = 0;

    for (final InstallmentPlan plan in openPlans) {
      nextDueDate = _pickEarlierDate(nextDueDate, plan.nextDueDate);
    }
    for (final PayLaterInvoice invoice in openInvoices) {
      nextDueDate = _pickEarlierDate(nextDueDate, invoice.dueDate);
    }

    if (nextDueDate != null) {
      for (final InstallmentPlan plan in openPlans) {
        if (_sameDay(plan.nextDueDate, nextDueDate)) {
          nextDueAmount += plan.minimumAmountDue;
        }
      }
      for (final PayLaterInvoice invoice in openInvoices) {
        if (_sameDay(invoice.dueDate, nextDueDate)) {
          nextDueAmount += invoice.minimumAmountDue;
        }
      }
    }

    return PayLaterSummary(
      totalOutstanding: totalOutstanding,
      totalMinimumDue: totalMinimumDue,
      totalPaidThisMonth: totalPaidThisMonth,
      activeInstallmentCount: openPlans.length,
      unpaidInvoiceCount: openInvoices.length,
      overdueCount: overdueCount,
      dueSoonCount: dueSoonCount,
      nextDueDate: nextDueDate,
      nextDueAmount: nextDueAmount,
    );
  }

  DateTime? _pickEarlierDate(DateTime? current, DateTime candidate) {
    if (current == null) {
      return candidate;
    }

    return candidate.isBefore(current) ? candidate : current;
  }

  bool _sameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}
