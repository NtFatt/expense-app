import 'dart:convert';

import 'package:expense_app/core/persistence/unsupported_schema_version_exception.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';

const int payLaterStorageSchemaVersion = 1;

const String _schemaVersionKey = 'schemaVersion';

String encodePayLaterStorageJson({
  required List<InstallmentPlan> plans,
  required List<PayLaterInvoice> invoices,
  required List<PayLaterPayment> payments,
}) {
  return jsonEncode(<String, Object?>{
    _schemaVersionKey: payLaterStorageSchemaVersion,
    'plans': plans
        .map<Map<String, Object?>>(planToJsonMap)
        .toList(growable: false),
    'invoices': invoices
        .map<Map<String, Object?>>(invoiceToJsonMap)
        .toList(growable: false),
    'payments': payments
        .map<Map<String, Object?>>(paymentToJsonMap)
        .toList(growable: false),
  });
}

({
  List<InstallmentPlan> plans,
  List<PayLaterInvoice> invoices,
  List<PayLaterPayment> payments,
})
decodePayLaterStorageJson(String rawJson) {
  final Object? decoded = jsonDecode(rawJson);
  if (decoded is! Map) {
    throw const FormatException('Pay Later storage payload must be an object.');
  }

  final Map<String, Object?> jsonMap = Map<String, Object?>.from(decoded);
  final int schemaVersion = _readSchemaVersion(jsonMap);
  if (schemaVersion != payLaterStorageSchemaVersion) {
    throw UnsupportedSchemaVersionException(
      subject: 'Pay Later storage',
      supportedVersion: payLaterStorageSchemaVersion,
      actualVersion: schemaVersion,
    );
  }
  return (
    plans: _readList(jsonMap, 'plans')
        .map<InstallmentPlan>((Object? item) {
          if (item is! Map) {
            throw const FormatException(
              'Installment plan item must be an object.',
            );
          }
          return planFromJsonMap(Map<String, Object?>.from(item));
        })
        .toList(growable: false),
    invoices: _readList(jsonMap, 'invoices')
        .map<PayLaterInvoice>((Object? item) {
          if (item is! Map) {
            throw const FormatException('Invoice item must be an object.');
          }
          return invoiceFromJsonMap(Map<String, Object?>.from(item));
        })
        .toList(growable: false),
    payments: _readList(jsonMap, 'payments')
        .map<PayLaterPayment>((Object? item) {
          if (item is! Map) {
            throw const FormatException('Payment item must be an object.');
          }
          return paymentFromJsonMap(Map<String, Object?>.from(item));
        })
        .toList(growable: false),
  );
}

int _readSchemaVersion(Map<String, Object?> jsonMap) {
  final Object? value = jsonMap[_schemaVersionKey];
  if (value == null) {
    return payLaterStorageSchemaVersion;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    final int? parsed = int.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }

  throw const FormatException(
    'Pay Later storage schemaVersion must be an integer.',
  );
}

Map<String, Object?> planToJsonMap(InstallmentPlan plan) {
  return <String, Object?>{
    'id': plan.id,
    'title': plan.title,
    'providerName': plan.providerName,
    'originalAmount': plan.originalAmount,
    'monthlyPaymentAmount': plan.monthlyPaymentAmount,
    'minimumPaymentAmount': plan.minimumPaymentAmount,
    'paidAmount': plan.paidAmount,
    'totalInstallments': plan.totalInstallments,
    'paidInstallments': plan.paidInstallments,
    'startDate': plan.startDate.toIso8601String(),
    'dueDayOfMonth': plan.dueDayOfMonth,
    'status': plan.status.name,
    'note': plan.note,
    'createdAt': plan.createdAt.toIso8601String(),
    'updatedAt': plan.updatedAt.toIso8601String(),
  };
}

Map<String, Object?> invoiceToJsonMap(PayLaterInvoice invoice) {
  return <String, Object?>{
    'id': invoice.id,
    'providerName': invoice.providerName,
    'statementMonth': invoice.statementMonth.toIso8601String(),
    'statementDate': invoice.statementDate.toIso8601String(),
    'dueDate': invoice.dueDate.toIso8601String(),
    'totalAmount': invoice.totalAmount,
    'minimumPaymentAmount': invoice.minimumPaymentAmount,
    'paidAmount': invoice.paidAmount,
    'status': invoice.status.name,
    'note': invoice.note,
    'createdAt': invoice.createdAt.toIso8601String(),
    'updatedAt': invoice.updatedAt.toIso8601String(),
  };
}

