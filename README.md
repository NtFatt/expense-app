# expense_app

A personal expense tracking application built with Flutter.

## Features

- **Add / Edit / Delete transactions** — record income and expenses with category, amount, date, and notes
- **Monthly Dashboard** — view balance, total income, total expense for the selected month
- **Transaction Management** — filter by type (all / income / expense), search by category or note, navigate by month
- **Monthly Statistics** — spending breakdown by category with `fl_chart` visualizations, top category highlight
- **Local Persistence** — transactions are saved to a local SQLite database on native platforms (Windows/Android); web uses an in-memory store

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

## Validation

```bash
flutter analyze   # No issues
flutter test      # 66 tests
flutter run -d chrome
flutter run -d windows
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

Current completion: **Phase 0–8** — all persistence infrastructure verified on Windows.

Next: Phase 9 (CSV/PDF Export) or Phase 10 (Android APK), depending on priority.
