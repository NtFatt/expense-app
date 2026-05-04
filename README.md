# expense_app

A personal expense tracking application built with Flutter.

## Features

- **Add / Edit / Delete transactions** — record income and expenses with category, amount, date, and notes
- **Monthly Dashboard** — view balance, total income, total expense for the selected month
- **Transaction Management** — filter by type (all / income / expense), search by category or note, navigate by month
- **Monthly Statistics** — spending breakdown by category with `fl_chart` visualizations, top category highlight
- **Local Persistence** — transactions are saved to a local SQLite database on native platforms (Windows/Android); web uses an in-memory store
- **Report Export** — export transactions as CSV or monthly PDF report; native uses a Save As dialog, web triggers a browser download
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
| Android | `DriftTransactionRepository` | **Yes** (pending toolchain) |

This is achieved via Dart conditional imports — native database code is completely excluded from the web bundle at compile time.

## Report Export

The app supports exporting transaction data as CSV or a monthly PDF report.

### CSV Export

| Platform | Mechanism |
|----------|-----------|
| Chrome / Web | Browser download (UTF-8 BOM for Excel compatibility) |
| Windows / macOS / Linux / Android | Save As dialog via `file_selector` |

The exported CSV contains: `id`, `transaction_date`, `type`, `category`, `amount`, `signed_amount`, `note`. Transactions are sorted newest first.

### PDF Monthly Report

| Platform | Mechanism |
|----------|-----------|
| Chrome / Web | Browser download (via `package:web` Blob API) |
| Windows / macOS / Linux / Android | Save As dialog via `file_selector` |

The PDF includes a monthly title, income/expense/balance overview, category breakdown with percentages, a transaction table, and a generated-at timestamp. Vietnamese text is rendered using the bundled **Noto Sans** Unicode font (assets/fonts/NotoSans-Regular.ttf and NotoSans-Bold.ttf, OFL licensed).

### Data Backup

SQLite/Drift database backup is out of scope for Phase 9. The app's persistence is handled by the local SQLite database on native platforms.

## Validation

```bash
flutter analyze   # No issues (3 info deprecations from pdf package)
flutter test      # 133 tests
flutter run -d chrome
flutter build windows --release
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
    utils/       # Currency/date formatters
    constants/   # App constants
  features/
    transactions/ # Domain, data, controllers, pages, widgets
    categories/  # Category models and defaults
    statistics/  # Statistics pages and charts
    reports/     # Reports page (export UI)
  shared/
    widgets/     # Reusable UI components
test/
  transaction_filters_test.dart
  transaction_filter_controller_test.dart
  transaction_type_test.dart
  widget_test.dart
```

## Status

See `docs/PROJECT_PROGRESS_CHECKLIST.md` for full project roadmap and completed phases.

Current completion: **Phase 0–9** — CSV export, PDF monthly report, web browser download, native Save As dialog all implemented and validated.

Next: Phase 10 (Android Toolchain + APK Build) or Phase 11 (Final QA + Demo Script).
