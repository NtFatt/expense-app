# Phase 8A — Persistence Readiness Audit

**Date:** 2026-05-03
**Auditor:** Senior Flutter Engineer (autonomous audit)
**Scope:** Persistence readiness for enabling Drift/SQLite persistence in Phase 8B

---

## 1. Executive Summary

- **Overall readiness:** NEEDS FIX (minor — see Section 10)
- **Default repo remains:** `InMemoryTransactionRepository`
- **Drift status:** Fully scaffolded, generated, not enabled
- **Web safety:** SAFE
- **Native QA target recommendation:** Windows target first (`flutter run -d windows`)

---

## 2. Files Inspected

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Drift dependencies audit |
| `lib/main.dart` | Entry point — no native DB init |
| `lib/app/app.dart` | App shell |
| `lib/app/router.dart` | Routes — no DB dependency |
| `lib/core/database/app_database.dart` | AppDatabase + _openConnection |
| `lib/core/database/app_database.g.dart` | Generated Drift code |
| `lib/core/database/tables/transactions_table.dart` | Transactions table schema |
| `lib/features/transactions/domain/transaction_model.dart` | Domain model |
| `lib/features/transactions/domain/transaction_type.dart` | TransactionType enum + fromName parser |
| `lib/features/transactions/domain/transaction_filters.dart` | Filter logic |
| `lib/features/transactions/domain/monthly_transaction_summary.dart` | Monthly summary model |
| `lib/features/transactions/data/transaction_repository.dart` | Repository contract |
| `lib/features/transactions/data/in_memory_transaction_repository.dart` | InMemory implementation |
| `lib/features/transactions/data/drift_transaction_repository.dart` | Drift implementation |
| `lib/features/transactions/presentation/controllers/transaction_controller.dart` | Provider wiring + controller |
| `lib/features/transactions/presentation/controllers/transaction_filter_controller.dart` | Filter controller |
| `docs/PROJECT_PROGRESS_CHECKLIST.md` | Progress tracking |

---

## 3. Dependency Audit

| Package | Version | Status |
|---------|--------|--------|
| `drift` | 2.32.1 | INSTALLED |
| `sqlite3_flutter_libs` | 0.6.0+eol | INSTALLED |
| `path_provider` | 2.1.5 | INSTALLED |
| `path` | 1.9.1 | INSTALLED |
| `drift_dev` | 2.32.1 | INSTALLED |
| `build_runner` | 2.15.0 | INSTALLED |

**Verdict:** All Drift runtime and dev dependencies are present and at correct versions. No missing packages. No unnecessary packages. Generated code (`app_database.g.dart`) is present and in sync with the schema.

---

## 4. Database Schema Audit

| Property | Expected | Actual | Status |
|----------|----------|--------|--------|
| Table name | `transactions` | `transactions` | ✅ |
| `id` | text, primary key | text, primary key | ✅ |
| `type` | text | text | ✅ |
| `amount` | integer | integer | ✅ |
| `category` | text | text | ✅ |
| `note` | text, nullable | text, nullable | ✅ |
| `transactionDate` | dateTime | dateTime | ✅ |
| `createdAt` | dateTime | dateTime | ✅ |
| `updatedAt` | dateTime | dateTime | ✅ |
| schemaVersion | 1 | 1 | ✅ |
| Generated code | synced | 794 lines, correct | ✅ |
| Migration needed | No | No | ✅ |

**Verdict:** Schema is complete, correct, and synchronized with generated code. No changes needed.

---

## 5. Repository Contract Audit

| Method | Contract | InMemory Impl | Drift Impl |
|--------|----------|---------------|------------|
| `getTransactions()` | `Future<List<TransactionModel>>` | ✅ | ✅ |
| `addTransaction(TransactionModel)` | `Future<void>` | ✅ | ✅ |
| `updateTransaction(TransactionModel)` | `Future<void>` | ✅ | ✅ |
| `deleteTransaction(String id)` | `Future<void>` | ✅ | ✅ |
| `clearAll()` | `Future<void>` | ✅ | ✅ |

**Verdict:** Full contract coverage by both implementations. No gaps.

---

## 6. Drift Repository Mapping Audit

| Direction | Field | Mapping | Status |
|-----------|-------|---------|--------|
| Model → DB | id | `transaction.id` → `id` | ✅ |
| Model → DB | type | `transaction.type.name` → `type` (String) | ✅ |
| Model → DB | amount | `transaction.amount` → `amount` (int) | ✅ |
| Model → DB | category | `transaction.category` → `category` | ✅ |
| Model → DB | note | `transaction.note` → `Value<String?>(note)` | ✅ |
| Model → DB | transactionDate | `transaction.transactionDate` → `transactionDate` | ✅ |
| Model → DB | createdAt | `transaction.createdAt` → `createdAt` | ✅ |
| Model → DB | updatedAt | `transaction.updatedAt` → `updatedAt` | ✅ |
| DB → Model | all fields | reverse mapping | ✅ |

**Type parsing safety:**
- `TransactionType.fromName(row.type)` is used in `_mapRowToModel`.
- `fromName` uses `firstWhere` with no `orElse` — if an unknown string is in the DB, it throws `StateError`.
- This is acceptable for 8A since all data is app-generated, but Phase 8B should consider adding `orElse` with a fallback to `expense` to prevent crashes from corrupted data.

**DateTime handling:** Direct — Drift handles DateTime serialization automatically. ✅

**Null note:** Correctly wrapped in `Value<String?>` in companion. ✅

**Sorting:** `AppDatabase.getTransactions()` sorts by `transactionDate DESC, createdAt DESC`. Drift repository returns this order. ✅

**Risks:** None critical. Minor: `fromName` lacks `orElse` fallback.

---

