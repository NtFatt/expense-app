# Expense App - Project Progress Checklist

## 0. Project Snapshot

- Project: Expense App
- Path: `D:\LEARNCODE\Project_CV\expense_app`
- Stack: Flutter + Dart + Riverpod + GoRouter + Drift scaffold + fl_chart
- Current target: Chrome/web
- Repository factory architecture: conditional export (`dart.library.ffi`) separating web/test (stub) from native FFI (native)
- Chrome/web default repository: `SharedPreferencesTransactionRepository` + `SharedPreferencesPayLaterRepository` (stub factory, no FFI)
- Flutter test default repository: `InMemoryTransactionRepository` + `InMemoryPayLaterRepository` (stub factory + FLUTTER_TEST guard)
- Android/Desktop FFI default repository: `DriftTransactionRepository` + `DriftPayLaterRepository` (native factory, FFI present, kIsWeb=false, FLUTTER_TEST unset)
- Drift/SQLite on web: `AppDatabase._openConnection()` throws `UnsupportedError` — web never reaches Drift code
- Drift/SQLite on Android/Desktop FFI: scaffolded, reopen-tested, and confirmed reachable via native factory path
- Backup/restore implementation: versioned full-app JSON export + replace-all restore in `lib/features/backup/`
- Export implementation: transaction CSV/PDF and Pay Later CSV/PDF; Windows Save As smoke and web download smoke recorded
- Last updated: `2026-05-08` (19:06 ICT)
- Current active task: All automated gates re-confirmed passing at 19:06 ICT (analyze 0 issues, test 229 pass, chrome headless exit 0, windows release exit 0, apk debug+release exit 0). No source changes. Windows backup import smoke DEFERRED (native dialog). Android runtime smoke NOT RUN (no device). Merge restore DEFERRED (complexity/risk).
- Next recommended task: Windows backup import — manual operator session; Android runtime smoke — connect emulator/device; merge restore mode; production signing + icon.
- Risks/blockers: Android emulator/device not connected (runtime smoke NOT RUN); Windows backup import GUI smoke automation deferred (native dialog not reliable via SendKeys — manual operator session recommended); corrupt storage self-heals to seeded sample data; future v2 migrations require explicit implementation; merge restore mode deferred.

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
  Done note: Flutter project setup, Chrome target workflow, and test harness are usable. Files/modules: `pubspec.yaml`, `lib/main.dart`, `test/`. Validated by `flutter analyze` (0 issues, 19:06 ICT refresh), `flutter test` (229 tests, 19:06 ICT refresh), and `flutter run -d chrome --web-run-headless --no-resident` (exit 0, 19:06 ICT refresh).

- `[x] Phase 1 - Project structure refactor`
  Done note: Feature-first app structure is present across `lib/app/`, `lib/core/`, `lib/features/`, and `lib/shared/`. Files/modules: app shell plus feature folders. Validated by passing analyze/test on `2026-05-08` (229 tests, 18:48 ICT refresh).

- `[x] Phase 2 - Add transaction UI`
  Done note: Add-transaction routing and form flow are implemented. Files/modules: `lib/app/router.dart`, `lib/features/transactions/presentation/pages/add_transaction_page.dart`, `lib/features/transactions/presentation/widgets/transaction_form.dart`. Validated by widget tests and Chrome headless launch on `2026-05-08` (exit 0, 18:48 ICT refresh).

- `[x] Phase 3 - Domain models`
  Done note: Transaction domain models and filter/month summary models exist. Files/modules: `lib/features/transactions/domain/`, `lib/features/transactions/data/`. Validated by passing domain/widget tests on `2026-05-08` (229 tests, 18:48 ICT refresh).

- `[x] Phase 4 - Riverpod runtime state`
  Done note: Repository abstraction, controller state, and provider wiring are implemented. Files/modules: `lib/features/transactions/data/`, `lib/features/transactions/presentation/controllers/transaction_controller.dart`, `lib/main.dart`. Validated by analyze/test (229 tests, 18:48 ICT refresh) and Chrome headless launch on `2026-05-08`.

