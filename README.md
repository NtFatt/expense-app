# expense_app

A personal expense tracking application built with Flutter.

## Features

- **Add / Edit / Delete transactions** — record income and expenses with category, amount, date, and notes
- **Monthly Dashboard** — view balance, total income, total expense for the selected month
- **Transaction Management** — filter by type (all / income / expense), search by category or note, navigate by month
- **Monthly Statistics** — spending breakdown by category with `fl_chart` visualizations, top category highlight
- **Local Persistence** — transactions are saved to a local SQLite database on native platforms (Windows/Android); web uses an in-memory store
- **Report Export** — export transactions as CSV or monthly PDF report; web downloads in-browser, desktop native uses Save As, Android saves into the app documents `reports/` folder
- **Preferences** — switch app language (Vietnamese/English) and theme (Light/Dark/System); preferences persist locally
- **Pay Later & Installment Tracker** — track installment plans, pay-later invoices, minimum/custom/full-settlement records, overdue/due-soon status, and neutral policy notes
- **PDF Vietnamese Support** — PDF reports render Vietnamese text correctly using bundled Noto Sans Unicode font (OFL licensed)

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| State Management | Riverpod |
| Routing | GoRouter |
| Local Database | Drift / SQLite |
| Charts | fl_chart |
| Language | Dart |

## Persistence

The app uses a **platform-aware repository strategy**:

| Platform | Repository | Persists between sessions |
|----------|-----------|--------------------------|
| Chrome / Web | `InMemoryTransactionRepository` | No (data resets on reload) |
| Windows | `DriftTransactionRepository` | **Yes** — `expense_app.sqlite` |
| Android | `DriftTransactionRepository` | **Yes** |

This is achieved via Dart conditional imports — native database code is completely excluded from the web bundle at compile time.

For current release policy:

- **Web/Chrome is demo-only by design** for transaction persistence in the MVP.
- **Windows/native is the validated Drift persistence path.**
- **Android uses the same native path and is now validated in Phase 10B.**

For Pay Later:

- **Windows / Android** use a dedicated `DriftPayLaterRepository` and persist across restart.
- **Chrome / Web + tests** stay on `InMemoryPayLaterRepository` by design for this phase.

## Report Export

The app supports exporting transaction data as CSV or a monthly PDF report.

### CSV Export

| Platform | Mechanism |
|----------|-----------|
| Chrome / Web | Browser download (UTF-8 BOM for Excel compatibility) |
| Windows / macOS / Linux | Save As dialog via `file_selector` |
| Android | Save to app documents `reports/` directory |

The exported CSV contains: `id`, `transaction_date`, `type`, `category`, `amount`, `signed_amount`, `note`. Transactions are sorted newest first.

### PDF Monthly Report

| Platform | Mechanism |
|----------|-----------|
| Chrome / Web | Browser download (via `package:web` Blob API) |
| Windows / macOS / Linux | Save As dialog via `file_selector` |
| Android | Save to app documents `reports/` directory |

The PDF includes a monthly title, income/expense/balance overview, category breakdown with percentages, a transaction table, and a generated-at timestamp. Vietnamese text is rendered using the bundled **Noto Sans** Unicode font (assets/fonts/NotoSans-Regular.ttf and NotoSans-Bold.ttf, OFL licensed).

### Data Backup

SQLite/Drift database backup is out of scope for Phase 9. The app's persistence is handled by the local SQLite database on native platforms.

### Current Export Hardening Status

- Web CSV export smoke: verified
- Web PDF export smoke: verified
- Web empty-month PDF smoke: verified
- Android CSV export smoke: verified
- Android PDF export smoke: verified
- Windows release build: verified
- Native Windows Save As manual smoke: pending

## Preferences

- **Language** — Vietnamese (`vi`) and English (`en`)
- **Theme** — Light, Dark, or System
- **Persistence** — saved locally with `shared_preferences`
- **Localization approach** — lightweight typed strings (`AppLocale`, `AppStringKey`, `AppStrings`) designed to migrate cleanly to Flutter ARB/gen-l10n later

## Pay Later & Installment Tracker

- **What it tracks** — installment plans, pay-later invoices, outstanding balances, minimum due, next due date, overdue/due-soon status, and recorded payments inside the app
- **Current persistence scope** — native platforms now persist Pay Later with Drift/SQLite; web/test remain in-memory by design
- **What it does not do** — no real payment, no lending, no bank integration, no legal/financial advice, no automatic transaction creation when a pay-later payment is recorded
- **User wording** — the UI stays neutral and focuses on tracking, estimates, and payment record-keeping only
- **Current export scope** — no dedicated Pay Later CSV/PDF export is included in this phase

## Validation

```bash
flutter analyze   # No issues
flutter test      # 174 tests
flutter run -d chrome --web-run-headless --no-resident
flutter build windows --release
flutter build apk --debug
flutter build apk --release
```

## Getting Started

```bash
flutter pub get
flutter run -d chrome
```

For native builds, enable Windows Developer Mode first:

```powershell
start ms-settings:developers
```

## Project Structure

```
lib/
  app/           # App shell, router, theme
  core/
    database/    # Drift tables and AppDatabase
    localization/# Typed lightweight localization layer
    utils/       # Currency/date formatters
    constants/   # App constants
  features/
    transactions/ # Domain, data, controllers, pages, widgets
    categories/  # Category models and defaults
    statistics/  # Statistics pages and charts
    reports/     # Reports page (export UI)
    settings/    # App preferences: locale + theme mode
    pay_later/   # Installment plans, pay-later invoices, payment tracking
  shared/
    widgets/     # Reusable UI components
test/
  app_locale_test.dart
  app_strings_test.dart
  app_preferences_controller_test.dart
  transaction_filters_test.dart
  transaction_filter_controller_test.dart
  transaction_type_test.dart
  widget_test.dart
```

## Status

See `docs/PROJECT_PROGRESS_CHECKLIST.md` for full project roadmap and completed phases.

Canonical current truth:

- Phase 8: native transaction persistence done; web remains demo-only in-memory by design; Android native path is now verified
- Phase 9: web export smoke verified; Android export hardened and manually verified; Windows manual Save As smoke still pending, so export remains under review
- Phase 9E: done
- Phase 9F / 10B: Pay Later is persisted on native via Drift, while web/test remain in-memory by design
- Phase 10: Android toolchain, APK builds, and emulator smoke are complete

Next: finish native Windows export Save As smoke and decide separately whether Pay Later-specific export should be added in a future phase.
