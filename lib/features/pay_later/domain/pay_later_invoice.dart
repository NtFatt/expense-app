import 'dart:math' as math;

import 'pay_later_enums.dart';

const Object _payLaterInvoiceCopySentinel = Object();

class PayLaterInvoice {
  const PayLaterInvoice({
    required this.id,
    required this.providerName,
    required this.statementMonth,
    required this.statementDate,
    required this.dueDate,
    required this.totalAmount,
    required this.minimumPaymentAmount,
    required this.paidAmount,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(totalAmount >= 0),
       assert(minimumPaymentAmount >= 0),
       assert(paidAmount >= 0);

  final String id;
  final String providerName;
  final DateTime statementMonth;
  final DateTime statementDate;
  final DateTime dueDate;
  final double totalAmount;
  final double minimumPaymentAmount;
  final double paidAmount;
  final PayLaterInvoiceStatus status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get outstandingAmount => math.max(0, totalAmount - paidAmount);

  double get minimumAmountDue {
    if (outstandingAmount <= 0) {
      return 0;
    }

    return math.min(outstandingAmount, minimumPaymentAmount);
  }

  bool get isPaid => outstandingAmount <= 0.0001;

  bool isOverdue(DateTime now) {
    if (isPaid) {
      return false;
    }

    return _startOfDay(dueDate).isBefore(_startOfDay(now));
  }

  bool isDueSoon(DateTime now, {int withinDays = 3}) {
    if (isPaid || isOverdue(now)) {
      return false;
    }

    final int difference = _startOfDay(
      dueDate,
    ).difference(_startOfDay(now)).inDays;
    return difference >= 0 && difference <= withinDays;
  }

  PayLaterInvoiceStatus effectiveStatus(DateTime now) {
    if (isPaid) {
      return PayLaterInvoiceStatus.paid;
    }

    if (isOverdue(now)) {
      return PayLaterInvoiceStatus.overdue;
    }

    if (paidAmount > 0) {
      return PayLaterInvoiceStatus.partiallyPaid;
    }

    return PayLaterInvoiceStatus.unpaid;
  }

  PayLaterInvoice copyWith({
    String? id,
    String? providerName,
    DateTime? statementMonth,
    DateTime? statementDate,
    DateTime? dueDate,
    double? totalAmount,
    double? minimumPaymentAmount,
    double? paidAmount,
    PayLaterInvoiceStatus? status,
    Object? note = _payLaterInvoiceCopySentinel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PayLaterInvoice(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      statementMonth: statementMonth ?? this.statementMonth,
      statementDate: statementDate ?? this.statementDate,
      dueDate: dueDate ?? this.dueDate,
      totalAmount: totalAmount ?? this.totalAmount,
      minimumPaymentAmount: minimumPaymentAmount ?? this.minimumPaymentAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      status: status ?? this.status,
      note: identical(note, _payLaterInvoiceCopySentinel)
          ? this.note
          : note as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