## 7. Provider Wiring Audit

**Current provider strategy:**

```dart
final transactionRepositoryProvider = Provider<TransactionRepository>(
  (Ref ref) => _createDefaultTransactionRepository(),
);
```

```dart
TransactionRepository _createDefaultTransactionRepository() {
  if (kIsWeb) {
    return InMemoryTransactionRepository();
  }
  return InMemoryTransactionRepository(); // ← BOTH paths return InMemory
}
```

**Analysis:**
- Both web and native paths currently return `InMemoryTransactionRepository`.
- The `if (kIsWeb)` guard is in place but unused for Drift switching.
- `DriftTransactionRepository` is NOT instantiated on any path — safe for web.
- `AppDatabase` is NOT instantiated globally — safe for web.

**Phase 8B recommendation:**
The switch is a one-line change in `_createDefaultTransactionRepository()`:

```dart
TransactionRepository _createDefaultTransactionRepository() {
  if (kIsWeb) {
    return InMemoryTransactionRepository();
  }
  return DriftTransactionRepository(AppDatabase()); // native only
}
```

No new provider file needed. Controller does NOT need changes.

---

## 8. Web/Native Safety Audit

| Path | Code | Risk |
|------|------|------|
| Web (Chrome) | `_openConnection()` throws `UnsupportedError` immediately | PREVENTED |
| Web (Chrome) | `DriftTransactionRepository` never instantiated | PREVENTED |
| Web (Chrome) | `AppDatabase` never imported in web path | PREVENTED |
| Native (Windows) | `AppDatabase._openConnection()` opens native SQLite | SAFE |
| Native (Windows) | `DriftTransactionRepository(AppDatabase())` available | READY |

**Web safety verdict:** SAFE — importing `app_database.dart` on web would throw `UnsupportedError`, but since `DriftTransactionRepository` is never instantiated on web and `InMemoryTransactionRepository` is used instead, web is fully protected.

**Native readiness verdict:** READY — Windows target is available and detected.

**`kIsWeb` guard:** Already present in `_createDefaultTransactionRepository()`. Phase 8B only needs to update the native branch.

**AppDatabase initialization risk:** `AppDatabase` is a global singleton only if `DriftTransactionRepository` is created. Currently no instantiation on any platform. No risk.

---

## 9. Native Target Readiness

| Target | Status | Notes |
|--------|--------|-------|
| Windows | AVAILABLE | `flutter devices` shows Windows desktop |
| Chrome | AVAILABLE | web-javascript target |
| Edge | AVAILABLE | web-javascript target |
| Android | INCOMPLETE | cmdline-tools missing, licenses unknown |

**flutter doctor summary:**
- Flutter: ✅ (stable 3.41.9)
- Windows version: ✅ (Windows 11)
- Android toolchain: ⚠️ cmdline-tools missing, licenses unknown
- Chrome: ✅
- Visual Studio: ✅ (Build Tools 2019)

**Recommended QA target:** Windows first (`flutter run -d windows`) for native persistence QA in Phase 8C. Android can remain Phase 10 unless user prioritizes it.

---

## 10. Fixes Applied in 8A

**None required.** All code is clean and correct. No schema mismatches, no broken mappings, no unsafe code patterns.

**Observed minor item (not fixed — Phase 8B scope):**
- `TransactionType.fromName` in `transaction_type.dart` uses `firstWhere` without `orElse`. If a corrupted string exists in the database, it will throw `StateError` instead of a graceful fallback. Phase 8B should consider:

```dart
static TransactionType fromName(String value) {
  return TransactionType.values.firstWhere(
    (TransactionType type) => type.name == value,
    orElse: () => TransactionType.expense, // safe fallback
  );
}
```

This is **not a blocker** since all data is app-generated, but worth hardening in Phase 8B.

---

## 11. Phase 8B Readiness Checklist

- [ ] Update `_createDefaultTransactionRepository()` to return `DriftTransactionRepository(AppDatabase())` on native path
- [ ] Verify `DriftTransactionRepository` constructor accepts `AppDatabase` (it does — confirmed)
- [ ] Keep `kIsWeb` branch returning `InMemoryTransactionRepository` for web
- [ ] Validate Windows: `flutter run -d windows`
- [ ] Validate persistence after restart on Windows (add transaction, restart, verify it persists)
- [ ] Validate Chrome remains green: `flutter run -d chrome --web-run-headless --no-resident`
- [ ] Optionally harden `TransactionType.fromName` with `orElse` fallback
- [ ] Run `flutter analyze` and `flutter test` after changes

---

## 12. Validation

| Command | Result | Notes |
|---------|--------|-------|
| `flutter analyze` | PASS | No issues found |
| `flutter test` | PASS | 55 tests passed |
| `flutter run -d chrome --web-run-headless --no-resident` | PASS | Chrome smoke passed |
| `flutter devices` | PASS | Windows, Chrome, Edge available |
| `flutter doctor` | WARN | Android toolchain incomplete (expected) |
| `flutter run -d windows` | NOT RUN | Phase 8C scope |

---

## 13. Recommendation

**Go/No-Go for Phase 8B: GO**

The persistence infrastructure is fully ready:

1. All Drift dependencies are installed and correct.
2. Schema matches `TransactionModel` exactly — no migration needed.
3. Generated code is synced and complete.
4. Repository contract is fully implemented by both repositories.
5. Mapping logic is correct and complete.
6. Web is protected by `InMemoryTransactionRepository` default and `UnsupportedError` in `_openConnection`.
7. Windows target is available for native persistence QA.
8. Provider structure needs only a one-line change in Phase 8B.

**The only action needed in Phase 8B is switching the native branch in `_createDefaultTransactionRepository()` to return `DriftTransactionRepository(AppDatabase())`.**