- `[L] Phase 5 - Drift/SQLite scaffold`
  Status note: Drift database/table code, repository scaffold, and reopen tests exist. Files/modules: `lib/core/database/app_database.dart`, `lib/features/transactions/data/drift_transaction_repository.dart`, `lib/features/pay_later/data/drift_pay_later_repository.dart`, `test/drift_transaction_repository_test.dart`, `test/drift_pay_later_repository_test.dart`. Validated by code inspection, passing analyze/test (229 tests, 18:48 ICT refresh), and Drift reopen tests. Scaffold-level only — Drift is excluded from web runtime via `kIsWeb` guard in `AppDatabase._openConnection()`.

- `[x] Phase 6 - MVP UX polish`
  Done note: Dashboard/statistics/reports shells, shared widgets, and bottom navigation are implemented. Files/modules: `lib/shared/widgets/`, `lib/features/statistics/`, `lib/features/reports/`. Validated by analyze/test (229 tests, 18:48 ICT refresh) and Chrome headless launch on `2026-05-08`.

- `[x] Phase 7 - Filter/Search/Monthly View/Edit Transaction`
  Done note: Edit flow, filters, search, and month navigation are wired across transactions and statistics pages. Files/modules: `lib/app/router.dart`, `lib/features/transactions/presentation/pages/`, `lib/features/transactions/presentation/widgets/`, `lib/features/transactions/presentation/controllers/`, `lib/features/statistics/presentation/pages/statistics_page.dart`. Validated by widget tests and passing test suite (229 tests, 18:48 ICT refresh) on `2026-05-08`.

- `[L] Phase 8 - Persistence layer enabled across supported targets**
  Status note: All targets have a working persistence layer. Chrome/web uses SharedPreferences (stub factory, no FFI). Flutter tests use InMemory (stub factory + FLUTTER_TEST guard). Android/Desktop FFI use Drift (native factory, FFI present, kIsWeb=false, FLUTTER_TEST unset). Phase 8 is LITE DONE because Chrome/web uses SharedPreferences, not Drift. Files/modules: `lib/core/database/`, `lib/features/transactions/data/drift_transaction_repository.dart`, `lib/features/transactions/data/shared_preferences_transaction_repository.dart`, `lib/features/transactions/data/transaction_storage_codec.dart`, `lib/features/pay_later/data/shared_preferences_pay_later_repository.dart`, `lib/features/pay_later/data/pay_later_storage_codec.dart`, `lib/features/transactions/presentation/controllers/repository_factory*.dart`, `lib/features/pay_later/data/pay_later_repository_factory*.dart`, `test/drift_transaction_repository_test.dart`, `test/drift_pay_later_repository_test.dart`, `test/transaction_storage_codec_test.dart`, `test/shared_preferences_transaction_repository_test.dart`, `test/pay_later_storage_codec_test.dart`, `test/shared_preferences_pay_later_repository_test.dart`, `test/transaction_repository_factory_test.dart`, `test/pay_later_repository_factory_test.dart`, `docs/PERSISTENCE_NOTES.md`. Validated by analyze/test (229 tests, 18:48 ICT refresh), headless Chrome run (exit 0, 18:48 ICT), native Drift reopen tests (2 tests), web codec/repository tests, corrupt-storage recovery tests, factory tests (5 tests), and manual Chrome refresh/reopen smoke on `2026-05-08`.

- `[x] Phase 8W - Web persistence**
  Done note: Chrome/web uses browser-local SharedPreferences + JSON for transactions and Pay Later (stub factory path — no `dart:ffi`). Drift is excluded from web via `kIsWeb` guard in `AppDatabase._openConnection()`. Schema-versioned payloads and no `dart:io` in the web runtime path. Files/modules: `lib/features/transactions/data/shared_preferences_transaction_repository.dart`, `lib/features/transactions/data/transaction_storage_codec.dart`, `lib/features/pay_later/data/shared_preferences_pay_later_repository.dart`, `lib/features/pay_later/data/pay_later_storage_codec.dart`, `lib/features/transactions/presentation/controllers/repository_factory_stub.dart`, `lib/features/pay_later/data/pay_later_repository_factory_stub.dart`, `docs/PERSISTENCE_NOTES.md`. Validated by analyze/test (229 tests, 18:48 ICT refresh) and manual web refresh/reopen smoke on `2026-05-08`.

