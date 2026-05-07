# Phase 8D — Persistence Hardening, Migration, Documentation

> Historical native-persistence closeout from 2026-05-03. For the current canonical persistence policy and Phase 8 reconciliation, see `docs/PHASE_8_STATUS_RECONCILIATION.md` and `docs/PROJECT_PROGRESS_CHECKLIST.md`.

**Date:** 2026-05-03
**Auditor:** Senior Flutter Engineer (Phase 8D autonomous review)
**Scope:** Final sub-phase to close Phase 8 — hardening, migration strategy, and documentation

---

## 1. Summary

- **Web repository:** `InMemoryTransactionRepository` (by design)
- **Native repository:** `DriftTransactionRepository(AppDatabase())` (verified)
- **Persistence target verified:** Windows native — Phase 8C PASS
- **Phase 8 status:** COMPLETE (8A audit + 8B switching + 8C QA + 8D hardening/docs)

---

## 2. Current Persistence Architecture

### 2.1 Conditional Import Gate

The repository factory uses Dart's conditional import to completely eliminate native code from the web compilation tree:

```
repository_factory.dart
  └── repository_factory_stub.dart  (web: returns InMemory)
  └── repository_factory_native.dart (native: returns Drift)
```

**How it works:**

- `repository_factory.dart` exports `repository_factory_stub.dart` by default.
- On native targets (where `dart.library.ffi` is available), the compiler substitutes `repository_factory_native.dart` instead.
- This is a **compile-time** decision — `app_database.dart` and `drift_transaction_repository.dart` never enter the web bundle.
- `transaction_controller.dart` calls `createDefaultTransactionRepository()` from the conditional import, fully unaware of which implementation is selected.

### 2.2 Platform-Specific Behavior

| Platform | Repository | Data file | Survives restart |
|----------|-----------|-----------|-----------------|
| Chrome/Web | `InMemoryTransactionRepository` | None (in-process memory) | No |
| Windows | `DriftTransactionRepository(AppDatabase())` | `expense_app.sqlite` in AppDocuments | **Yes** |
| Android | `DriftTransactionRepository(AppDatabase())` | SQLite in app storage | **Yes** (pending QA) |

### 2.3 Web Safety

- `app_database.dart` contains `dart:io` and `package:drift/native.dart` — both web-incompatible.
- These are excluded from the web compilation via conditional import.
- Additionally, `_openConnection()` has a runtime `kIsWeb` guard that throws `UnsupportedError` if ever reached.
- Widget tests override `transactionRepositoryProvider` with `InMemoryTransactionRepository` — no native DB in tests.

---

## 3. Database Schema

### 3.1 Table: `transactions`

| Column | Type | Constraints |
|--------|------|-------------|
| `id` | TEXT | PRIMARY KEY |
| `type` | TEXT | NOT NULL |
| `amount` | INTEGER | NOT NULL |
| `category` | TEXT | NOT NULL |
| `note` | TEXT | NULLABLE |
| `transactionDate` | DATETIME | NOT NULL |
| `createdAt` | DATETIME | NOT NULL |
| `updatedAt` | DATETIME | NOT NULL |

### 3.2 Schema Metadata

- **schemaVersion:** `1`
- **Generated file:** `lib/core/database/app_database.g.dart` (794 lines, auto-generated)
- **Migration needed:** No — current schema is initial; no changes made since generation
- **Last regenerated:** Phase 5 scaffold

### 3.3 Regeneration Rule

Do **not** manually edit `app_database.g.dart`. To regenerate after a schema change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Then validate with `flutter analyze` and `flutter test`.

---

## 4. Migration Strategy

### 4.1 Current State

- `schemaVersion = 1` — initial schema, no previous versions.
- No migrations defined.
- All data is app-generated (no manual DB edits or external writers).

### 4.2 Future Migration Rule

When any table change is required (add column, rename column, change type, drop column):

1. **Bump `schemaVersion`** in `AppDatabase`:
   ```dart
   @override
   int get schemaVersion => 2; // increment
   ```

