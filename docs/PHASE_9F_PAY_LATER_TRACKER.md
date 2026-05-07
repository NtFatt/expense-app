# Phase 9F — Pay Later & Installment Tracker

## Scope

Phase 9F adds a personal finance tracking module for:

- installment plans
- pay-later invoices
- recorded payments inside the app
- outstanding/minimum due summary
- overdue and due-soon visibility
- neutral policy notes

This feature is **not** a lending product and **does not** perform real payments.

## Phase History

Phase 9F originally shipped with in-memory Pay Later storage because:

- the app already uses a safe web/native repository split for transactions
- adding a second persisted schema during this phase would widen risk before Android work
- the user explicitly allowed an in-memory-first MVP if native persistence was not clearly safe

Phase 10B / 9F2 then completed the audited native persistence follow-up:

- `transactions`: existing platform-aware repositories remain intact
- `pay_later` on Windows/Android: `DriftPayLaterRepository` backed by Drift/SQLite
- `pay_later` on web/test: `InMemoryPayLaterRepository`
- `AppDatabase.schemaVersion`: upgraded from `1` to `2` with additive migration for Pay Later tables only

This keeps browser builds safe while making Android/native restart persistence real.

## Domain Model

Main models:

- `InstallmentPlan`
- `PayLaterInvoice`
- `PayLaterPayment`
- `PolicyNote`
- `PayLaterSummary`

Key enums:

- `InstallmentStatus`
- `PayLaterInvoiceStatus`
- `PayLaterPaymentType`
- `PayLaterTargetType`
- `PolicySeverity`

## Payment Action Behavior

Supported actions:

- `minimumPayment`
- `customPayment`
- `fullSettlement`

Behavior:

- Minimum payment records the current minimum amount due for the selected target.
- Custom payment validates `amount > 0` and `amount <= outstanding`.
- Full settlement records the entire remaining outstanding amount.
- Every action creates a `PayLaterPayment` record.
- The target plan/invoice is updated immediately after recording the payment.
- On native platforms, the target update plus payment insert is committed atomically in one Drift transaction.

Important note:

- Recording a payment here only updates the tracker state inside the app.
- No real banking or wallet transaction is executed.
- No `TransactionModel` is auto-created in Phase 9F.

## Policy Note Wording

Policy notes stay neutral and informational:

- minimum payment does not clear the full balance
- settlement means paying the full remaining balance
- statements summarize a billing period
- the app is for tracking only
- official due dates and fees should be verified with the provider

## UI Summary

Added UI elements:

- `PayLaterPage` at `/pay-later`
- dashboard entry card to open the tracker
- summary cards for outstanding/minimum due/due soon/overdue
- upcoming due section
- installment plan list
- pay-later invoice list
- policy notes section
- add/edit dialogs for plans and invoices
- payment action dialog

## Validation Status

Automated validation currently passes for the Pay Later module after the native persistence upgrade:

- `flutter analyze`
- `flutter test`
- `flutter run -d chrome --web-run-headless --no-resident`
- `flutter build windows --release`
- `flutter build apk --debug`
- `flutter build apk --release`

Additional Pay Later coverage now includes:

- `test/pay_later_controller_test.dart`
- `test/pay_later_invoice_test.dart`
- `test/pay_later_page_test.dart`
- `test/pay_later_summary_builder_test.dart`
- `test/pay_later_enums_test.dart`
- `test/in_memory_pay_later_repository_test.dart`
- `test/drift_pay_later_repository_test.dart`
- `test/pay_later_repository_factory_test.dart`

Android emulator manual QA on 2026-05-07 verified:

- installment plan creation
- invoice creation
- minimum payment
- custom payment
- full settlement
- force-stop + relaunch persistence

## Future Enhancements

- optional transaction linkage flow when recording pay-later payments
- richer statement history
- reminders/notifications after Android toolchain work
- optional exports for pay-later summaries
