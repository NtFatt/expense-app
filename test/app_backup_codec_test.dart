import 'dart:convert';

import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/persistence/unsupported_schema_version_exception.dart';
import 'package:expense_app/features/backup/data/app_backup_codec.dart';
import 'package:expense_app/features/backup/domain/app_backup.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_data/backup_fixture.dart';

void main() {
  group('AppBackupCodec', () {
    test('encodes and decodes Vietnamese content with preferences', () {
      final AppBackup backup = buildBackupFixture();

      final String encoded = encodeAppBackupJson(backup);
      final AppBackup decoded = decodeAppBackupJson(encoded);

      expect(decoded.app, appBackupAppId);
      expect(decoded.schemaVersion, appBackupSchemaVersion);
      expect(decoded.data.transactions.single.category, 'Ăn uống');
      expect(decoded.data.transactions.single.note, 'Bữa trưa văn phòng');
      expect(decoded.data.payLater.plans.single.title, 'Trả góp điện thoại');
      expect(
        decoded.data.payLater.invoices.single.providerName,
        'Thẻ tín dụng Nội địa',
      );
      expect(decoded.data.payLater.payments.single.note, 'Đóng tối thiểu');
      expect(decoded.data.preferences?.locale, AppLocale.en);
      expect(decoded.data.preferences?.theme, AppThemePreference.dark);
    });

    test('rejects unsupported schema version with typed exception', () {
      final Map<String, Object?> payload = Map<String, Object?>.from(
        jsonDecode(encodeAppBackupJson(buildBackupFixture())) as Map,
      )..['schemaVersion'] = 99;

      expect(
        () => decodeAppBackupJson(jsonEncode(payload)),
        throwsA(isA<UnsupportedSchemaVersionException>()),
      );
    });

    test('rejects duplicate transaction ids', () {
      final AppBackup backup = buildBackupFixture();
      final Map<String, Object?> payload = Map<String, Object?>.from(
        jsonDecode(encodeAppBackupJson(backup)) as Map,
      );
      final Map<String, Object?> data = Map<String, Object?>.from(
        payload['data'] as Map,
      );
      final List<Object?> transactions = List<Object?>.from(
        data['transactions'] as List,
      );
      transactions.add(Map<String, Object?>.from(transactions.first as Map));
      data['transactions'] = transactions;
      payload['data'] = data;

      expect(
        () => decodeAppBackupJson(jsonEncode(payload)),
        throwsFormatException,
      );
    });

    test('rejects payments with missing targets', () {
      final AppBackup backup = buildBackupFixture();
      final Map<String, Object?> payload = Map<String, Object?>.from(
        jsonDecode(encodeAppBackupJson(backup)) as Map,
      );
      final Map<String, Object?> data = Map<String, Object?>.from(
        payload['data'] as Map,
      );
      final Map<String, Object?> payLater = Map<String, Object?>.from(
        data['payLater'] as Map,
      );
      payLater['payments'] = <Map<String, Object?>>[
        <String, Object?>{
          'id': 'broken_payment',
          'targetId': 'missing_invoice',
          'targetType': 'invoice',
          'amount': 80,
          'paymentType': 'customPayment',
          'paidAt': '2026-05-08T10:00:00.000',
          'note': 'Sai đích',
          'createdAt': '2026-05-08T10:00:00.000',
        },
      ];
      data['payLater'] = payLater;
      payload['data'] = data;

      expect(
        () => decodeAppBackupJson(jsonEncode(payload)),
        throwsFormatException,
      );
    });

    test('rejects corrupt json gracefully', () {
      expect(() => decodeAppBackupJson('{bad json'), throwsFormatException);
    });
  });
}
