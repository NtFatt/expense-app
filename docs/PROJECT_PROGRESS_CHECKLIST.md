# Expense App — Project Progress Checklist

## 0. Project Snapshot

- Project: Expense App
- Path: `D:\LEARNCODE\Project_CV\expense_app`
- Stack: Flutter + Dart + Riverpod + GoRouter + Drift scaffold + fl_chart
- Current run target: Chrome/web
- Current default repository: Platform-aware (`InMemoryTransactionRepository` on web, `DriftTransactionRepository` on native)
- Persistence status: Drift enabled and verified on native (Windows/Android); web uses InMemory fallback via conditional imports
- Current validation status: `flutter analyze` PASS, `flutter test` PASS (66 tests), `flutter run -d chrome` PASS, `flutter run -d windows` PASS (Phase 8C)
- Last updated: `2026-05-03` (Phase 8 COMPLETE — 8A audit + 8B switching + 8C QA + 8D hardening/docs)

## 1. Status Legend

- `[ ] NOT STARTED` — chưa làm
- `[~] IN PROGRESS` — đang làm
- `[x] DONE` — đã làm xong và đã validate
- `[!] BLOCKED` — bị chặn
- `[L] LITE DONE` — làm bản nhẹ/scaffold/tạm, chưa production-ready
- `[R] REVIEW` — đã code xong, đang cần kiểm tra/review
- `[F] FAILED` — đã thử nhưng fail validation

## 2. High-Level Roadmap

| Phase | Name | Status | Summary | Validation | Notes |
|---|---|---:|---|---|---|
| 0 | Environment Setup | `[x]` | Môi trường Flutter/Git/VS Code sẵn sàng, app chạy Chrome | analyze/test pass | Android toolchain chưa xanh hoàn toàn nhưng không block web |
| 1 | Project Structure Refactor | `[x]` | Tách `app/`, `core/`, `features/`, `shared/` | analyze/test pass | `main.dart` chỉ bootstrap |
| 2 | Add Transaction UI | `[x]` | Hoàn thiện form thêm giao dịch và route `/transactions/new` | analyze/test pass | Category đổi theo type, có date picker |
| 3 | Domain Models | `[x]` | Tạo `TransactionType`, `TransactionModel`, `CategoryModel` | analyze/test pass | Có `copyWith`, `signedAmount`, `displayTitle` |
| 4 | Riverpod Runtime State | `[x]` | Runtime state bằng Riverpod với add/delete/update dashboard | analyze/test pass | Default repo là in-memory |
| 5 | Drift/SQLite Scaffold | `[L]` | Đã scaffold Drift table/database/repository | build_runner/analyze/test pass | Scaffolded; Phase 8B enables on native |
| 6 | MVP UX Polish | `[x]` | Bottom nav, statistics, reports, polish UX các page chính | pub get/analyze/test/chrome pass | Chrome/web vẫn an toàn |
| 7 | Filter/Search/Monthly View/Edit Transaction | `[x]` | Phase 7A–7D done (edit, filter/search UI, monthly dashboard, monthly statistics) | analyze/test/chrome pass for 7D | Phase 7 COMPLETE |
| 8 | Enable SQLite/Drift Persistence | `[x]` | Drift enabled on native, verified on Windows, documented and hardened (8A–8D all DONE) | analyze/test/chrome/windows persistence QA pass | Phase 8 COMPLETE; next Phase 9 CSV/PDF Export or Phase 10 Android APK |
| 9 | CSV/PDF Export | `[ ]` | Chưa implement export thật | Chưa chạy | ReportsPage vẫn là "coming soon" UI |
| 10 | Android Toolchain + APK Build | `[ ]` | Chưa xử lý Android toolchain/APK | Chưa chạy | Hiện chưa ưu tiên |
| 11 | Final QA + Demo Script | `[ ]` | Chưa làm checklist demo cuối | Chưa chạy | Để sau MVP ổn định |
| 12 | Optional Cloud Sync/Auth | `[ ]` | Chưa bắt đầu | Chưa chạy | Ngoài scope hiện tại |

## 3. Detailed Phase Checklist

### Phase 0 — Environment Setup

**Status:** `[x] DONE`
**Goal:** Hoàn thiện môi trường phát triển Flutter để có thể build, analyze, test và chạy app trên Chrome/web.
**Scope:** Git, Flutter SDK, Dart qua Flutter, VS Code, Flutter extension, khởi tạo project và xác nhận app chạy được.
**Files touched/expected:** `pubspec.yaml`, `lib/main.dart`, `test/widget_test.dart`, Flutter project scaffold mặc định.

