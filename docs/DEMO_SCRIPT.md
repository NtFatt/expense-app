# Demo Script

## 3-Minute Demo

1. Open Dashboard and position the app as an offline/local finance tracker.
2. Add one expense and one income.
3. Show dashboard totals and recent transactions updating instantly.
4. Open Reports and show CSV/PDF export plus Backup JSON.
5. Open Pay Later and show summary + one tracked plan/invoice.
6. Switch EN/VI or theme in Settings.

## 5-Minute Demo

1. Dashboard overview
2. Add expense
3. Add income
4. Search/filter/month flow in Transactions
5. Statistics page
6. Reports page with transaction export and backup/restore
7. Pay Later overview with payment tracking
8. Close with persistence story across web/native

## 10-Minute Demo

1. Dashboard overview
2. Add expense
3. Add income
4. Edit one transaction
5. Search/filter/month navigation
6. Statistics and category insight
7. Transaction CSV/PDF export
8. Backup JSON export
9. Backup JSON import with replace confirmation
10. Pay Later create installment plan
11. Pay Later create invoice
12. Record a payment
13. Pay Later CSV/PDF export
14. Settings EN/VI + theme
15. Mention Windows/Android Drift path and release-readiness boundaries

## Talking Points For CV / Interview

- Feature-first Flutter architecture with Riverpod + GoRouter
- Clean platform split: web SharedPreferences + JSON, native Drift/SQLite
- Repository abstraction preserved across web/native/backup flows
- Typed schema-versioned storage plus backup codec validation
- Platform-aware export pipeline reused across transactions and Pay Later
- Strong QA story: analyze, test, builds, manual smoke, docs, and known-limitations notes

## Honest Limitation Script

- Browser-local persistence:
  - "On web, data persists in the current browser profile, but it is still local browser storage rather than account-based sync."
- Native SQLite:
  - "Windows and Android keep a separate Drift/SQLite persistence path."
- Backup/restore scope:
  - "Backup and restore are available now, but restore intentionally supports replace-all only. Merge is deferred to avoid duplicate/conflicting local data."
- Release scope:
  - "This repo is strong for CV/demo and local/offline use, but real store signing, icons, and distribution assets are intentionally kept out of source control."
- No cloud/auth:
  - "Cloud sync and authentication are still out of scope by design."

## Step-By-Step Flow

1. Dashboard overview
2. Add expense
3. Add income
4. Search/filter/month
5. Statistics
6. Export transaction report
7. Export backup JSON
8. Import backup JSON
9. Pay Later create plan/invoice/payment
10. Export Pay Later CSV/PDF
11. Settings EN/VI + theme
12. Windows/Android note

## Suggested Closing

"This is a strong offline/local Flutter app with real persistence, export, and portability. The next upgrade would be merge restore, richer migration tooling, or optional cloud sync, but the current scope stays honest and production-minded for a local-first app."