- `[x] Phase 9 - CSV/PDF export**
  Done note: Transaction export generators, platform writers, structured export-result handling, and report feedback mapping are present. Windows Save As/cancel smoke and web Pay Later CSV/PDF download smoke are recorded. Files/modules: `lib/features/reports/data/`, `lib/features/reports/presentation/pages/reports_page.dart`, `lib/features/reports/presentation/report_export_feedback.dart`, `test/csv_transaction_exporter_test.dart`, `test/local_report_export_service_test.dart`, `test/report_file_namer_test.dart`, `test/report_export_result_test.dart`, `test/report_export_feedback_test.dart`, `docs/EXPORT_SMOKE_CHECKLIST.md`. Validated by `flutter analyze` (0 issues, 18:48 ICT refresh), `flutter test` (229 tests, 18:48 ICT refresh), Windows release smoke on `2026-05-08`, Desktop CSV artifact verification, PDF artifact verification, and cancel-path checks.

- `[x] Phase 9E - App preferences UI**
  Done note: Language/theme preference modules and settings route are present. Files/modules: `lib/features/settings/`, `lib/core/localization/`, `lib/app/router.dart`. Validated by `test/settings_page_test.dart`, `test/app_locale_test.dart`, `test/app_preferences_controller_test.dart`, `test/app_preferences_test.dart`, and `test/app_strings_test.dart` (229 tests, 18:48 ICT refresh).

- `[x] Phase 9F - Pay Later & installment tracker**
  Done note: Pay Later tracker domain, controller, page, dialogs, and repository factory split are present. Files/modules: `lib/features/pay_later/`, `lib/app/router.dart`, `lib/core/database/`. Validated by repository inspection and Pay Later-focused tests under `test/`.

- `[L] Phase 10 - Android toolchain + APK build**
  Status note: Android toolchain readiness is confirmed (`flutter doctor` green). APK debug and release builds produce artifacts (`app-debug.apk`, `app-release.apk` at 183MB). Package name/label are production-safe (`com.ntfatt.expenseapp`). Windows release exe rebuilt successfully (`build\windows\x64\runner\Release\expense_app.exe`, 80896 bytes, `2026-05-08 16:21 ICT`). Release builds still use debug signing (`signingConfig = signingConfigs.getByName("debug")`). Files/modules: `android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/kotlin/com/ntfatt/expenseapp/MainActivity.kt`, `pubspec.yaml`. Validated by `flutter doctor -v`, `flutter build apk --debug` (exit 0), `flutter build apk --release` (exit 0), `flutter build windows --release` (exit 0), `flutter run -d chrome --web-run-headless --no-resident` (exit 0 at 18:48 ICT), and prior Windows smoke.

- `[R] Phase 10B / 9F2 - Pay Later native persistence + Android export hardening**
  Status note: Native Pay Later Drift tables/repository and Android-specific export writer paths exist and are reachable via the native factory. Drift is confirmed disjoint from SharedPreferences/InMemory via factory tests. Android device/emulator was not connected on `2026-05-08`, so no runtime smoke was recorded. Files/modules: `lib/core/database/`, `lib/features/pay_later/data/`, `lib/features/reports/data/report_file_writer_native.dart`, `test/drift_pay_later_repository_test.dart`. Validated by tests, build commands, and prior logged Android smoke.

- `[x] Phase 11 - Final QA + demo script**
  Done note: Final QA, demo, release-readiness, persistence, and export smoke docs are present and aligned with the current repo scope. Files/modules: `README.md`, `docs/FINAL_QA_CHECKLIST.md`, `docs/DEMO_SCRIPT.md`, `docs/RELEASE_READINESS.md`, `docs/PERSISTENCE_NOTES.md`, `docs/EXPORT_SMOKE_CHECKLIST.md`. Validated by documentation inspection plus current analyze/test/headless-web/build evidence on `2026-05-08` (18:48 ICT).