**Checklist:**
- [x] Git installed and updated
- [x] Flutter SDK installed
- [x] Dart available through Flutter
- [x] VS Code installed
- [x] Flutter extension installed
- [x] Project created at `D:\LEARNCODE\Project_CV\expense_app`
- [x] App runs on Chrome
- [x] `flutter analyze` pass
- [x] `flutter test` pass

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`
- [x] `flutter run -d chrome`

**Notes:**
- Android toolchain still has missing cmdline-tools/licenses, but not blocking current Chrome/web development.

**Next step:**
- Lock down project structure for maintainable feature-first development.

### Phase 1 — Project Structure Refactor

**Status:** `[x] DONE`
**Goal:** Tách app khỏi `main.dart` và đặt nền kiến trúc rõ ràng theo `app/core/features/shared`.
**Scope:** Tách app shell, router, theme, dashboard page và reusable widgets.
**Files touched/expected:** `lib/main.dart`, `lib/app/app.dart`, `lib/app/router.dart`, `lib/app/theme.dart`, `lib/core/constants/app_constants.dart`, `lib/core/utils/currency_formatter.dart`, `lib/shared/widgets/app_scaffold.dart`, `lib/shared/widgets/section_header.dart`, `lib/features/transactions/presentation/pages/dashboard_page.dart`, `lib/features/transactions/presentation/widgets/balance_card.dart`, `summary_card.dart`, `transaction_tile.dart`.

**Checklist:**
- [x] Move app shell to `lib/app/app.dart`
- [x] Move router to `lib/app/router.dart`
- [x] Move theme to `lib/app/theme.dart`
- [x] Keep `lib/main.dart` clean
- [x] Create `core/`, `features/`, `shared/` structure
- [x] Extract dashboard page
- [x] Extract reusable widgets

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`

**Notes:**
- App vẫn chạy được sau khi tách cấu trúc.

**Next step:**
- Build Add Transaction UI trên nền router/theme mới.

### Phase 2 — Add Transaction UI

**Status:** `[x] DONE`
**Goal:** Tạo flow thêm giao dịch đủ dùng cho MVP trước khi gắn state thật.
**Scope:** Route `/transactions/new`, form field, validation amount, date picker và điều hướng từ FAB.
**Files touched/expected:** `lib/app/router.dart`, `lib/core/utils/date_formatter.dart`, `lib/features/transactions/presentation/pages/add_transaction_page.dart`, `lib/features/transactions/presentation/widgets/transaction_type_selector.dart`, `test/widget_test.dart`.

**Checklist:**
- [x] Create `/transactions/new` route
- [x] Create `AddTransactionPage`
- [x] Add transaction type selector
- [x] Add amount input
- [x] Add category selector
- [x] Add note input
- [x] Add date picker
- [x] Add submit button
- [x] Validate amount required
- [x] Validate amount > 0
- [x] Reset category when type changes

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`

**Notes:**
- Flow submit ban đầu đã sẵn sàng để nối sang Riverpod state.

**Next step:**
- Chuẩn hóa domain model để tránh dùng dữ liệu ad-hoc trong UI.

### Phase 3 — Domain Models

**Status:** `[x] DONE`
**Goal:** Tạo model/domain đủ sạch để state, UI và repository cùng dùng chung.
**Scope:** Enum type giao dịch, transaction entity, category entity và default categories.
**Files touched/expected:** `lib/features/transactions/domain/transaction_type.dart`, `lib/features/transactions/domain/transaction_model.dart`, `lib/features/categories/domain/category_model.dart`, `lib/features/categories/data/default_categories.dart`, cập nhật `dashboard_page.dart`, `transaction_tile.dart`, `add_transaction_page.dart`.

**Checklist:**
- [x] Create `TransactionType` enum
- [x] Create `TransactionModel`
- [x] Add `copyWith`
- [x] Add `signedAmount` getter
- [x] Add `displayTitle` getter
- [x] Create `CategoryModel`
- [x] Create default categories

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`

**Notes:**
- `TransactionModel.amount` được giữ là số dương; dấu âm/dương được suy ra từ `TransactionType`.

**Next step:**
- Nối runtime state bằng Riverpod để dashboard và transactions list cập nhật thật.

### Phase 4 — Riverpod Runtime State

**Status:** `[x] DONE`
**Goal:** Cho app hoạt động với runtime state thật trước khi bật persistence local.
**Scope:** ProviderScope, repository abstraction, in-memory repository, controller, state calculations và submit/delete flow.
**Files touched/expected:** `lib/main.dart`, `lib/features/transactions/data/transaction_repository.dart`, `lib/features/transactions/data/in_memory_transaction_repository.dart`, `lib/features/transactions/presentation/controllers/transaction_controller.dart`, `lib/features/transactions/presentation/pages/dashboard_page.dart`, `transactions_page.dart`, `add_transaction_page.dart`, `lib/shared/widgets/empty_state.dart`.