Map<String, Object?> paymentToJsonMap(PayLaterPayment payment) {
  return <String, Object?>{
    'id': payment.id,
    'targetId': payment.targetId,
    'targetType': payment.targetType.name,
    'amount': payment.amount,
    'paymentType': payment.paymentType.name,
    'paidAt': payment.paidAt.toIso8601String(),
    'note': payment.note,
    'createdAt': payment.createdAt.toIso8601String(),
  };
}

InstallmentPlan planFromJsonMap(Map<String, Object?> jsonMap) {
  return InstallmentPlan(
    id: _readRequiredString(jsonMap, 'id'),
    title: _readRequiredString(jsonMap, 'title'),
    providerName: _readRequiredString(jsonMap, 'providerName'),
    originalAmount: _readRequiredDouble(jsonMap, 'originalAmount'),
    monthlyPaymentAmount: _readRequiredDouble(jsonMap, 'monthlyPaymentAmount'),
    minimumPaymentAmount: _readRequiredDouble(jsonMap, 'minimumPaymentAmount'),
    paidAmount: _readRequiredDouble(jsonMap, 'paidAmount'),
    totalInstallments: _readRequiredInt(jsonMap, 'totalInstallments'),
    paidInstallments: _readRequiredInt(jsonMap, 'paidInstallments'),
    startDate: _readRequiredDateTime(jsonMap, 'startDate'),
    dueDayOfMonth: _readRequiredInt(jsonMap, 'dueDayOfMonth'),
    status: InstallmentStatusCodec.fromName(
      _readRequiredString(jsonMap, 'status'),
    ),
    note: _readNullableString(jsonMap, 'note'),
    createdAt: _readRequiredDateTime(jsonMap, 'createdAt'),
    updatedAt: _readRequiredDateTime(jsonMap, 'updatedAt'),
  );
}

PayLaterInvoice invoiceFromJsonMap(Map<String, Object?> jsonMap) {
  return PayLaterInvoice(
    id: _readRequiredString(jsonMap, 'id'),
    providerName: _readRequiredString(jsonMap, 'providerName'),
    statementMonth: _readRequiredDateTime(jsonMap, 'statementMonth'),
    statementDate: _readRequiredDateTime(jsonMap, 'statementDate'),
    dueDate: _readRequiredDateTime(jsonMap, 'dueDate'),
    totalAmount: _readRequiredDouble(jsonMap, 'totalAmount'),
    minimumPaymentAmount: _readRequiredDouble(jsonMap, 'minimumPaymentAmount'),
    paidAmount: _readRequiredDouble(jsonMap, 'paidAmount'),
    status: PayLaterInvoiceStatusCodec.fromName(
      _readRequiredString(jsonMap, 'status'),
    ),
    note: _readNullableString(jsonMap, 'note'),
    createdAt: _readRequiredDateTime(jsonMap, 'createdAt'),
    updatedAt: _readRequiredDateTime(jsonMap, 'updatedAt'),
  );
}

PayLaterPayment paymentFromJsonMap(Map<String, Object?> jsonMap) {
  return PayLaterPayment(
    id: _readRequiredString(jsonMap, 'id'),
    targetId: _readRequiredString(jsonMap, 'targetId'),
    targetType: PayLaterTargetTypeCodec.fromName(
      _readRequiredString(jsonMap, 'targetType'),
    ),
    amount: _readRequiredDouble(jsonMap, 'amount'),
    paymentType: PayLaterPaymentTypeCodec.fromName(
      _readRequiredString(jsonMap, 'paymentType'),
    ),
    paidAt: _readRequiredDateTime(jsonMap, 'paidAt'),
    note: _readNullableString(jsonMap, 'note'),
    createdAt: _readRequiredDateTime(jsonMap, 'createdAt'),
  );
}

List<Object?> _readList(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is List) {
    return value;
  }

  throw FormatException('Pay Later field "$key" must be a list.');
}

String _readRequiredString(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is String) {
    return value;
  }

  throw FormatException('Pay Later field "$key" must be a string.');
}

String? _readNullableString(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return value;
  }

  throw FormatException('Pay Later field "$key" must be a string or null.');
}

int _readRequiredInt(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    final int? parsed = int.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }

  throw FormatException('Pay Later field "$key" must be an integer.');
}

double _readRequiredDouble(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    final double? parsed = double.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }

  throw FormatException('Pay Later field "$key" must be a number.');
}

DateTime _readRequiredDateTime(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is String) {
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }

  throw FormatException('Pay Later field "$key" must be an ISO date.');
}
