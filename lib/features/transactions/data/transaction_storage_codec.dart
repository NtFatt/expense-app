import 'dart:convert';

import 'package:expense_app/core/persistence/unsupported_schema_version_exception.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';

const int transactionStorageSchemaVersion = 1;

const String _schemaVersionKey = 'schemaVersion';
const String _transactionsKey = 'transactions';

String encodeTransactionsJson(List<TransactionModel> transactions) {
  return jsonEncode(<String, Object?>{
    _schemaVersionKey: transactionStorageSchemaVersion,
    _transactionsKey: transactions
        .map<Map<String, Object?>>(transactionToJsonMap)
        .toList(growable: false),
  });
}

List<TransactionModel> decodeTransactionsJson(String rawJson) {
  final Object? decoded = jsonDecode(rawJson);
  // Accept the legacy list payload so existing browsers keep working until the
  // next write upgrades the stored snapshot to the versioned shape.
  final List<Object?> rawTransactions;
  if (decoded is List) {
    rawTransactions = decoded.cast<Object?>();
  } else if (decoded is Map) {
    final Map<String, Object?> jsonMap = Map<String, Object?>.from(decoded);
    final int schemaVersion = _readSchemaVersion(jsonMap);
    if (schemaVersion != transactionStorageSchemaVersion) {
      throw UnsupportedSchemaVersionException(
        subject: 'transaction storage',
        supportedVersion: transactionStorageSchemaVersion,
        actualVersion: schemaVersion,
      );
    }
    rawTransactions = _readList(jsonMap, _transactionsKey);
  } else {
    throw const FormatException(
      'Transaction storage payload must be a list or object.',
    );
  }

  return rawTransactions
      .map<TransactionModel>((Object? item) {
        if (item is! Map) {
          throw const FormatException(
            'Transaction storage item must be an object.',
          );
        }

        return transactionFromJsonMap(Map<String, Object?>.from(item));
      })
      .toList(growable: false);
}

int _readSchemaVersion(Map<String, Object?> jsonMap) {
  final Object? value = jsonMap[_schemaVersionKey];
  if (value == null) {
    return transactionStorageSchemaVersion;
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
    'Transaction storage schemaVersion must be an integer.',
  );
}

List<Object?> _readList(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is List) {
    return value;
  }

  throw FormatException('Transaction field "$key" must be a list.');
}

Map<String, Object?> transactionToJsonMap(TransactionModel transaction) {
  return <String, Object?>{
    'id': transaction.id,
    'type': transaction.type.name,
    'amount': transaction.amount,
    'category': transaction.category,
    'note': transaction.note,
    'transactionDate': transaction.transactionDate.toIso8601String(),
    'createdAt': transaction.createdAt.toIso8601String(),
    'updatedAt': transaction.updatedAt.toIso8601String(),
  };
}

TransactionModel transactionFromJsonMap(Map<String, Object?> jsonMap) {
  return TransactionModel(
    id: _readRequiredString(jsonMap, 'id'),
    type: TransactionType.fromName(_readRequiredString(jsonMap, 'type')),
    amount: _readRequiredInt(jsonMap, 'amount'),
    category: _readRequiredString(jsonMap, 'category'),
    note: _readNullableString(jsonMap, 'note'),
    transactionDate: _readRequiredDateTime(jsonMap, 'transactionDate'),
    createdAt: _readRequiredDateTime(jsonMap, 'createdAt'),
    updatedAt: _readRequiredDateTime(jsonMap, 'updatedAt'),
  );
}

String _readRequiredString(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is String) {
    return value;
  }

  throw FormatException('Transaction field "$key" must be a string.');
}

String? _readNullableString(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return value;
  }

  throw FormatException('Transaction field "$key" must be a string or null.');
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

  throw FormatException('Transaction field "$key" must be an integer.');
}

DateTime _readRequiredDateTime(Map<String, Object?> jsonMap, String key) {
  final Object? value = jsonMap[key];
  if (value is String) {
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }

  throw FormatException('Transaction field "$key" must be an ISO date.');
}