- `[x] Phase 12A - Backup / Restore JSON portability**
  Done note: Full-app backup export and replace-all restore are implemented with versioned JSON, validation, file-writer abstraction reuse, and confirmation UI. Files/modules: `lib/features/backup/`, `lib/features/reports/data/report_file_writer*.dart`, `lib/features/reports/presentation/pages/reports_page.dart`, `test/app_backup_codec_test.dart`, `test/app_backup_service_test.dart`, `test/test_data/backup_fixture.dart`, `docs/PERSISTENCE_NOTES.md`. Validated by `flutter analyze` (0 issues), `flutter test` (229 tests), `flutter run -d chrome --web-run-headless --no-resident` (exit 0, 18:48 ICT), and manual web smoke on `2026-05-08` covering backup export, storage reset, import via file picker, replace confirmation, and restored data verification. Windows desktop backup export/import flow exists and exe confirmed functional; however, the native `file_selector` Save As dialog on Windows could not be reliably automated via SendKeys, so Windows desktop backup smoke is marked DEFERRED — see `scripts/smoke_windows_backup.ps1` and FINAL_QA_CHECKLIST.md.

- `[x] Phase 12B - Storage migration hardening**
  Done note: Transactions, Pay Later, and backup payloads use explicit schema-version handling, legacy compatibility, typed unsupported-version rejection, corrupt-storage raw preservation, and a migration-plan doc. Files/modules: `lib/core/persistence/unsupported_schema_version_exception.dart`, `lib/features/transactions/data/transaction_storage_codec.dart`, `lib/features/pay_later/data/pay_later_storage_codec.dart`, `lib/features/transactions/data/shared_preferences_transaction_repository.dart`, `lib/features/pay_later/data/shared_preferences_pay_later_repository.dart`, `lib/features/backup/data/app_backup_codec.dart`, `test/transaction_storage_codec_test.dart`, `test/pay_later_storage_codec_test.dart`, `test/shared_preferences_transaction_repository_test.dart`, `test/shared_preferences_pay_later_repository_test.dart`, `docs/STORAGE_MIGRATION_PLAN.md`. Validated by analyze/test (229 tests, 18:48 ICT refresh) plus codec/repository coverage for legacy decode, schema-v1 decode, unsupported future version rejection, corrupt recovery, and Vietnamese text preservation on `2026-05-08`.

- `[x] Phase 12C - Pay Later CSV/PDF export**
  Done note: Dedicated Pay Later CSV/PDF export reuses the shared export writer/result flow and is surfaced in the Reports UI. Files/modules: `lib/features/pay_later/data/pay_later_csv_exporter.dart`, `lib/features/pay_later/data/pay_later_pdf_exporter.dart`, `lib/features/pay_later/data/local_pay_later_export_service.dart`, `lib/features/pay_later/data/pay_later_export_service_provider.dart`, `lib/features/pay_later/domain/pay_later_export_request.dart`, `lib/features/pay_later/domain/pay_later_report_data.dart`, `lib/features/reports/presentation/pages/reports_page.dart`, `test/pay_later_csv_exporter_test.dart`, `test/local_pay_later_export_service_test.dart`, `test/pay_later_pdf_exporter_test.dart`, `docs/EXPORT_SMOKE_CHECKLIST.md`. Validated by `flutter analyze` (0 issues, 18:48 ICT refresh), `flutter test` (229 tests, 18:48 ICT refresh), and manual web download smoke on `2026-05-08` for both CSV and PDF artifacts.

- `[x] Phase 12D - UI/UX final polish**
  Done note: Dashboard, Transactions, Statistics, Reports, Pay Later, and Settings now have more consistent loading/error states, narrow-screen overflow fixes, responsive summary cards, and improved section/action layout behavior. Files/modules: `lib/shared/widgets/state_feedback_card.dart`, `lib/shared/widgets/metric_card.dart`, `lib/shared/widgets/section_header.dart`, `lib/features/transactions/presentation/pages/`, `lib/features/transactions/presentation/widgets/`, `lib/features/statistics/presentation/pages/statistics_page.dart`, `lib/features/reports/presentation/pages/reports_page.dart`, `lib/features/reports/presentation/widgets/report_action_card.dart`, `lib/features/pay_later/presentation/pages/pay_later_page.dart`, `lib/features/settings/presentation/pages/settings_page.dart`, `test/responsive_layout_test.dart`, `test/app_strings_test.dart`. Validated by `dart format lib test`, `flutter analyze` (0 issues, 18:48 ICT refresh), full `flutter test` (229 tests, 18:48 ICT refresh), and dedicated responsive widget coverage on `2026-05-08`.

