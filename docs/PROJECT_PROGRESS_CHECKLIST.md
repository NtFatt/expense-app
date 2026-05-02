# Expense App — Project Progress Checklist

## 0. Project Snapshot

- Project: Expense App
- Path: `D:\LEARNCODE\Project_CV\expense_app`
- Stack: Flutter + Dart + Riverpod + GoRouter + Drift scaffold + fl_chart
- Current run target: Chrome/web
- Current default repository: `InMemoryTransactionRepository`
- Persistence status: Drift scaffolded but not enabled by default
- Current validation status: `flutter pub get`, `flutter analyze`, `flutter test`, `flutter run -d chrome --web-run-headless --no-resident` PASS
- Last updated: `2026-05-02` (Phase 7B — Filter/Search Controller)

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
| 5 | Drift/SQLite Scaffold | `[L]` | Đã scaffold Drift table/database/repository | build_runner/analyze/test pass | Chưa bật persistence thật |
| 6 | MVP UX Polish | `[x]` | Bottom nav, statistics, reports, polish UX các page chính | pub get/analyze/test/chrome pass | Chrome/web vẫn an toàn |
| 7 | Filter/Search/Monthly View/Edit Transaction | `[~]` | Phase 7A and 7B done; filter UI/monthly dashboard/statistics pending | analyze/test/chrome pass for 7B | Next Phase 7C transactions filter UI |
| 8 | Enable SQLite/Drift Persistence | `[ ]` | Chưa bật Drift mặc định | Chưa chạy | Phụ thuộc native QA |
| 9 | CSV/PDF Export | `[ ]` | Chưa implement export thật | Chưa chạy | UI reports mới ở mức preparation |
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
- Dữ liệu runtime hiện mất sau reload vì repo mặc định là in-memory.

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
- [ ] Enable Drift as default repository
- [ ] Persist transactions after reload
- [ ] Native target QA
- [ ] Migration strategy

**Validation:**
- [x] `dart run build_runner build --delete-conflicting-outputs`
- [x] `flutter analyze`
- [x] `flutter test`
- [x] Chrome safe because Drift is not default

**Notes:**
- Drift is scaffolded but not enabled by default.
- Current default repository is still `InMemoryTransactionRepository`.
- Reason: current active target is Chrome/web. Do not break web demo.

**Next step:**
- Polish MVP UX/navigation/statistics while keeping web safe.

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
- [x] Reports page polished with CSV/PDF/Backup cards
- [x] Keep InMemory repository as default
- [x] Preserve Drift scaffold
- [x] Update widget tests

**Validation:**
- [x] `flutter pub get`
- [x] `flutter analyze`
- [x] `flutter test`
- [x] `flutter run -d chrome --web-run-headless --no-resident`

**Notes:**
- Reports mới là UI preparation, chưa export thật.
- Statistics đã đọc số liệu thật từ provider state.

**Next step:**
- Start Phase 7 with filters, monthly view and edit transaction flow.

### Phase 7 — Filter/Search/Monthly View/Edit Transaction

**Status:** `[~] IN PROGRESS` (7A done; 7B done; 7C/7D pending)

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
- `TransactionForm` is now shared between add and edit, eliminating code duplication.
- Form pre-fills with existing transaction data on edit.
- In-memory update works correctly; Drift `updateTransaction` is scaffolded for when persistence is enabled.
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
- Drift remains scaffolded but not enabled by default.
- `applyTransactionFilters` is a pure function that does not mutate the input list.

**Next step:**
- Phase 7C — Transactions Filter UI.

#### Phase 7C — Transactions Filter UI

**Status:** `[ ] NOT STARTED`  
**Goal:** Wire filter state to UI with month selector, type chips, and search bar.  
**Scope:** Filter bar widget, month selector widget, type filter chips, search input, wiring to controller.  

**Checklist:**
- [ ] Create filter bar widget
- [ ] Wire month selector
- [ ] Wire type filter chips
- [ ] Wire search input
- [ ] Show active filter count

**Validation:**
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] `flutter run -d chrome`

**Next step:**
- Connect filter UI to controller.

#### Phase 7D — Monthly Dashboard + Statistics

**Status:** `[ ] NOT STARTED`  
**Goal:** Make dashboard and statistics respect the selected month/filter.  
**Scope:** Dashboard monthly totals, statistics monthly breakdown, filter-aware charts.  

**Checklist:**
- [ ] Dashboard shows monthly totals based on filter
- [ ] Statistics page shows monthly breakdown
- [ ] Charts respect selected month
- [ ] No-data states for months with no transactions

**Validation:**
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] `flutter run -d chrome`
- [ ] Manual monthly view verification

**Next step:**
- Wire monthly filter to dashboard and statistics.

### Phase 8 — Enable SQLite/Drift Persistence

**Status:** `[ ] NOT STARTED`  
**Goal:** Switch from runtime memory state to real local persistence on native targets.  
**Scope:** Repository switching strategy, native QA, persistence after restart, migration handling.  
**Files touched/expected:** `lib/features/transactions/presentation/controllers/transaction_controller.dart`, repository providers, `lib/core/database/app_database.dart`, native-friendly startup wiring if needed.

**Checklist:**
- [ ] Fix Android toolchain or choose Windows target for native persistence QA
- [ ] Decide repository switching strategy
- [ ] Keep web fallback safe
- [ ] Enable Drift repository on native
- [ ] Verify add transaction persists after app restart
- [ ] Verify delete persists after app restart
- [ ] Add migration versioning
- [ ] Add repository tests if possible

**Validation:**
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] `flutter run -d windows` or `flutter run -d android`
- [ ] restart app persistence check

**Notes:**
- Do not enable Drift default if Chrome/web breaks.
- Use `kIsWeb` guard or explicit repository provider strategy.

**Next step:**
- Finish Phase 7 first so data UX does not shift again after persistence rollout.

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
- Chưa nên làm trước khi persistence strategy ổn định.

**Next step:**
- Decide export format contracts and target platforms first.

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

## 5. Current Risks / Technical Notes

- Android toolchain chưa hoàn chỉnh: thiếu cmdline-tools/licenses.
- Drift scaffold đã có nhưng chưa bật default repository.
- Web/Chrome hiện an toàn vì dùng `InMemoryTransactionRepository`.
- Export CSV/PDF/backup mới là UI, chưa implement thật.
- In-memory data mất khi reload app.
- Cần commit sau mỗi phase pass validation.
- Phase 7B provides logic only; UI wiring remains pending in Phase 7C.

## 6. Next Actions

### Immediate Next Step

- Start Phase 7C: Wire filter state to UI with month selector, type chips, and search bar on the transactions page.

### Recommended Git Commit

```powershell
git status
git add .
git commit -m "feat(transactions): add filter search controller"
```
