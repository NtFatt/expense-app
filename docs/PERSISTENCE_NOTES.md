# Persistence Notes

## Scope

Expense App persists local data across all supported runtime targets. The repository factory uses conditional export (`dart.library.ffi`) to separate web/test (stub path) from native FFI (native path):

| Target | FFI available? | Factory file used | Repository returned | Persistence |
|---|---|---|---|---|
| Chrome/Web | No | `repository_factory_stub.dart` | `SharedPreferencesTransactionRepository` + `SharedPreferencesPayLaterRepository` | Browser-local (SharedPreferences + JSON) |
| Flutter Tests | No | `repository_factory_stub.dart` | `InMemoryTransactionRepository` + `InMemoryPayLaterRepository` | In-memory only |
| Windows (desktop) | Yes | `repository_factory_native.dart` | `DriftTransactionRepository` + `DriftPayLaterRepository` | SQLite file (`expense_app.sqlite`) |
| Android | Yes | `repository_factory_native.dart` | `DriftTransactionRepository` + `DriftPayLaterRepository` | SQLite file (`expense_app.sqlite`) |

## Repository Factory Architecture

### Conditional export (`repository_factory.dart`)

```dart
export 'repository_factory_stub.dart'
    if (dart.library.ffi) 'repository_factory_native.dart';
```

- **Web / test VM** (no `dart:ffi`): loads `repository_factory_stub.dart`
- **Windows / Android** (FFI available): loads `repository_factory_native.dart`

### Stub factory (`repository_factory_stub.dart`)

```dart
TransactionRepository createDefaultTransactionRepository() {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    return InMemoryTransactionRepository();
  }
  return SharedPreferencesTransactionRepository();
}
```

- **Flutter tests**: `FLUTTER_TEST` is set → `InMemoryTransactionRepository` (isolated, DB-free)
- **Web runtime**: `FLUTTER_TEST` is NOT set → `SharedPreferencesTransactionRepository` (browser-local persistence)

### Native factory (`repository_factory_native.dart`)

```dart
TransactionRepository createDefaultTransactionRepository() {
  if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
    return InMemoryTransactionRepository();
  }
  return DriftTransactionRepository(getSharedAppDatabase());
}
```

- **Flutter tests on Windows** (FFI present): `FLUTTER_TEST` is set → `InMemoryTransactionRepository`
- **Windows/Android desktop run**: `kIsWeb=false`, `FLUTTER_TEST` unset → `DriftTransactionRepository`
- **Web** (native factory is never loaded — conditional export resolves to stub instead)

The same pattern applies to Pay Later via `pay_later_repository_factory.dart` / `pay_later_repository_factory_stub.dart` / `pay_later_repository_factory_native.dart`.

## Drift / SQLite on Web

`lib/core/database/app_database.dart` contains a `kIsWeb` guard at `_openConnection()`:

```dart
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Enable Drift repository after Android/Windows target is selected.',
      );
    }
    // ... NativeDatabase.createInBackground(file)
  });
}
```

Web never reaches this code because:
1. The conditional export loads the **stub** factory on web (no `dart:ffi`)
2. The stub factory returns `SharedPreferencesTransactionRepository` — never touches `AppDatabase`

## Drift / SQLite on Native (Windows/Android)

- `app_database_provider.dart` provides a shared `AppDatabase` instance via `getSharedAppDatabase()`
- `AppDatabase` stores transactions, installment plans, invoices, and payments in SQLite
- Schema version is 2; migration from v1 creates the three Pay Later tables
- Drift repository reopen is covered by `test/drift_transaction_repository_test.dart` and `test/drift_pay_later_repository_test.dart`

## Web Storage Keys

- `expense_app.web.transactions.v1`
- `expense_app.web.transactions.corrupt.v1`
- `expense_app.web.pay_later.v1`
- `expense_app.web.pay_later.corrupt.v1`

## Storage Payloads

- Transactions: `{"schemaVersion":1,"transactions":[...]}`
- Pay Later: `{"schemaVersion":1,"plans":[...],"invoices":[...],"payments":[...]}`
- Backup JSON: `{"schemaVersion":1,"app":"expense_app","exportedAt":"...","data":{...}}`

Legacy compatibility: transactions still decode the earlier raw JSON list; Pay Later still decodes the earlier unversioned object payload.

Unsupported future versions: rejected with `UnsupportedSchemaVersionException`.

Corrupt storage recovery: transactions save the raw corrupt payload to `.corrupt.v1`, then recover to seeded sample transactions; Pay Later clears to empty collections.

## Backup / Restore Interaction

Backup export uses a versioned JSON snapshot built from transactions, Pay Later plans/invoices/payments, and optional app preferences. Restore currently supports `replace all`. Merge restore is intentionally deferred.

## Automated Evidence

- `test/transaction_storage_codec_test.dart` — legacy decode, schema-v1 decode, unsupported version rejection, corrupt shape rejection
- `test/shared_preferences_transaction_repository_test.dart` — persistence across recreation, update/delete behavior, corrupt recovery + raw preservation, Vietnamese text
- `test/pay_later_storage_codec_test.dart` — legacy decode, schema-v1 decode, unsupported version rejection, corrupt shape rejection
- `test/shared_preferences_pay_later_repository_test.dart` — plan/invoice/payment persistence, corrupt recovery, Vietnamese text
- `test/app_backup_codec_test.dart` — Vietnamese backup payload, unsupported schema rejection, duplicate-id rejection, missing payment-target rejection, corrupt JSON rejection
- `test/app_backup_service_test.dart` — backup includes all data, export writes JSON, restore replaces and keeps payment effects
- `test/drift_transaction_repository_test.dart` — restart persistence and CRUD on Windows/Android
- `test/drift_pay_later_repository_test.dart` — restart persistence and CRUD on Windows/Android
- `test/transaction_repository_factory_test.dart` — FLUTTER_TEST → InMemory; native factory disjoint from SharedPreferences/InMemory (static analysis)
- `test/pay_later_repository_factory_test.dart` — FLUTTER_TEST → InMemory; native factory disjoint from SharedPreferences (static analysis)

## Manual Web Smoke — 2026-05-08

Persistence smoke: added `Web Persist Tx 20260508`, refreshed, reopened — transaction and totals persisted.

Pay Later smoke: created plan `Web Plan 20260508`, invoice `Card B`, recorded payment — all persisted through refresh/reopen.

Backup/restore smoke: exported `expense_backup_20260508_1302.json`, reset storage to empty, imported, confirmed replace dialog (5 transactions, 1 plan, 1 invoice, 1 payment), verified restored data.

Pay Later CSV/PDF smoke: downloaded and verified Vietnamese content in both artifacts.

## Remaining Risks

- Browser-local data is tied to the current browser profile/site data
- Replace-all restore is safe; merge restore not yet implemented
- Future v2+ migrations require explicit code and smoke validation
- Native Windows/Android backup import flows should still be manually smoked before claiming cross-platform portability parity
- `expense_app.exe` rebuilt successfully on `2026-05-08` (80896 bytes, 16:21 ICT) and confirmed functional (3 instances, all responding)

## Related Docs

- [STORAGE_MIGRATION_PLAN.md](STORAGE_MIGRATION_PLAN.md)
- [PROJECT_PROGRESS_CHECKLIST.md](PROJECT_PROGRESS_CHECKLIST.md)
- [RELEASE_READINESS.md](RELEASE_READINESS.md)

