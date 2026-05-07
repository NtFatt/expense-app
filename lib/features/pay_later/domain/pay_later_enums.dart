enum InstallmentStatus { active, dueSoon, overdue, settled, cancelled }

enum PayLaterInvoiceStatus { unpaid, partiallyPaid, paid, overdue }

enum PayLaterPaymentType { minimumPayment, customPayment, fullSettlement }

enum PayLaterTargetType { installmentPlan, invoice }

enum PolicySeverity { info, warning, critical }

extension InstallmentStatusCodec on InstallmentStatus {
  static InstallmentStatus fromName(String value) {
    return _enumByNameOrFallback(
      InstallmentStatus.values,
      value,
      InstallmentStatus.active,
    );
  }
}

extension PayLaterInvoiceStatusCodec on PayLaterInvoiceStatus {
  static PayLaterInvoiceStatus fromName(String value) {
    return _enumByNameOrFallback(
      PayLaterInvoiceStatus.values,
      value,
      PayLaterInvoiceStatus.unpaid,
    );
  }
}

extension PayLaterPaymentTypeCodec on PayLaterPaymentType {
  static PayLaterPaymentType fromName(String value) {
    return _enumByNameOrFallback(
      PayLaterPaymentType.values,
      value,
      PayLaterPaymentType.customPayment,
    );
  }
}

extension PayLaterTargetTypeCodec on PayLaterTargetType {
  static PayLaterTargetType fromName(String value) {
    return _enumByNameOrFallback(
      PayLaterTargetType.values,
      value,
      PayLaterTargetType.installmentPlan,
    );
  }
}

T _enumByNameOrFallback<T extends Enum>(
  List<T> values,
  String value,
  T fallback,
) {
  for (final T candidate in values) {
    if (candidate.name == value) {
      return candidate;
    }
  }
  return fallback;
}
