import 'dart:math' as math;

import 'pay_later_enums.dart';

const Object _installmentPlanCopySentinel = Object();

class InstallmentPlan {
  const InstallmentPlan({
    required this.id,
    required this.title,
    required this.providerName,
    required this.originalAmount,
    required this.monthlyPaymentAmount,
    required this.minimumPaymentAmount,
    required this.paidAmount,
    required this.totalInstallments,
    required this.paidInstallments,
    required this.startDate,
    required this.dueDayOfMonth,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(originalAmount >= 0),
       assert(monthlyPaymentAmount >= 0),
       assert(minimumPaymentAmount >= 0),
       assert(paidAmount >= 0),
       assert(totalInstallments >= 0),
       assert(paidInstallments >= 0),
       assert(dueDayOfMonth >= 1),
       assert(dueDayOfMonth <= 31);

  final String id;
  final String title;
  final String providerName;
  final double originalAmount;
  final double monthlyPaymentAmount;
  final double minimumPaymentAmount;
  final double paidAmount;
  final int totalInstallments;
  final int paidInstallments;
  final DateTime startDate;
  final int dueDayOfMonth;
  final InstallmentStatus status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get outstandingAmount => math.max(0, originalAmount - paidAmount);

  double get minimumAmountDue {
    if (outstandingAmount <= 0) {
      return 0;
    }

    final double baseline = minimumPaymentAmount > 0
        ? minimumPaymentAmount
        : monthlyPaymentAmount;
    return math.min(outstandingAmount, baseline);
  }

  int get remainingInstallments =>
      math.max(0, totalInstallments - paidInstallments);

  double get progressPercent {
    if (totalInstallments > 0) {
      return (paidInstallments / totalInstallments).clamp(0.0, 1.0);
    }

    if (originalAmount <= 0) {
      return isFullyPaid ? 1 : 0;
    }

    return (paidAmount / originalAmount).clamp(0.0, 1.0);
  }

  bool get isFullyPaid =>
      outstandingAmount <= 0.0001 ||
      (totalInstallments > 0 && paidInstallments >= totalInstallments);

  DateTime get nextDueDate {
    final int dueNumber = isFullyPaid
        ? math.max(totalInstallments, 1)
        : paidInstallments + 1;
    return _dueDateForInstallment(dueNumber);
  }

  bool isOverdue(DateTime now) {
    if (status == InstallmentStatus.cancelled || isFullyPaid) {
      return false;
    }

    return _startOfDay(nextDueDate).isBefore(_startOfDay(now));
  }

  bool isDueSoon(DateTime now, {int withinDays = 3}) {
    if (status == InstallmentStatus.cancelled ||
        isFullyPaid ||
        isOverdue(now)) {
      return false;
    }

    final int difference = _startOfDay(
      nextDueDate,
    ).difference(_startOfDay(now)).inDays;
    return difference >= 0 && difference <= withinDays;
  }

  InstallmentStatus effectiveStatus(DateTime now) {
    if (status == InstallmentStatus.cancelled) {
      return InstallmentStatus.cancelled;
    }

    if (isFullyPaid) {
      return InstallmentStatus.settled;
    }

    if (isOverdue(now)) {
      return InstallmentStatus.overdue;
    }

    if (isDueSoon(now)) {
      return InstallmentStatus.dueSoon;
    }

    return InstallmentStatus.active;
  }

  InstallmentPlan copyWith({
    String? id,
    String? title,
    String? providerName,
    double? originalAmount,
    double? monthlyPaymentAmount,
    double? minimumPaymentAmount,
    double? paidAmount,
    int? totalInstallments,
    int? paidInstallments,
    DateTime? startDate,
    int? dueDayOfMonth,
    InstallmentStatus? status,
    Object? note = _installmentPlanCopySentinel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InstallmentPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      providerName: providerName ?? this.providerName,
      originalAmount: originalAmount ?? this.originalAmount,
      monthlyPaymentAmount: monthlyPaymentAmount ?? this.monthlyPaymentAmount,
      minimumPaymentAmount: minimumPaymentAmount ?? this.minimumPaymentAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      paidInstallments: paidInstallments ?? this.paidInstallments,
      startDate: startDate ?? this.startDate,
      dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
      status: status ?? this.status,
      note: identical(note, _installmentPlanCopySentinel)
          ? this.note
          : note as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DateTime _dueDateForInstallment(int installmentNumber) {
    final int normalizedInstallmentNumber = math.max(installmentNumber, 1);
    final int initialMonthOffset = startDate.day <= dueDayOfMonth ? 0 : 1;
    final int monthOffset =
        initialMonthOffset + normalizedInstallmentNumber - 1;
    final int zeroBasedMonth = startDate.month - 1 + monthOffset;
    final int year = startDate.year + zeroBasedMonth ~/ 12;
    final int month = zeroBasedMonth % 12 + 1;
    final int safeDay = math.min(
      math.max(dueDayOfMonth, 1),
      DateTime(year, month + 1, 0).day,
    );

    return DateTime(year, month, safeDay);
  }

  static DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
