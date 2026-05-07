class PayLaterSummary {
  const PayLaterSummary({
    required this.totalOutstanding,
    required this.totalMinimumDue,
    required this.totalPaidThisMonth,
    required this.activeInstallmentCount,
    required this.unpaidInvoiceCount,
    required this.overdueCount,
    required this.dueSoonCount,
    required this.nextDueDate,
    required this.nextDueAmount,
  });

  static const PayLaterSummary empty = PayLaterSummary(
    totalOutstanding: 0,
    totalMinimumDue: 0,
    totalPaidThisMonth: 0,
    activeInstallmentCount: 0,
    unpaidInvoiceCount: 0,
    overdueCount: 0,
    dueSoonCount: 0,
    nextDueDate: null,
    nextDueAmount: 0,
  );

  final double totalOutstanding;
  final double totalMinimumDue;
  final double totalPaidThisMonth;
  final int activeInstallmentCount;
  final int unpaidInvoiceCount;
  final int overdueCount;
  final int dueSoonCount;
  final DateTime? nextDueDate;
  final double nextDueAmount;

  bool get hasUpcomingDue => nextDueDate != null && nextDueAmount > 0;
}
