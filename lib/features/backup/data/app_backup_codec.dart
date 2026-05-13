import 'dart:convert';

import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/persistence/unsupported_schema_version_exception.dart';
import 'package:expense_app/features/backup/domain/app_backup.dart';
import 'package:expense_app/features/pay_later/data/pay_later_storage_codec.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:expense_app/features/transactions/data/transaction_storage_codec.dart';

String encodeAppBackupJson(AppBackup backup) {
  return const JsonEncoder.withIndent('  ').convert(<String, Object?>{
    'schemaVersion': backup.schemaVersion,
    'app': backup.app,
    'exportedAt': backup.exportedAt.toIso8601String(),
    'data': <String, Object?>{
      'transactions': backup.data.transactions
          .map<Map<String, Object?>>(transactionToJsonMap)
          .toList(growable: false),
      'payLater': <String, Object?>{
        'plans': backup.data.payLater.plans
            .map<Map<String, Object?>>(planToJsonMap)
            .toList(growable: false),
        'invoices': backup.data.payLater.invoices
            .map<Map<String, Object?>>(invoiceToJsonMap)
            .toList(growable: false),
        'payments': backup.data.payLater.payments
            .map<Map<String, Object?>>(paymentToJsonMap)
            .toList(growable: false),
      },
      if (backup.data.preferences case final AppPreferences preferences)
        'preferences': <String, Object?>{
          'locale': preferences.locale.languageCode,
          'theme': preferences.theme.storageValue,
        },
    },
  });
}

AppBackup decodeAppBackupJson(String rawJson) {
  final Object? decoded = jsonDecode(rawJson);
  if (decoded is! Map) {
    throw const FormatException('Backup payload must be an object.');
  }

  final Map<String, Object?> root = Map<String, Object?>.from(decoded);
  final int schemaVersion = _readRequiredInt(root, 'schemaVersion');
  if (schemaVersion != appBackupSchemaVersion) {
    throw UnsupportedSchemaVersionException(
      subject: 'app backup',
      supportedVersion: appBackupSchemaVersion,
      actualVersion: schemaVersion,
    );
  }

  final String app = _readRequiredString(root, 'app');
  if (app != appBackupAppId) {
    throw FormatException('Backup app identifier must be "$appBackupAppId".');
  }

  final Map<String, Object?> data = _readRequiredMap(root, 'data');
  final List<Map<String, Object?>> rawTransactions = _readRequiredObjectList(
    data,
    'transactions',
  );
  final Map<String, Object?> rawPayLater = _readRequiredMap(data, 'payLater');
  final List<Map<String, Object?>> rawPlans = _readRequiredObjectList(
    rawPayLater,
    'plans',
  );
  final List<Map<String, Object?>> rawInvoices = _readRequiredObjectList(
    rawPayLater,
    'invoices',
  );
  final List<Map<String, Object?>> rawPayments = _readRequiredObjectList(
    rawPayLater,
    'payments',
  );

  final AppBackup backup = AppBackup(
    schemaVersion: schemaVersion,
    app: app,
    exportedAt: _readRequiredDateTime(root, 'exportedAt'),
    data: AppBackupData(
      transactions: rawTransactions
          .map(transactionFromJsonMap)
          .toList(growable: false),
      payLater: AppBackupPayLaterData(
        plans: rawPlans.map(planFromJsonMap).toList(growable: false),
        invoices: rawInvoices.map(invoiceFromJsonMap).toList(growable: false),
        payments: rawPayments.map(paymentFromJsonMap).toList(growable: false),
      ),
      preferences: _readPreferences(data),
    ),
  );

  _validateUniqueIds(
    label: 'transaction',
    ids: backup.data.transactions.map((item) => item.id),
  );
  _validateUniqueIds(
    label: 'installment plan',
    ids: backup.data.payLater.plans.map((item) => item.id),
  );
  _validateUniqueIds(
    label: 'pay later invoice',
    ids: backup.data.payLater.invoices.map((item) => item.id),
  );
  _validateUniqueIds(
    label: 'pay later payment',
    ids: backup.data.payLater.payments.map((item) => item.id),
  );
  _validatePayLaterPaymentTargets(backup);

  return backup;
}

AppPreferences? _readPreferences(Map<String, Object?> data) {
  final Object? value = data['preferences'];
  if (value == null) {
    return null;
  }
  if (value is! Map) {
    throw const FormatException('Backup preferences must be an object.');
  }

  final Map<String, Object?> preferencesMap = Map<String, Object?>.from(value);
  final String localeCode = _readRequiredString(preferencesMap, 'locale');
  final String themeValue = _readRequiredString(preferencesMap, 'theme');

  final AppLocale locale = AppLocale.values.firstWhere(
    (AppLocale item) => item.languageCode == localeCode,
    orElse: () =>
        throw FormatException('Unsupported backup locale value: $localeCode.'),
  );
  final AppThemePreference theme = AppThemePreference.values.firstWhere(
    (AppThemePreference item) => item.storageValue == themeValue,
    orElse: () =>
        throw FormatException('Unsupported backup theme value: $themeValue.'),
  );

  return AppPreferences(locale: locale, theme: theme);
}

void _validateUniqueIds({
  required String label,
  required Iterable<String> ids,
}) {
  final Set<String> seen = <String>{};
  for (final String id in ids) {
    if (!seen.add(id)) {
      throw FormatException('Duplicate $label id detected: $id.');
    }
  }
}

void _validatePayLaterPaymentTargets(AppBackup backup) {
  final Set<String> planIds = backup.data.payLater.plans
      .map((item) => item.id)
      .toSet();
  final Set<String> invoiceIds = backup.data.payLater.invoices
      .map((item) => item.id)
      .toSet();

  for (final payment in backup.data.payLater.payments) {
    final bool isValid = switch (payment.targetType) {
      PayLaterTargetType.installmentPlan => planIds.contains(payment.targetId),
      PayLaterTargetType.invoice => invoiceIds.contains(payment.targetId),
    };
    if (!isValid) {
      throw FormatException(
        'Payment ${payment.id} points to missing target ${payment.targetId}.',
      );
    }
  }
}

Map<String, Object?> _readRequiredMap(
  Map<String, Object?> jsonMap,
  String key,
) {
  final Object? value = jsonMap[key];
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }

  throw FormatException('Backup field "$key" must be an object.');
}

List<Map<String, Object?>> _readRequiredObjectList(
  Map<String, Object?> jsonMap,
  String key,
) {
  final Object? value = jsonMap[key];
  if (value is! List) {
    throw FormatException('Backup field "$key" must be a list.');
  }

  return value
      .map<Map<String, Object?>>((Object? item) {
        if (item is! Map) {
          throw FormatException('Backup list "$key" must contain objects.');
        }
        return Map<String, Object?>.from(item);
      })
      .toList(growable: false);
}

String _readRequiredString(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is String) {
    return value;
  }

  throw FormatException('Backup field "$key" must be a string.');
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

  throw FormatException('Backup field "$key" must be an integer.');
}

DateTime _readRequiredDateTime(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is String) {
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }

  throw FormatException('Backup field "$key" must be an ISO date.');
}