**Checklist:**
- [x] Add `ProviderScope`
- [x] Create `TransactionRepository` contract
- [x] Create `InMemoryTransactionRepository`
- [x] Create `TransactionController`
- [x] Create `TransactionState`
- [x] Dashboard reads from provider
- [x] Add transaction updates runtime state
- [x] Delete transaction updates runtime state
- [x] Compute total income
- [x] Compute total expense
- [x] Compute balance
- [x] Compute recent transactions

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`

**Notes:**
- Dữ liệu runtime mất sau reload vì repo mặc định là in-memory (đã fix ở Phase 8B cho native).

**Next step:**
- Chuẩn bị Drift scaffold nhưng chưa làm hỏng web/Chrome demo.

### Phase 5 — Drift/SQLite Scaffold

**Status:** `[L] LITE DONE`
**Goal:** Chuẩn bị persistence layer production-grade nhưng chưa bật mặc định khi web là target chính.
**Scope:** Drift dependencies, table, database, generated code và repository mapping.
**Files touched/expected:** `pubspec.yaml`, `lib/core/database/tables/transactions_table.dart`, `lib/core/database/app_database.dart`, `lib/core/database/app_database.g.dart`, `lib/features/transactions/data/drift_transaction_repository.dart`.

**Checklist:**
- [x] Add Drift dependencies
- [x] Create transactions table
- [x] Create `AppDatabase`
- [x] Generate Drift code
- [x] Create `DriftTransactionRepository`
- [x] Enable Drift as default repository on native (Phase 8B)
- [x] Persist transactions after reload on native (Phase 8C — VERIFIED)
- [x] Native target QA (Phase 8C — VERIFIED on Windows)
- [x] Migration strategy (Phase 8D — documented)

**Validation:**
- [x] `dart run build_runner build --delete-conflicting-outputs`
- [x] `flutter analyze`
- [x] `flutter test`
- [x] Chrome safe because Drift is not default (web uses InMemory via conditional import)

**Notes:**
- Drift scaffolded, enabled on native via Phase 8B conditional imports.
- Phase 8B switched native default to `DriftTransactionRepository(AppDatabase())`.
- Web/Chrome remains on `InMemoryTransactionRepository` via `repository_factory_stub.dart`.
- Persistence verified on Windows via Phase 8C manual QA: add/edit/delete all persist after restart.
- Migration strategy documented in Phase 8D: bump `schemaVersion`, add `MigrationStrategy.onUpgrade`, regenerate with `build_runner`.

**Next step:**
- Phase 9 — CSV/PDF Export.

### Phase 6 — MVP UX Polish

**Status:** `[x] DONE`
**Goal:** Làm app đủ đẹp, rõ và dễ demo với navigation, statistics và reports preparation.
**Scope:** Bottom navigation, dashboard polish, transactions summary/delete confirm, add transaction polish, statistics thật bằng fl_chart, reports cards, test update.
**Files touched/expected:** `lib/shared/widgets/app_bottom_navigation.dart`, `metric_card.dart`, `app_scaffold.dart`, `lib/features/transactions/presentation/pages/dashboard_page.dart`, `transactions_page.dart`, `add_transaction_page.dart`, `lib/features/transactions/presentation/widgets/transaction_summary_panel.dart`, `delete_transaction_dialog.dart`, `lib/features/statistics/presentation/pages/statistics_page.dart`, `lib/features/statistics/presentation/widgets/*`, `lib/features/reports/presentation/pages/reports_page.dart`, `lib/features/reports/presentation/widgets/report_action_card.dart`, `test/widget_test.dart`.

**Checklist:**
- [x] Add bottom navigation
- [x] Dashboard UX polish
- [x] Transactions summary panel
- [x] Delete confirmation dialog
- [x] Delete SnackBar
- [x] Statistics real data from provider
- [x] `fl_chart` spending chart
- [x] Reports page polished with CSV/PDF/Backup cards (UI only — export not yet implemented)
- [x] Keep InMemory repository as default (web-safe)
- [x] Preserve Drift scaffold
- [x] Update widget tests

**Validation:**
- [x] `flutter pub get`
- [x] `flutter analyze`
- [x] `flutter test`
- [x] `flutter run -d chrome --web-run-headless --no-resident`

**Notes:**
- Reports vẫn là UI preparation, chưa export thật (Phase 9).
- Statistics đã đọc số liệu thật từ provider state.

**Next step:**
- Start Phase 7 with filters, monthly view and edit transaction flow.

### Phase 7 — Filter/Search/Monthly View/Edit Transaction

**Status:** `[x] DONE` (7A done; 7B done; 7C done; 7D done)

#### Phase 7A — Edit Transaction Foundation

**Status:** `[x] DONE`
**Goal:** Add edit transaction flow and extract shared form component to avoid duplication.
**Scope:** Edit route, `EditTransactionPage`, shared `TransactionForm`, `updateTransaction` in controller, repository interface updates, widget test.
**Files touched:** `router.dart` (+edit route `/transactions/:id/edit`), `edit_transaction_page.dart` (new), `transaction_form.dart` (new shared form), `transaction_controller.dart` (+`updateTransaction`, `transactionById`), `add_transaction_page.dart` (refactored to use shared form), `in_memory_transaction_repository.dart` (+`updateTransaction`), `drift_transaction_repository.dart` (+`updateTransaction`), `transaction_repository.dart` (+`updateTransaction` abstract method), `widget_test.dart` (+edit navigation test).

**Checklist:**
- [x] Add edit transaction route `/transactions/:id/edit`
- [x] Create `EditTransactionPage` with loading/error/empty states
- [x] Create shared `TransactionForm` widget (reused by add and edit)
- [x] Add `updateTransaction` to `TransactionRepository` contract
- [x] Add `updateTransaction` to `InMemoryTransactionRepository`
- [x] Add `updateTransaction` to `DriftTransactionRepository`
- [x] Add `updateTransaction` to `TransactionController`
- [x] Add `transactionById` helper to `TransactionState`
- [x] Refactor `AddTransactionPage` to use shared `TransactionForm`
- [x] Add widget test for edit navigation
- [x] `flutter analyze` pass
- [x] `flutter test` pass
- [x] `flutter run -d chrome` smoke pass

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`
- [x] `flutter run -d chrome --web-run-headless --no-resident`

**Notes:**
- `TransactionForm` is shared between add and edit, eliminating code duplication.
- Form pre-fills with existing transaction data on edit.
- Phase 7A scope limited to edit foundation; filter/search/monthly view are Phase 7B/7C/7D.

**Next step:**
- Phase 7C — Transactions Filter UI.

#### Phase 7B — Filter/Search Controller

**Status:** `[x] DONE`
**Goal:** Add dedicated filter/search/month state controller to support monthly view and type filtering.
**Scope:** Filter state model, filter controller, month selector, type filter (all/income/expense), search query.
**Files touched:** `transaction_filters.dart` (new: `TransactionTypeFilter` enum, `TransactionFilterState`, helpers, `applyTransactionFilters`), `transaction_filter_controller.dart` (new: `TransactionFilterController`, `transactionFilterControllerProvider`).

**Checklist:**
- [x] Design `TransactionFilterState`
- [x] Create `TransactionFilterController`
- [x] Create `TransactionTypeFilter`: all / income / expense
- [x] Create month selection state (`normalizeMonth`, `isSameMonth`)
- [x] Add `applyTransactionFilters()`
- [x] Filter by month
- [x] Filter by type
- [x] Search by category/note/displayTitle
- [x] Add tests for filter logic

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`
- [x] `flutter run -d chrome --web-run-headless --no-resident`

**Notes:**
- Filter logic is domain-level and fully testable (30 filter tests + 10 controller tests).
- UI wiring is intentionally deferred to Phase 7C.
- Dashboard/statistics monthly integration is intentionally deferred to Phase 7D.
- `applyTransactionFilters` is a pure function that does not mutate the input list.

**Next step:**
- Phase 7C — Transactions Filter UI.

#### Phase 7C — Transactions Filter UI

**Status:** `[x] DONE`
**Goal:** Wire filter state to UI with month selector, type chips, and search bar on the transactions page.
**Scope:** Filter bar widget, month selector widget, type filter chips, search input, wiring to controller, filtered summary panel.
**Files touched:** `transaction_filter_bar.dart` (new: `TransactionFilterBar` with search + type chips + month selector), `month_selector.dart` (new: `MonthSelector` with prev/next buttons and month label), `filtered_transactions_summary.dart` (new: filtered totals for summary panel), `transactions_page.dart` (refactored: wired `transactionFilterControllerProvider` and `applyTransactionFilters`), `transaction_filter_controller.dart` (+`clearNonMonthFilters`), `widget_test.dart` (+5 Phase 7C widget tests).

**Checklist:**
- [x] Create MonthSelector widget
- [x] Create TransactionFilterBar widget
- [x] Wire month selector
- [x] Wire type filter chips
- [x] Wire search input
- [x] Show active filter count
- [x] TransactionsPage uses filtered transactions
- [x] Summary panel uses filtered transactions
- [x] Empty state distinguishes no data vs no matching result
- [x] Add tests for filter/search UI

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`
- [x] `flutter run -d chrome --web-run-headless --no-resident`

**Notes:**
- `FilteredTransactionsSummary` widget created to avoid breaking Dashboard's use of `TransactionSummaryPanel`.
- Month label uses static Vietnamese month names (avoids `initializeDateFormatting` requirement in tests).
- Filter UI is wired only on TransactionsPage; Dashboard and Statistics monthly integration remain Phase 7D.
- `clearNonMonthFilters()` added to controller to reset search + type without resetting month.
- All 49 tests pass (44 original + 5 new Phase 7C widget tests).

**Next step:**
- Phase 7D — Monthly Dashboard + Statistics.

#### Phase 7D — Monthly Dashboard + Statistics

**Status:** `[x] DONE`
**Goal:** Make Dashboard and Statistics respect the selected month from `transactionFilterControllerProvider`, independent of search/type filters.
**Scope:** Month-only filter helper, monthly summary domain model, Dashboard monthly wiring, Statistics monthly wiring, reusable MonthSelector on all pages.
**Files touched:** `transaction_filters.dart` (+`filterTransactionsByMonth`), `monthly_transaction_summary.dart` (new: `MonthlyTransactionSummary`, `CategoryExpenseSummary`), `transaction_controller.dart` (removed duplicate `CategoryExpenseSummary`, added export), `dashboard_page.dart` (monthly totals, month selector, month-aware recent transactions), `statistics_page.dart` (monthly summary cards, chart, breakdown, top category), `widget_test.dart` (+6 Phase 7D widget tests).

**Checklist:**
- [x] Dashboard shows monthly totals based on selected month
- [x] Dashboard ignores search/type filters (uses month-only filter)
- [x] Statistics page shows monthly breakdown
- [x] Statistics ignores search/type filters (uses month-only filter)
- [x] Charts respect selected month
- [x] No-data states for months with no transactions
- [x] Reuse MonthSelector on Dashboard and Statistics
- [x] Add tests for monthly dashboard/statistics

**Validation:**
- [x] `flutter analyze`
- [x] `flutter test`
- [x] `flutter run -d chrome --web-run-headless --no-resident`

**Notes:**
- `filterTransactionsByMonth()` added to `transaction_filters.dart` — month-only, no type/search.
- `MonthlyTransactionSummary` created in domain layer with `totalIncome`, `totalExpense`, `balance`, `recentTransactions`, `expenseByCategory`, `expenseCategorySummaries`, `topExpenseCategory`.
- `CategoryExpenseSummary` moved from `transaction_controller.dart` to `monthly_transaction_summary.dart` and re-exported.
- Dashboard: uses month-only filter, shows monthly balance/income/expense, MonthSelector, month-aware recent transactions.
- Statistics: uses month-only filter, shows monthly summary cards, chart, breakdown, top category.
- Phase 7A/7B/7C TransactionsPage filter (month+type+search) remains intact.
- Phase 7 is now complete.

**Next step:**
- Phase 8 — Enable SQLite/Drift Persistence.

### Phase 8 — Enable SQLite/Drift Persistence

**Status:** `[x] DONE` (8A audit ✅ · 8B switching ✅ · 8C QA ✅ · 8D hardening/docs ✅)
**Goal:** Switch from runtime memory state to real local persistence on native targets while keeping web fallback safe.

#### Phase 8A — Persistence Readiness Audit

**Status:** `[x] DONE`
**Goal:** Audit Drift schema, repository contract, mapping, provider wiring, and web/native safety before enabling persistence.

**Checklist:**
- [x] Audit Drift dependencies
- [x] Audit transactions table schema
- [x] Audit AppDatabase and generated code
- [x] Audit TransactionRepository contract
- [x] Audit InMemoryTransactionRepository
- [x] Audit DriftTransactionRepository
- [x] Audit TransactionModel mapping
- [x] Audit provider wiring and default repository
- [x] Audit web/native safety
- [x] Check Flutter devices/doctor
- [x] Create `docs/PHASE_8A_PERSISTENCE_READINESS_AUDIT.md`
- [x] Run validation

**Validation:**
- [x] `flutter analyze` — PASS
- [x] `flutter test` — PASS (55 tests)
- [x] `flutter run -d chrome --web-run-headless --no-resident` — PASS
- [x] `flutter devices` — PASS (Windows, Chrome, Edge available)
- [x] `flutter doctor` — WARN (Android toolchain incomplete, expected)

**Notes:**
- Phase 8C (native persistence QA) has been completed using Windows target.
- All persistence operations verified: add/edit/delete survive app restart.
- Dashboard/statistics/filter-search all correct after restart.
- Full audit report at `docs/PHASE_8A_PERSISTENCE_READINESS_AUDIT.md`.

**Next step:**
- Phase 8B — Repository Switching Strategy.

#### Phase 8B — Repository Switching Strategy

**Status:** `[x] DONE`
**Goal:** Switch native targets to Drift repository while keeping web/Chrome on InMemory repository.

**Checklist:**
- [x] Add conditional import `repository_factory.dart` with `repository_factory_stub.dart` / `repository_factory_native.dart`
- [x] `repository_factory_stub.dart` returns `InMemoryTransactionRepository` (web stub)
- [x] `repository_factory_native.dart` returns `DriftTransactionRepository(AppDatabase())` on native, `InMemoryTransactionRepository` on web
- [x] `transaction_controller.dart` uses `createDefaultTransactionRepository()` via conditional import
- [x] `app_database.dart` excluded from web compilation tree by conditional import
- [x] `TransactionType.fromName` hardened with `orElse` fallback to `expense`
- [x] Add `TransactionType` unit tests (`transaction_type_test.dart`, 11 tests)
- [x] Fix widget tests to override `transactionRepositoryProvider` with `InMemoryTransactionRepository`
- [x] Validate Chrome remains green
- [x] `flutter analyze` and `flutter test` pass

**Validation:**
- [x] `flutter analyze` — PASS
- [x] `flutter test` — PASS (66 tests: 30 filter + 10 controller + 11 transaction_type + 15 widget)
- [x] `flutter run -d chrome --web-run-headless --no-resident` — PASS
- [x] `flutter run -d windows` — PASS (Phase 8C: app launched and ran on Windows after enabling Developer Mode)

**Notes:**
- Web/Chrome uses `InMemoryTransactionRepository` via `repository_factory_stub.dart`.
- Native (Windows/Android) uses `DriftTransactionRepository(AppDatabase())` via `repository_factory_native.dart`.
- `app_database.dart` is excluded from web compilation tree by conditional import — no `dart:ffi` leak on web.
- `TransactionType.fromName` now normalizes input (trim + lowercase) and falls back to `expense` for unknown strings.
- Widget tests override `transactionRepositoryProvider` with `InMemoryTransactionRepository` to avoid native DB in tests.
- Phase 8B complete. Persistence verification on native done in Phase 8C using Windows target.
- Windows Developer Mode was successfully enabled before Phase 8C testing.
- Phase 8D is the final sub-phase.

**Next step:**
- Phase 8C — Native Persistence QA.

#### Phase 8C — Native Persistence QA

**Status:** `[x] DONE`
**Goal:** Verify that add/edit/delete transactions truly persist after app restart on native target (Windows/Android).

**Checklist:**
- [x] Run app on Windows native target (`flutter run -d windows`)
- [x] Add a transaction and restart the app
- [x] Verify add persists after restart
- [x] Verify edit persists after restart
- [x] Verify delete persists after restart
- [x] Verify monthly dashboard/statistics are correct after restart
- [x] Verify transactions filter/search after restart
- [x] Web/Chrome fallback remains safe

**Validation:**
- [x] `flutter run -d windows` — PASS (after enabling Developer Mode)
- [x] Manual restart persistence smoke test — PASS
- [x] Add transaction persists after restart — PASS
- [x] Edit transaction persists after restart — PASS
- [x] Delete transaction does not reappear after restart — PASS
- [x] Dashboard monthly totals correct after restart — PASS
- [x] Statistics monthly breakdown correct after restart — PASS
- [x] Transactions filter/search works after restart — PASS
- [x] `flutter analyze` — PASS (Phase 8C regression)
- [x] `flutter test` — PASS (Phase 8C regression)
- [x] `flutter run -d chrome --web-run-headless --no-resident` — PASS (web fallback safe)

**Notes:**
- Windows Developer Mode enabled successfully.
- `flutter run -d windows` launched Drift-backed native app without errors.
- All persistence operations (add/edit/delete) survive app restart.
- Dashboard and Statistics monthly views reflect persisted data correctly after restart.
- Filter/search on TransactionsPage works correctly on persisted data.
- Web/Chrome remains on `InMemoryTransactionRepository` — no regression.
- Phase 8D (hardening/migration/docs) is the final sub-phase before Phase 8 can be marked DONE.

**Next step:**
- Phase 8D — Hardening, Migration, Documentation.

#### Phase 8D — Hardening, Migration, Documentation

**Status:** `[x] DONE`
**Goal:** Document migration strategy, persistence behavior, and harden repository layer where needed.

**Checklist:**
- [x] Document migration strategy
- [x] Document web/native repository behavior
- [x] Document verified Windows native persistence QA (Phase 8C)
- [x] Audit repository error handling
- [x] Add or confirm persistence-related tests where feasible
- [x] Update README with persistence section
- [x] Create `docs/PHASE_8D_PERSISTENCE_HARDENING.md`
- [x] Mark Phase 8 DONE after validation

**Validation:**
- [x] `flutter analyze` — PASS (no issues found)
- [x] `flutter test` — PASS (66 tests)
- [x] `flutter run -d chrome --web-run-headless --no-resident` — PASS (web fallback safe)
- [x] Phase 8C manual Windows persistence QA — PASS (add/edit/delete survives restart)

**Notes:**
- Repository hardening audit: no changes required — all implementations are correct and consistent.
- `InMemoryTransactionRepository.getTransactions()` returns unmodifiable list — no list leak.
- Both `updateTransaction` implementations throw `StateError` for non-existent ids — consistent.
- Both `deleteTransaction` implementations are idempotent — safe no-op for non-existent ids.
- `TransactionType.fromName` already hardened with `orElse` fallback (fixed in Phase 8B).
- Migration strategy documented: bump `schemaVersion`, add `onUpgrade`, regenerate with `build_runner`.
- No `dart:ffi` code enters web bundle — conditional import excludes native code at compile time.
- Automated native persistence integration tests deferred: manual Windows QA (Phase 8C) provides equivalent confidence.
- Phase 8 is now complete. All four sub-phases (8A/8B/8C/8D) are DONE.

**Next step:**
- Phase 9 — CSV/PDF Export (recommended next phase).

### Phase 9 — CSV/PDF Export

**Status:** `[ ] NOT STARTED`
**Goal:** Implement real report export.
**Scope:** CSV export, PDF export, file save/share flow and success/failure UX.
**Files touched/expected:** reports/export service files, repository/provider integrations, reports page actions.

**Checklist:**
- [ ] Export transactions to CSV
- [ ] Export monthly report to PDF
- [ ] Add file save/share flow
- [ ] Add export success/failure SnackBar
- [ ] Use data from repository/provider
- [ ] Ensure no fake export UI remains

**Validation:**
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] manual export test

**Notes:**
- `ReportsPage` currently shows "coming soon" SnackBar for all export actions.
- Phase 8C is now complete — Phase 9 can proceed.
- Export depends on real data from repository (Drift on native, InMemory on web).

**Next step:**
- Phase 9: Start CSV/PDF export implementation.

### Phase 10 — Android Toolchain + APK Build

**Status:** `[ ] NOT STARTED`
**Goal:** Fix Android environment and produce APK.
**Scope:** Android SDK tools, licenses, emulator/device run và APK build.
**Files touched/expected:** Android SDK/toolchain setup ngoài repo, có thể kèm minimal Android project config nếu cần.

**Checklist:**
- [ ] Install Android SDK cmdline-tools
- [ ] Accept Android licenses
- [ ] `flutter doctor` Android toolchain green
- [ ] Run app on Android emulator or physical device
- [ ] Build debug APK
- [ ] Build release APK if needed

**Validation:**
- [ ] `flutter doctor --android-licenses`
- [ ] `flutter doctor`
- [ ] `flutter run -d android`
- [ ] `flutter build apk`

**Notes:**
- Phase này độc lập với web demo nhưng là prerequisite quan trọng cho persistence QA trên Android.
- Phase 8C used Windows target successfully for native persistence QA.

**Next step:**
- Fix local Android toolchain once persistence rollout is scheduled.

### Phase 11 — Final QA + Demo Script

**Status:** `[ ] NOT STARTED`
**Goal:** Prepare final demo and QA checklist.
**Scope:** Manual test cases, demo script, UI/device verification, release readiness.
**Files touched/expected:** `docs/` demo notes, QA checklist docs, maybe screenshots/gifs if needed.

**Checklist:**
- [ ] Write manual test cases
- [ ] Write demo script
- [ ] Verify add/edit/delete/filter/statistics/export
- [ ] Verify empty states
- [ ] Verify error states
- [ ] Verify UI on small screen
- [ ] Verify release build

**Validation:**
- [ ] full manual QA walkthrough
- [ ] release smoke check

**Notes:**
- Nên làm sau Phase 7–10 ổn định.

**Next step:**
- Convert manual flows thành repeatable demo steps.

### Phase 12 — Optional Cloud Sync/Auth

**Status:** `[ ] NOT STARTED`
**Goal:** Only consider after local app is stable.
**Scope:** Backend decision, auth decision, sync strategy, conflict handling và cloud backup.
**Files touched/expected:** TBD after product scope is confirmed.

**Checklist:**
- [ ] Decide backend
- [ ] Decide auth
- [ ] Sync local SQLite with server
- [ ] Conflict strategy
- [ ] Backup/restore cloud

**Validation:**
- [ ] architecture review
- [ ] sync/auth integration QA

**Notes:**
- Do not start this before Phase 8–11 are stable.

**Next step:**
- Re-evaluate only when local-first MVP is complete.

## 4. Validation History

| Date | Command | Result | Notes |
|---|---|---:|---|
| 2026-05-02 | `flutter pub get` | PASS | Dependencies resolved successfully after Phase 6 |
| 2026-05-02 | `flutter analyze` | PASS | Latest Phase 6 validation clean |
| 2026-05-02 | `flutter test` | PASS | Widget tests updated for bottom navigation and add transaction flow |
| 2026-05-02 | `flutter run -d chrome` | PASS | Previously validated during MVP setup/phases |
| 2026-05-02 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Latest Chrome smoke run passed after Phase 6 |
| 2026-05-02 | `dart run build_runner build --delete-conflicting-outputs` | PASS | Drift code generation passed in Phase 5; not rerun in Phase 6 because schema did not change |
| 2026-05-02 | `flutter analyze` | PASS | Phase 7A: shared `TransactionForm`, `EditTransactionPage`, `updateTransaction` controller, edit route |
| 2026-05-02 | `flutter test` | PASS | Phase 7A: edit navigation widget test added and passes |
| 2026-05-02 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Phase 7A: Chrome smoke remained green after refactoring add page to use shared form |
| 2026-05-02 | `flutter analyze` | PASS | Phase 7B: `transaction_filters.dart`, `transaction_filter_controller.dart`, filter/controller tests |
| 2026-05-02 | `flutter test` | PASS | Phase 7B: 44 tests total (30 filter logic + 10 controller + 4 widget) |
| 2026-05-02 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Phase 7B: Chrome smoke pass; dashboard, transactions, add, edit all intact |
| 2026-05-02 | Code review (no validation run) | PASS | Checklist accuracy confirmed: Phase 7C/7D UI not wired; `TransactionsPage` does not use `transactionFilterControllerProvider`; `DashboardPage` and `StatisticsPage` show all-time totals; `ReportsPage` shows all coming soon |
| 2026-05-02 | `flutter analyze` | PASS | Phase 7C: MonthSelector, TransactionFilterBar, FilteredTransactionsSummary, TransactionsPage wired filter |
| 2026-05-02 | `flutter test` | PASS | Phase 7C: 49 tests total (44 original + 5 new Phase 7C widget tests) |
| 2026-05-02 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Phase 7C: Chrome smoke pass after filter UI wiring |
| 2026-05-02 | `flutter analyze` | PASS | Phase 7D: `filterTransactionsByMonth`, `MonthlyTransactionSummary`, monthly Dashboard/Statistics wiring |
| 2026-05-02 | `flutter test` | PASS | Phase 7D: 55 tests total (49 original + 6 new Phase 7D widget tests) |
| 2026-05-03 | `flutter analyze` | PASS | Phase 8A persistence readiness audit |
| 2026-05-03 | `flutter test` | PASS | Phase 8A: 55 tests pass (44 filter/controller + 11 widget) |
| 2026-05-03 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Phase 8A: Chrome smoke pass; web fallback remains safe |
| 2026-05-03 | `flutter devices` | PASS | Phase 8A: Windows, Chrome, Edge available |
| 2026-05-03 | `flutter doctor` | WARN | Phase 8A: Android toolchain incomplete (expected; Windows target recommended for 8C) |
| 2026-05-03 | `flutter analyze` | PASS | Phase 8B: conditional imports, TransactionType hardening, widget test overrides |
| 2026-05-03 | `flutter test` | PASS | Phase 8B: 66 tests total (30 filter + 10 controller + 11 transaction_type + 15 widget) |
| 2026-05-03 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Phase 8B: web still uses InMemory; conditional imports prevent dart:ffi on web |
| 2026-05-03 | `flutter run -d windows` | FAIL | Phase 8B: Windows Developer Mode/symlink not enabled; app code is correct |
| **2026-05-03** | **`flutter analyze`** | **PASS** | **Current state: no issues found** |
| **2026-05-03** | **`flutter test`** | **PASS** | **Current state: 66 tests passed** |
| **2026-05-03** | **`flutter run -d chrome`** | **PASS** | **Current state: Chrome running, DevTools available** |
| **2026-05-03** | **`flutter run -d windows`** | **PASS** | **Phase 8C: native Drift app launch after enabling Developer Mode** |
| **2026-05-03** | **Manual persistence QA** | **PASS** | **Phase 8C: add/edit/delete transactions persisted after restart on Windows; dashboard/statistics/filter-search all correct** |
| **2026-05-03** | **`flutter analyze`** | **PASS** | **Phase 8C regression: no issues found** |
| **2026-05-03** | **`flutter test`** | **PASS** | **Phase 8C regression: 66 tests passed** |
| **2026-05-03** | **`flutter run -d chrome --web-run-headless --no-resident`** | **PASS** | **Phase 8C: web fallback remains safe** |
| **2026-05-03** | **`flutter analyze`** | **PASS** | **Phase 8D: no issues found (hardening audit)** |
| **2026-05-03** | **`flutter test`** | **PASS** | **Phase 8D: 66 tests passed (no regressions)** |
| **2026-05-03** | **`flutter run -d chrome --web-run-headless --no-resident`** | **PASS** | **Phase 8D: web fallback safe** |
| **2026-05-03** | **Docs created** | **PASS** | **Phase 8D: `PHASE_8D_PERSISTENCE_HARDENING.md` + `README.md` updated** |

## 5. Current Risks / Technical Notes

- Android toolchain chưa hoàn chỉnh: thiếu cmdline-tools/licenses. Chưa chạy trên Android (Phase 10). Persistence trên Android chưa verified.
- Export CSV/PDF/backup vẫn là "coming soon" UI, chưa implement thật (Phase 9).
- Dashboard và Statistics dùng monthly view.
- 15 widget tests override `transactionRepositoryProvider` với `InMemoryTransactionRepository` để chạy trên web và tránh native DB.
- Web persistence là InMemory theo thiết kế — không phải bug.
- Cloud sync chưa implement (Phase 12, future).

## 6. Next Actions

### Immediate Next Step

- Phase 9 — CSV/PDF Export: implement real export for CSV and PDF from the ReportsPage, pulling data from the repository.

**Alternative:** Phase 10 — Android Toolchain + APK Build if mobile is the priority.

### Last Commits

- `7c327d2` — `docs(persistence): complete phase 8 hardening and documentation` — 2026-05-03 (Phase 8D)
- `72a8d4d` — `docs(persistence): mark phase 8c native qa complete` — 2026-05-03 (Phase 8C)
