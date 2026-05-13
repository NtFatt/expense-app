import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_report_data.dart';

class PayLaterCsvExporter {
  const PayLaterCsvExporter();

  static const String _utf8Bom = '\uFEFF';

  String generate(PayLaterReportData data) {
    final StringBuffer buffer = StringBuffer()..write(_utf8Bom);

    buffer.writeln('section,metric,value');
    buffer.writeln(
      'summary,total_outstanding,${_escapeCsvCell(data.summary.totalOutstanding.toStringAsFixed(2))}',
    );
    buffer.writeln(
      'summary,total_minimum_due,${_escapeCsvCell(data.summary.totalMinimumDue.toStringAsFixed(2))}',
    );
    buffer.writeln(
      'summary,total_paid_this_month,${_escapeCsvCell(data.summary.totalPaidThisMonth.toStringAsFixed(2))}',
    );
    buffer.writeln(
      'summary,active_installment_count,${_escapeCsvCell(data.summary.activeInstallmentCount.toString())}',
    );
    buffer.writeln(
      'summary,unpaid_invoice_count,${_escapeCsvCell(data.summary.unpaidInvoiceCount.toString())}',
    );
    buffer.writeln(
      'summary,overdue_count,${_escapeCsvCell(data.summary.overdueCount.toString())}',
    );
    buffer.writeln(
      'summary,due_soon_count,${_escapeCsvCell(data.summary.dueSoonCount.toString())}',
    );
    buffer.writeln(
      'summary,next_due_date,${_escapeCsvCell(data.summary.nextDueDate == null ? '' : _formatDate(data.summary.nextDueDate!))}',
    );
    buffer.writeln(
      'summary,next_due_amount,${_escapeCsvCell(data.summary.nextDueAmount.toStringAsFixed(2))}',
    );

    buffer.writeln();
    buffer.writeln(
      'plans,id,title,provider_name,original_amount,monthly_payment_amount,minimum_payment_amount,paid_amount,total_installments,paid_installments,start_date,due_day_of_month,status,note,created_at,updated_at',
    );
    for (final plan in data.plans) {
      buffer.writeln(
        <String>[
          'plan',
          _escapeCsvCell(plan.id),
          _escapeCsvCell(plan.title),
          _escapeCsvCell(plan.providerName),
          _escapeCsvCell(plan.originalAmount.toStringAsFixed(2)),
          _escapeCsvCell(plan.monthlyPaymentAmount.toStringAsFixed(2)),
          _escapeCsvCell(plan.minimumPaymentAmount.toStringAsFixed(2)),
          _escapeCsvCell(plan.paidAmount.toStringAsFixed(2)),
          _escapeCsvCell(plan.totalInstallments.toString()),
          _escapeCsvCell(plan.paidInstallments.toString()),
          _escapeCsvCell(_formatDate(plan.startDate)),
          _escapeCsvCell(plan.dueDayOfMonth.toString()),
          _escapeCsvCell(plan.status.name),
          _escapeCsvCell(plan.note ?? ''),
          _escapeCsvCell(plan.createdAt.toIso8601String()),
          _escapeCsvCell(plan.updatedAt.toIso8601String()),
        ].join(','),
      );
    }

    buffer.writeln();
    buffer.writeln(
      'invoices,id,provider_name,statement_month,statement_date,due_date,total_amount,minimum_payment_amount,paid_amount,status,note,created_at,updated_at',
    );
    for (final invoice in data.invoices) {
      buffer.writeln(
        <String>[
          'invoice',
          _escapeCsvCell(invoice.id),
          _escapeCsvCell(invoice.providerName),
          _escapeCsvCell(_formatMonth(invoice.statementMonth)),
          _escapeCsvCell(_formatDate(invoice.statementDate)),
          _escapeCsvCell(_formatDate(invoice.dueDate)),
          _escapeCsvCell(invoice.totalAmount.toStringAsFixed(2)),
          _escapeCsvCell(invoice.minimumPaymentAmount.toStringAsFixed(2)),
          _escapeCsvCell(invoice.paidAmount.toStringAsFixed(2)),
          _escapeCsvCell(invoice.status.name),
          _escapeCsvCell(invoice.note ?? ''),
          _escapeCsvCell(invoice.createdAt.toIso8601String()),
          _escapeCsvCell(invoice.updatedAt.toIso8601String()),
        ].join(','),
      );
    }

    buffer.writeln();
    buffer.writeln(
      'payments,id,target_type,target_id,payment_type,amount,paid_at,note,created_at',
    );
    for (final payment in data.payments) {
      buffer.writeln(
        <String>[
          'payment',
          _escapeCsvCell(payment.id),
          _escapeCsvCell(_paymentTargetTypeLabel(payment.targetType)),
          _escapeCsvCell(payment.targetId),
          _escapeCsvCell(payment.paymentType.name),
          _escapeCsvCell(payment.amount.toStringAsFixed(2)),
          _escapeCsvCell(_formatDateTime(payment.paidAt)),
          _escapeCsvCell(payment.note ?? ''),
          _escapeCsvCell(payment.createdAt.toIso8601String()),
        ].join(','),
      );
    }

    return buffer.toString();
  }

  String _paymentTargetTypeLabel(PayLaterTargetType targetType) {
    return switch (targetType) {
      PayLaterTargetType.installmentPlan => 'installment_plan',
      PayLaterTargetType.invoice => 'invoice',
    };
  }

  String _formatDate(DateTime value) {
    final String year = value.year.toString();
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatMonth(DateTime value) {
    final String year = value.year.toString();
    final String month = value.month.toString().padLeft(2, '0');
    return '$year-$month';
  }

  String _formatDateTime(DateTime value) {
    final String date = _formatDate(value);
    final String hour = value.hour.toString().padLeft(2, '0');
    final String minute = value.minute.toString().padLeft(2, '0');
    return '$date $hour:$minute';
  }

  String _escapeCsvCell(String value) {
    final bool needsQuote =
        value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r');

    if (!needsQuote) {
      return value;
    }

    return '"${value.replaceAll('"', '""')}"';
  }
}
