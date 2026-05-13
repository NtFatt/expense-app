# Phase 10B / 9F2 — Pay Later Native Persistence + Android Export Hardening

**Date:** 2026-05-07  
**Scope:** production-grade native Pay Later persistence on Android/Windows, safe web fallback retention, and Android reports export hardening

## Final Decision

**Phase 10B / 9F2 = DONE**

This pass completes the two user-reported Android issues:

- Pay Later data no longer disappears after app restart on native platforms.
- Regular Reports CSV/PDF export no longer depends on unsupported Android Save As behavior.

## What Changed

### 1. Native Pay Later persistence

- Added Drift tables for:
  - `pay_later_installment_plans`
  - `pay_later_invoices`
  - `pay_later_payments`
- Bumped `AppDatabase.schemaVersion` from `1` to `2`.
- Added `onUpgrade` migration that creates only the new Pay Later tables when upgrading from schema `1`.
- Added `DriftPayLaterRepository`.
- Added a shared `AppDatabase` provider so native transaction and Pay Later repositories use the same database instance.
- Kept web/test safe through conditional repository factories that still return in-memory adapters.

### 2. Android export hardening

Root cause:

- `file_selector.getSaveLocation()` does not support Android Save As.

Resolution:

- Desktop native platforms still use Save As.
- Android now writes CSV/PDF exports into the app documents directory under `reports/`.
- The writer auto-avoids overwriting by suffixing duplicate file names.
- No broad storage permissions or manifest hacks were added.

### 3. Scope explicitly deferred

- Pay Later-specific CSV/PDF export was **not** added in this pass.
- Reason: the release blocker was the existing Reports CSV/PDF Android path, and that path is now fixed and manually verified.

## Validation

Automated validation:

- `dart format lib test`
- `dart run build_runner build --delete-conflicting-outputs`
- `flutter analyze`
- `flutter test`
- `flutter run -d chrome --web-run-headless --no-resident`
- `flutter build windows --release`
- `flutter build apk --debug`
- `flutter build apk --release`

All commands passed in the current environment. The release APK build emitted Kotlin daemon shutdown warnings after the artifact was already produced, but the build completed successfully.

## Android Manual QA

Device:

- `emulator-5554`

Verified manually:

- added one installment plan
- added one pay-later invoice
- recorded a minimum payment
- recorded a custom payment
- completed a full settlement
- force-stopped and relaunched the app
- confirmed Pay Later summary and saved plan/invoice/payment state remained present after restart
- added one regular transaction
- exported regular Reports CSV
- exported regular Reports PDF

Evidence observed in the emulator sandbox:

- CSV created: `app_flutter/reports/expense_transactions_20260507_0209.csv`
- PDF created: `app_flutter/reports/expense_monthly_report_2026_05.pdf`

## Remaining Risks

- Windows native Save As and cancel-flow export smoke is still pending manual verification.
- Pay Later-specific export remains deferred.
- Existing Pay Later domain rules can mark an installment as settled when installment-count conditions are met even if the manually entered test data leaves residual outstanding amount; this pass did not change that rule set.