2. **Add a migration** by overriding `migration` in `AppDatabase`:
   ```dart
   @override
   MigrationStrategy get migration {
     return MigrationStrategy(
       onCreate: (Migrator m) async {
         await m.createAll();
       },
       onUpgrade: (Migrator m, int from, int to) async {
         if (from == 1 && to == 2) {
           // migration steps here
         }
       },
     );
   }
   ```

3. **Regenerate Drift code:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Validate:**
   ```bash
   flutter analyze
   flutter test
   flutter run -d windows
   ```

### 4.3 Constraints

- Never manually edit `app_database.g.dart`.
- Never skip schemaVersion bumps — Drift requires sequential migrations.
- Test migrations on a copy of real data before shipping.
- If a migration fails in production, the app will throw at startup.

### 4.4 Schema-Free Path

If schema changes are minimal and data loss is acceptable for the MVP, an alternative is to drop and recreate:

```dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async { await m.createAll(); },
    onUpgrade: (Migrator m, int from, int to) async {
      await m.deleteTable('transactions');
      await m.createTable('transactions'); // new schema
    },
  );
}
```

This is acceptable for early-stage apps. Use proper migrations for production releases.

---

## 5. Repository Behavior

### 5.1 `TransactionRepository` Contract

Both implementations (`InMemoryTransactionRepository` and `DriftTransactionRepository`) honor the same contract:

| Method | Signature | Behavior |
|--------|-----------|----------|
| `getTransactions()` | `Future<List<TransactionModel>>` | Returns all transactions |
| `addTransaction(t)` | `Future<void>` | Inserts a new transaction |
| `updateTransaction(t)` | `Future<void>` | Updates existing transaction by id |
| `deleteTransaction(id)` | `Future<void>` | Deletes transaction by id |
| `clearAll()` | `Future<void>` | Deletes all transactions |

### 5.2 `updateTransaction` Consistency

Both implementations throw `StateError` if the transaction id does not exist:

- **InMemory:** `StateError('Transaction not found: {id}')` — thrown when `indexWhere` returns `-1`.
- **Drift:** `StateError('Transaction not found: {id}')` — thrown when `updatedRows == 0`.

This is intentional: an update for a non-existent entity is a programming error, not a recoverable condition. The UI layer propagates this as an `AsyncError` via Riverpod's `AsyncValue.guard`.

### 5.3 `deleteTransaction` Safety

Both implementations are **idempotent** for non-existent ids:

- **InMemory:** `removeWhere` is a no-op if the id is not found — no error thrown.
- **Drift:** `deleteTransactionById` with `go()` returns 0 rows affected if not found — silently ignored.

This is intentional: deleting a non-existent transaction is a safe, recoverable operation.

### 5.4 `addTransaction` Behavior

- **InMemory:** Appends to internal `_transactions` list.
- **Drift:** Inserts into SQLite. Drift's `insert` will throw if a primary key collision occurs — a duplicate id is a programming error.

### 5.5 Test Behavior

Widget tests override `transactionRepositoryProvider` with `InMemoryTransactionRepository`:
- Tests run in the Dart VM (no `dart:ffi`).
- No native SQLite dependency.
- Same contract, in-memory backing store.

---

## 6. Verified Native Persistence QA (Phase 8C)

### 6.1 Windows Developer Mode

Windows Developer Mode was successfully enabled (`start ms-settings:developers`) before Phase 8C testing. This allows Flutter to create the required symlinks for Windows builds.

### 6.2 Persistence Test Results

| Test | Result |
|------|--------|
| `flutter run -d windows` launches | **PASS** |
| Add transaction → restart | **PASS** — data persists |
| Edit transaction → restart | **PASS** — edits persist |
| Delete transaction → restart | **PASS** — deleted data does not reappear |
| Dashboard monthly totals after restart | **PASS** — correct |
| Statistics monthly breakdown after restart | **PASS** — correct |
| Transactions filter/search after restart | **PASS** — correct |
| Web fallback remains safe | **PASS** — Chrome analyze/test/chrome pass |