- `[L] Phase 12E - Release polish without secrets**
  Status note: Android package name/label are production-safe (`com.ntfatt.expenseapp`), signing/store/icon docs are present, and `.gitignore` now blocks local signing files, but real keystore setup and final app/store assets remain intentionally out of repo. Release builds still use debug signing. Files/modules: `android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `.gitignore`, `docs/ANDROID_RELEASE_SIGNING.md`, `docs/STORE_RELEASE_CHECKLIST.md`, `docs/APP_ICON_GUIDE.md`. Validated by config inspection plus Android build commands and Windows exe headless smoke on `2026-05-08` (18:48 ICT).

- `[x] Phase 12F - Docs / checklist sync**
  Done note: README, QA, demo, persistence, export-smoke, release-readiness, migration, signing, store, and progress docs now reflect the current repo state, factory audit evidence, and validation evidence. Files/modules: `README.md`, `docs/FINAL_QA_CHECKLIST.md`, `docs/DEMO_SCRIPT.md`, `docs/RELEASE_READINESS.md`, `docs/PERSISTENCE_NOTES.md`, `docs/EXPORT_SMOKE_CHECKLIST.md`, `docs/STORAGE_MIGRATION_PLAN.md`, `docs/ANDROID_RELEASE_SIGNING.md`, `docs/STORE_RELEASE_CHECKLIST.md`, `docs/APP_ICON_GUIDE.md`, `docs/PROJECT_PROGRESS_CHECKLIST.md`. Validated by direct doc inspection and current phase evidence on `2026-05-08` (18:48 ICT).

- `[ ] Phase 12 - Optional cloud sync/auth**
  Status note: No backend auth/sync implementation was found in the inspected repository scope.

## 3. Current Risks / Blockers

- **Android emulator/device not connected**: No Android hardware was available on `2026-05-08` for runtime smoke. APK builds pass (debug and release), but restart persistence and export smoke on a real device are deferred.
- **Browser-local data is still tied to the current browser profile/site data** on Chrome/web.
- **Future schema changes still need explicit migration implementation** beyond the current v1 plan.
- **Corrupt transaction storage still self-heals back to seeded sample data**, which is runtime-safe but not yet an ideal user-facing recovery UX.
- **Backup/restore is available, but restore currently supports `replace all`**; merge remains deferred to avoid silent duplication/conflicts.
- **Release builds in this repository still use debug signing** for CV/demo scope.
- **No vetted master launcher-icon source asset was available** in this pass, so release icon guidance remains documentation-only.
- **Windows backup import via native file-selector flow** was not smoke-tested in this session (exe confirmed functional, but operator-visible GUI smoke for backup import was deferred).

## 4. Validation History

