# Expense App - Project Progress Checklist

## 0. Project Snapshot

- Project: Expense App
- Path: `D:\LEARNCODE\Project_CV\expense_app`
- Stack: Flutter + Dart + Riverpod + GoRouter + Drift scaffold + fl_chart
- Current target: Chrome/web
- Current default repository: `InMemoryTransactionRepository`
- Native persistence path present: conditional native Drift repositories exist for transactions and Pay Later, but they are not the default path on the current target
- Pay Later default repository on current target: `InMemoryPayLaterRepository`
- Export implementation: code is present in `lib/features/reports/`, but end-to-end export remains a review item until runtime smoke is treated as canonical evidence
- Last updated: `2026-05-07`
- Current active task: Reconcile native persistence/export claims with the current web-first runtime and keep the checklist conservative
- Next recommended task: Run a focused native smoke pass if Phase 8 / Phase 9 / Phase 10B need promotion beyond review

## 1. Status Legend

- `[ ] NOT STARTED`
- `[~] IN PROGRESS`
- `[x] DONE`
- `[!] BLOCKED`
- `[L] LITE DONE`
- `[R] REVIEW`
- `[F] FAILED`

## 2. Phase Checklist

- `[x] Phase 0 - Environment setup`
  Done note: Flutter project setup, Chrome target workflow, and test harness are usable. Files/modules: `pubspec.yaml`, `lib/main.dart`, `test/`. Validated by `flutter analyze`, `flutter test`, and `flutter run -d chrome --web-run-headless --no-resident`.

- `[x] Phase 1 - Project structure refactor`
  Done note: Feature-first app structure is present across `lib/app/`, `lib/core/`, `lib/features/`, and `lib/shared/`. Files/modules: app shell plus feature folders. Validated by repository inspection and passing analyze/test.

- `[x] Phase 2 - Add transaction UI`
  Done note: Add-transaction routing and form flow are implemented. Files/modules: `lib/app/router.dart`, `lib/features/transactions/presentation/pages/add_transaction_page.dart`, `lib/features/transactions/presentation/widgets/transaction_form.dart`. Validated by widget tests and Chrome launch.

- `[x] Phase 3 - Domain models`
  Done note: Transaction domain models and filter/month summary models exist. Files/modules: `lib/features/transactions/domain/`, `lib/features/categories/`. Validated by repository inspection and passing domain/widget tests.

- `[x] Phase 4 - Riverpod runtime state`
  Done note: Repository abstraction, controller state, and provider wiring are implemented. Files/modules: `lib/features/transactions/data/`, `lib/features/transactions/presentation/controllers/transaction_controller.dart`, `lib/main.dart`. Validated by analyze/test and Chrome launch.

- `[L] Phase 5 - Drift/SQLite scaffold`
  Status note: Drift database/table code and repository scaffold exist. Files/modules: `lib/core/database/`, `lib/features/transactions/data/drift_transaction_repository.dart`. Validated by code inspection and passing analyze/test; this is scaffold-level only.

- `[x] Phase 6 - MVP UX polish`
  Done note: Dashboard/statistics/reports shells, shared widgets, and bottom navigation are implemented. Files/modules: `lib/shared/widgets/`, `lib/features/statistics/`, `lib/features/reports/`. Validated by analyze/test and Chrome launch.

- `[x] Phase 7 - Filter/Search/Monthly View/Edit Transaction`
  Done note: Edit flow, filters, search, and month navigation are wired across transactions and statistics pages. Files/modules: `lib/app/router.dart`, `lib/features/transactions/presentation/pages/`, `lib/features/transactions/presentation/widgets/`, `lib/features/transactions/presentation/controllers/`, `lib/features/statistics/presentation/pages/statistics_page.dart`. Validated by widget tests and current passing test suite.

- `[R] Phase 8 - Enable SQLite/Drift persistence`
  Status note: Drift/SQLite transaction persistence is implemented behind the native conditional factory, but the current target/default runtime still uses `InMemoryTransactionRepository`. Files/modules: `lib/core/database/`, `lib/features/transactions/data/drift_transaction_repository.dart`, `lib/features/transactions/presentation/controllers/repository_factory.dart`, `repository_factory_stub.dart`, `repository_factory_native.dart`. Validated by code inspection plus existing logged native validation history; do not treat this phase as fully enabled for the current web-first project snapshot.

- `[R] Phase 9 - CSV/PDF export`
  Status note: Export generators, platform writers, and reports UI are present, including platform-specific writer branches for web and native. Files/modules: `lib/features/reports/data/`, `lib/features/reports/presentation/pages/reports_page.dart`, `test/csv_transaction_exporter_test.dart`, `test/local_report_export_service_test.dart`, `test/monthly_report_data_builder_test.dart`, `test/report_file_namer_test.dart`, `test/report_file_write_result_test.dart`. Validated by code inspection and existing logged command history; keep under review until real end-to-end export smoke is treated as canonical closure evidence.