---

## 7. Repository Hardening Audit

All repository implementations were audited for correctness and robustness. No changes were required.

### 7.1 `InMemoryTransactionRepository`

- `getTransactions()` returns `List<TransactionModel>.unmodifiable(_transactions)` — internal list cannot be mutated by callers. ✅
- `updateTransaction()` throws `StateError` for non-existent ids — consistent with Drift contract. ✅
- `deleteTransaction()` uses `removeWhere` — safe no-op for non-existent ids. ✅
- `clearAll()` removes all items. ✅
- Constructor seeds 3 demo transactions for UX demo. ✅

### 7.2 `DriftTransactionRepository`

- `updateTransaction()` uses Drift's `update().write()` — only writes non-null fields in `TransactionsCompanion`. ✅
- `_mapModelToCompanion` correctly wraps `note` in `Value<String?>` — nullable. ✅
- `_mapRowToModel` correctly reads `note` as nullable. ✅
- `_mapRowToModel` uses `TransactionType.fromName(row.type)` with `orElse` fallback — no crash on unknown strings. ✅
- No duplicate inserts possible via `updateTransaction` — uses upsert-by-id semantics. ✅

### 7.3 `TransactionType.fromName`

- Normalizes input with `trim()` + `toLowerCase()`. ✅
- Falls back to `TransactionType.expense` for unknown strings. ✅
- 11 unit tests cover: valid values, case-insensitivity, whitespace, empty strings, unknown values. ✅

### 7.4 `AppDatabase`

- `schemaVersion = 1` — no migrations defined yet. ✅
- No `dart:io` or `dart:ffi` code enters the web compilation tree (conditional import). ✅
- Runtime `kIsWeb` guard in `_openConnection()` throws `UnsupportedError` as a defense-in-depth measure. ✅
- SQLite file stored at `getApplicationDocumentsDirectory()/expense_app.sqlite` on native. ✅

### 7.5 Assessment

**No hardening changes required.** All code is correct, consistent, and safe. The minor item identified in Phase 8A (missing `orElse` in `fromName`) was already fixed in Phase 8B.

---

## 8. Known Limitations

- **Android persistence not verified:** Android toolchain is incomplete (Phase 10). Persistence is assumed to work based on identical code path as Windows, but not tested.
- **Web persistence is InMemory:** By design. Web users do not have persistent data between sessions. This is documented behavior, not a bug.
- **CSV/PDF export not implemented:** ReportsPage shows "coming soon" UI (Phase 9).
- **Cloud sync not implemented:** No backend, no auth, no sync (Phase 12, future).
- **Schema migration not tested:** No migrations exist yet. Future schema changes must follow the migration strategy in Section 4.
- **Automated native persistence integration tests not added:** Setup complexity (native file system, Drift initialization) does not justify adding integration tests for the MVP. Manual Windows QA (Phase 8C) provides equivalent confidence.

---

## 9. Validation

| Command | Result | Notes |
|---------|--------|-------|
| `flutter analyze` | **PASS** | No issues found |
| `flutter test` | **PASS** | 66 tests (30 filter + 10 controller + 11 transaction_type + 15 widget) |
| `flutter run -d chrome --web-run-headless --no-resident` | **PASS** | Web fallback smoke test |
| `flutter run -d windows` (Phase 8C) | **PASS** | Native app launch + persistence QA |
| Manual restart persistence test (Phase 8C) | **PASS** | Add/edit/delete survives restart |

---

## 10. Next Recommended Phase

**Phase 9 — CSV/PDF Export** is the natural next step. Persistence is verified, the ReportsPage UI is in place, and export can pull real data from the repository.

**Alternative:** Phase 10 — Android Toolchain + APK Build if a mobile build is needed before export.

Both are independent of persistence and can proceed in either order based on product priority.
