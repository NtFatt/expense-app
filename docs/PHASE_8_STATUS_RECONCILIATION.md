# Phase 8 Status Reconciliation

**Date:** 2026-05-07  
**Scope:** Canonical Phase 8 decision after transaction persistence audit and later Android validation closeout

## Final Decision

**Phase 8 = DONE for native transaction persistence.**

This phase should not be treated as blocked by Chrome/web because web persistence was never approved for this scope. The active web target remains demo-only and intentionally uses in-memory transactions.

## Canonical Platform Matrix

| Platform | Repository | Restart persistence | Current decision |
|---|---|---:|---|
| Chrome / Web | `InMemoryTransactionRepository` | No | By design for MVP/demo |
| Windows / Native | `DriftTransactionRepository(AppDatabase())` | Yes | Verified native Phase 8 path |
| Android / Native | `DriftTransactionRepository(AppDatabase())` | Yes | Verified during Phase 10B manual Android smoke |

## Evidence From Current Repository

- `lib/features/transactions/presentation/controllers/repository_factory.dart`
  Uses conditional export so the native factory is excluded from unsupported compile paths.
- `lib/features/transactions/presentation/controllers/repository_factory_stub.dart`
  Returns `InMemoryTransactionRepository()` for the web-safe path.
- `lib/features/transactions/presentation/controllers/repository_factory_native.dart`
  Returns `DriftTransactionRepository(getSharedAppDatabase())` on native and keeps a defensive web/test fallback.
- `lib/core/database/app_database.dart`
  Contains native SQLite wiring, `schemaVersion = 2`, migration strategy, and the shared transaction/pay-later schema.
- `lib/core/database/app_database_provider.dart`
  Provides the shared native `AppDatabase` instance used by multiple Drift repositories.
- `test/widget_test.dart`
  Overrides `transactionRepositoryProvider` with `InMemoryTransactionRepository` to keep widget tests web-safe and DB-free.
- `C:\Users\LENOVO\Documents\expense_app.sqlite`
  Native SQLite file exists and currently contains the `transactions` table.

## Why Web Data Loss Is Not A Bug

Chrome/web currently targets the stub repository path on purpose:

- No localStorage or IndexedDB persistence was approved in this phase.
- No web persistence adapter exists in the repository.
- The checklist confusion came from mixing "current active target is web" with "Phase 8 goal was native Drift enablement."

The correct interpretation is:

- Web reset-on-refresh is expected MVP/demo behavior.
- Native restart persistence is the actual Phase 8 deliverable.

## What Would Be Required For Future Web Persistence

Future web persistence would require a separate audited phase with at least:

1. A dedicated web persistence repository.
2. Explicit storage choice such as IndexedDB or another browser-safe mechanism.
3. Separate validation for refresh/reopen persistence.
4. Updated UX/error handling for browser storage limits and migrations.

This work is **out of scope** for Phase 8/9 Stabilization.

## Out Of Scope

- Web persistence implementation
- Drift schema changes or migrations
- Pay Later persistence
- Additional browser persistence implementation

## Canonical Checklist Guidance

Use this wording in the checklist:

- **Phase 8: `[x] DONE`**
- Add note:
  Native transaction persistence is complete.
  Chrome/web remains demo-only `InMemoryTransactionRepository` by design.
  Android native validation is complete as of Phase 10B.

