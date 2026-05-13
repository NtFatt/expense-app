# Expense App

Expense App is an offline/local Flutter personal finance app built for strong CV/demo quality without depending on backend, cloud sync, or authentication.

## Overview

The app covers:

- Transaction CRUD with validation
- Search, type filter, and month navigation
- Dashboard and statistics
- CSV/PDF transaction export
- Pay Later / installment tracking
- EN/VI language and theme preferences
- Browser-local web persistence
- Native Drift/SQLite persistence
- Full-app backup/restore JSON portability
- Dedicated Pay Later CSV/PDF export

## Runtime Matrix

| Target | Transactions | Pay Later | Notes |
|---|---|---|---|
| Chrome/Web | SharedPreferences + JSON | SharedPreferences + JSON | Persists per browser profile/site data |
| Windows | Drift/SQLite | Drift/SQLite | Native local persistence |
| Android | Drift/SQLite | Drift/SQLite | Native local persistence |

## Backup And Export

- Transaction CSV export includes UTF-8 BOM and proper escaping for Vietnamese text.
- Transaction PDF export uses bundled Unicode fonts.
- Pay Later CSV/PDF export reuses the same platform-aware writer/result flow.
- Backup export writes versioned JSON:
  - web: browser download
  - desktop: Save As
  - Android: app-documents `backups/`
- Backup import uses replace-all restore mode on supported file-picker targets.
- Manual web backup export/import smoke passed on `2026-05-08`.

## Tech Stack

- Flutter + Dart
- Riverpod
- GoRouter
- Drift / SQLite
- fl_chart
- pdf
- file_selector
- shared_preferences

## Architecture

```text
lib/
  app/
  core/
  features/
    backup/
    pay_later/
    reports/
    settings/
    statistics/
    transactions/
  shared/
test/
docs/
```

Key decisions:

- Conditional imports keep native Drift code out of the web bundle.
- Chrome/web uses SharedPreferences-backed repositories.
- Native Windows/Android keep separate Drift repositories.
- Backup, export, and persistence stay behind repository/service abstractions.

## Run Commands

```bash
flutter pub get
flutter run -d chrome
flutter run -d windows
flutter run -d android
```

## Validation Commands

```bash
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --web-run-headless --no-resident
flutter build windows --release
flutter build apk --debug
flutter build apk --release
```

## Demo Flow

1. Dashboard overview
2. Add expense and income
3. Search/filter/month flow
4. Statistics page
5. Transaction CSV/PDF export
6. Backup JSON export/import
7. Pay Later create plan/invoice/payment
8. Pay Later CSV/PDF export
9. Settings EN/VI + theme

Detailed script: [docs/DEMO_SCRIPT.md](docs/DEMO_SCRIPT.md)

## Known Limitations

- Web persistence is browser-local, not account-based.
- Restore currently supports `replace all`; merge mode is deferred.
- Future storage schema migrations still require explicit follow-up work.
- Android release signing is documented but not configured with a real keystore in repo.
- App icon/store packaging remains documentation-ready, not store-ready.
- No cloud sync/auth by design.

## Docs

- [docs/PROJECT_PROGRESS_CHECKLIST.md](docs/PROJECT_PROGRESS_CHECKLIST.md)
- [docs/PERSISTENCE_NOTES.md](docs/PERSISTENCE_NOTES.md)
- [docs/STORAGE_MIGRATION_PLAN.md](docs/STORAGE_MIGRATION_PLAN.md)
- [docs/EXPORT_SMOKE_CHECKLIST.md](docs/EXPORT_SMOKE_CHECKLIST.md)
- [docs/FINAL_QA_CHECKLIST.md](docs/FINAL_QA_CHECKLIST.md)
- [docs/DEMO_SCRIPT.md](docs/DEMO_SCRIPT.md)
- [docs/RELEASE_READINESS.md](docs/RELEASE_READINESS.md)
- [docs/ANDROID_RELEASE_SIGNING.md](docs/ANDROID_RELEASE_SIGNING.md)
- [docs/STORE_RELEASE_CHECKLIST.md](docs/STORE_RELEASE_CHECKLIST.md)
- [docs/APP_ICON_GUIDE.md](docs/APP_ICON_GUIDE.md)