| Date | Command / Check | Result | Notes |
|---|---|---:|---|
| 2026-05-08 | `flutter pub get` | PASS | Dependencies resolved cleanly |
| 2026-05-08 | `flutter analyze` | PASS | 0 issues found (18:48 ICT refresh) |
| 2026-05-08 | `flutter test` | PASS | 229 tests passed (18:48 ICT refresh) |
| 2026-05-08 | `flutter run -d chrome --web-run-headless --no-resident` | PASS | Chrome/web launched and exited cleanly (exit 0, 18:48 ICT refresh) |
| 2026-05-08 | `flutter build windows --release` | PASS | `expense_app.exe` (80896 bytes, `2026-05-08 16:21 ICT`) after clean build |
| 2026-05-08 | `flutter build apk --debug` | PASS | `app-debug.apk` produced (18:42 ICT) |
| 2026-05-08 | `flutter build apk --release` | PASS | `app-release.apk` (183MB) produced (18:42 ICT) |
| 2026-05-08 | `flutter doctor -v` | PASS | Flutter, Android, Chrome, and Windows toolchains green |
| 2026-05-08 | Chrome/web transaction refresh + reopen persistence smoke | PASS | Existing transaction remained after refresh and reopen |
| 2026-05-08 | Chrome/web Pay Later refresh + reopen persistence smoke | PASS | Existing plan/invoice/payment summary remained after refresh and reopen |
| 2026-05-08 | Web backup JSON export smoke | PASS | Downloaded `expense_backup_20260508_1302.json` |
| 2026-05-08 | Web backup JSON import/restore smoke | PASS | Reset, import, replace dialog, restore verified |
| 2026-05-08 | Web Pay Later CSV/PDF export smoke | PASS | Both artifacts downloaded and verified |
| 2026-05-08 | Windows CSV/PDF Save As smoke | PASS | Artifacts produced with Vietnamese text |
| 2026-05-08 | Windows export cancel path smoke | PASS | Cancelling returned to Reports page responsively |
| 2026-05-08 | Windows backup export/import smoke | DEFERRED | `file_selector` native Save As dialog not reliably automatable via SendKeys; manual operator session recommended |
| 2026-05-08 | Android runtime smoke | NOT RUN | No emulator/device connected; `flutter devices` shows Windows + Chrome + Edge only |
| 2026-05-08 | Re-validation: `flutter pub get` | PASS | Dependencies resolved (19:06 ICT) |
| 2026-05-08 | Re-validation: `dart format lib test` | PASS | 0 files changed (19:06 ICT) |
| 2026-05-08 | Re-validation: `flutter analyze` | PASS | 0 issues (19:06 ICT) |
| 2026-05-08 | Re-validation: `flutter test` | PASS | 229 tests passed (19:06 ICT) |
| 2026-05-08 | Re-validation: Chrome headless | PASS | exit 0, 16.9s (19:06 ICT) |
| 2026-05-08 | Re-validation: `flutter build windows --release` | PASS | exit 0, 9.8s (19:06 ICT) |
| 2026-05-08 | Re-validation: `flutter build apk --debug` | PASS | `app-debug.apk` (19:06 ICT) |
| 2026-05-08 | Re-validation: `flutter build apk --release` | PASS | `app-release.apk` 174.5MB (19:06 ICT) |
| 2026-05-08 | Re-validation: `flutter devices` | 3 devices | Windows + Chrome + Edge — no Android (19:06 ICT) |
| 2026-05-08 | Windows exe launch | PASS | PID 6156, Responding=True (19:06 ICT) |
| 2026-05-08 | Windows backup import GUI smoke | DEFERRED | Native file_selector dialog not automatable (19:06 ICT) |
| 2026-05-08 | Android runtime smoke | NOT RUN | No emulator/device; no adb in PATH (19:06 ICT) |
| 2026-05-08 | Merge restore assessment | DEFERRED | Pay Later relation complexity too high for safe unsmoked implementation (19:06 ICT) |

## 5. Next Actions

1. **Windows backup import GUI smoke (manual)**: The `file_selector` native Save As dialog cannot be reliably automated via SendKeys. Run operator-visible session: launch `build\windows\x64\runner\Release\expense_app.exe` → navigate to Reports (Alt+4) → scroll to Backup card → click Export Backup → Save As dialog → navigate to desired directory → save → close dialog → click Import Backup → Open dialog → select file → confirm replace → verify data restored. See `scripts/smoke_windows_backup.ps1` for reference automation code.
2. **Android runtime smoke**: Connect an emulator or device and smoke Drift restart persistence and Pay Later export on Android.
3. **Merge restore mode**: Design and test merge mode with duplicate-resolution rules when ready.
4. **v2 storage migration rehearsal**: Future schema changes still require explicit migration code and validation.
5. **Production signing + app icon**: If distribution becomes a real goal beyond CV/demo scope, configure a real keystore and vetted master icon asset.

