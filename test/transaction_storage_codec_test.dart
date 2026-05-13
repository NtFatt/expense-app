import 'dart:convert';

import 'package:expense_app/core/persistence/unsupported_schema_version_exception.dart';
import 'package:expense_app/features/transactions/data/transaction_storage_codec.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('transaction_storage_codec', () {
    test('encodes schemaVersion and round-trips Vietnamese content', () {
      final TransactionModel transaction = _buildTransaction();

      final String encoded = encodeTransactionsJson(<TransactionModel>[
        transaction,
      ]);
      final Map<String, Object?> payload = Map<String, Object?>.from(
        jsonDecode(encoded) as Map,
      );

      expect(payload['schemaVersion'], transactionStorageSchemaVersion);
      expect(payload['transactions'], isA<List<Object?>>());

      final List<TransactionModel> decoded = decodeTransactionsJson(encoded);
      expect(decoded, hasLength(1));
      expect(decoded.single.category, 'Ăn uống');
      expect(decoded.single.note, 'Bữa trưa văn phòng');
    });

    test('decodes legacy list payload without schemaVersion', () {
      final String legacyPayload = jsonEncode(<Map<String, Object?>>[
        <String, Object?>{
          'id': 'legacy_tx_1',
          'type': 'expense',
          'amount': 54000,
          'category': 'Ăn uống',
          'note': 'Phở bò',
          'transactionDate': '2026-05-08T09:00:00.000',
          'createdAt': '2026-05-08T09:00:00.000',
          'updatedAt': '2026-05-08T09:00:00.000',
        },
      ]);

      final List<TransactionModel> decoded = decodeTransactionsJson(
        legacyPayload,
      );

      expect(decoded, hasLength(1));
      expect(decoded.single.id, 'legacy_tx_1');
      expect(decoded.single.note, 'Phở bò');
    });

    test('throws gracefully for corrupt payload shape', () {
      expect(
        () => decodeTransactionsJson(
          '{"schemaVersion":1,"transactions":{"id":"broken"}}',
        ),
        throwsFormatException,
      );
    });

    test('rejects unsupported future schema version', () {
      expect(
        () => decodeTransactionsJson('{"schemaVersion":9,"transactions":[]}'),
        throwsA(isA<UnsupportedSchemaVersionException>()),
      );
    });
  });
}

TransactionModel _buildTransaction() {
  final DateTime now = DateTime(2026, 5, 8, 9, 0);
  return TransactionModel(
    id: 'codec_tx_1',
    type: TransactionType.expense,
    amount: 54000,
    category: 'Ăn uống',
    note: 'Bữa trưa văn phòng',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );
}