- `[x] Phase 9E - App preferences UI`
  Done note: Language/theme preference modules and settings route are present. Files/modules: `lib/features/settings/`, `lib/core/localization/`, `lib/app/router.dart`. Validated by `test/settings_page_test.dart`, `test/app_locale_test.dart`, `test/app_preferences_controller_test.dart`, `test/app_preferences_test.dart`, and `test/app_strings_test.dart`.

- `[x] Phase 9F - Pay Later & installment tracker`
  Done note: Pay Later tracker domain, controller, page, dialogs, and repository factory split are present. Files/modules: `lib/features/pay_later/`, `lib/app/router.dart`, `lib/core/database/`. Validated by repository inspection and the Pay Later-focused tests under `test/`, including controller/page/summary/repository factory coverage.

- `[x] Phase 10 - Android toolchain + APK build`
  Done note: Existing validation history in this repository records Android toolchain readiness, emulator detection, and APK build success. Files/modules: Android build/tooling plus current project configuration in `pubspec.yaml`. Validated by logged runs of `flutter doctor -v`, `flutter build apk --debug`, `flutter build apk --release`, `flutter devices`, and `flutter run -d emulator-5554 --no-resident`.

- `[R] Phase 10B / 9F2 - Pay Later native persistence + Android export hardening`
  Status note: Native Pay Later Drift tables/repository and Android-specific export writer hardening are present in code, but this checklist keeps the sub-phase conservative because the current target remains web-first and dedicated Pay Later export is still out of scope. Files/modules: `lib/core/database/`, `lib/features/pay_later/data/`, `lib/features/pay_later/presentation/controllers/pay_later_controller.dart`, `lib/features/reports/data/report_file_writer_native.dart`. Validated by code inspection and existing logged native smoke history.

- `[ ] Phase 11 - Final QA + demo script`
  Status note: No final QA/demo artifact was found in the inspected repository scope.

- `[ ] Phase 12 - Optional cloud sync/auth`
  Status note: No backend auth/sync implementation was found in the inspected repository scope.

## 3. Current Risks / Blockers

- Chrome/web uses `InMemoryTransactionRepository` by design, so transaction data resets on refresh/restart.
- Chrome/web also keeps Pay Later in-memory by design; restart persistence is not the default behavior on the current target.
- Native Drift repository paths exist, but they are not the default runtime path for the current web-first project snapshot.
- Phase 9 remains under review until export closure evidence is treated as canonical; Windows Save As and cancel-path smoke are still the clearest remaining gap.
- Pay Later-specific CSV/PDF export is still deferred.

## 4. Validation History

| Date | Command / Check | Result | Notes |
|---|---|---:|---|
| 2026-05-06 | `git status` | PASS | Dirty worktree detected before checklist sync; no unrelated files were reverted |
| 2026-05-06 | `flutter analyze` | PASS | No issues found |
| 2026-05-06 | `flutter test` | PASS | 165 tests passed |
| 2026-05-06 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Chrome/web app launches with the current default in-memory repository |
| 2026-05-06 | `flutter build windows --release` | PASS | `build\windows\x64\runner\Release\expense_app.exe` built successfully |
| 2026-05-06 | Windows release exe launch smoke | PASS | Release exe launched and stayed running until manually terminated |
| 2026-05-07 | `git status` | PASS | Dirty worktree detected before Phase 10B work; unrelated files were preserved |
| 2026-05-07 | `flutter doctor -v` | PASS | Android toolchain and licenses are green in this environment |
| 2026-05-07 | `flutter analyze` | PASS | No issues found after Pay Later persistence/export hardening |
| 2026-05-07 | `flutter test` | PASS | 174 tests passed |
| 2026-05-07 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Web build remains safe with in-memory fallback repositories |
| 2026-05-07 | `flutter build windows --release` | PASS | Windows release build still succeeds after schema/export changes |
| 2026-05-07 | `flutter build apk --debug` | PASS | Debug APK built successfully |
| 2026-05-07 | `flutter build apk --release` | PASS | Release APK built successfully; build emitted non-blocking Kotlin daemon shutdown warnings after artifact creation |
| 2026-05-07 | `flutter devices` | PASS | Emulator `emulator-5554` detected |
| 2026-05-07 | `flutter run -d emulator-5554 --no-resident` | PASS | App launched on Android emulator for manual QA |
| 2026-05-07 | Android Pay Later restart persistence smoke | PASS | Installment plan, invoice, payment history, and zeroed summary survived force-stop + relaunch |
| 2026-05-07 | Android report export smoke | PASS | CSV and PDF were created under `app_flutter/reports/` inside the app documents directory |
| 2026-05-06 | Native Windows export Save As smoke | NOT RUN | Manual GUI verification for CSV/PDF Save As and cancel flow is still pending |

## 5. Next Actions

1. If Phase 8 needs promotion beyond review, rerun a native restart-persistence smoke and record it separately from the current web target.
2. If Phase 9 needs closure, run manual export smoke for CSV/PDF plus one cancel path and keep the evidence in a dedicated validation artifact.
3. Keep web persistence out of scope unless a separate audited phase explicitly approves browser storage.
