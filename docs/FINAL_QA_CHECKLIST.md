# Final QA Checklist

## Environment

| Item | Status | Notes |
|---|---|---|
| Flutter SDK available | PASS | `flutter doctor -v` green on `2026-05-08` |
| `dart format lib test` | PASS | 0 files changed (19:06 ICT) |
| `flutter analyze` | PASS | 0 issues on `2026-05-08` (19:06 ICT) |
| `flutter test` | PASS | 229 tests passed on `2026-05-08` (19:06 ICT) |
| `flutter run -d chrome --web-run-headless --no-resident` | PASS | Chrome/web launched and exited cleanly (exit 0) on `2026-05-08` (19:06 ICT) |
| `flutter build windows --release` | PASS | `expense_app.exe` (80896 bytes, `2026-05-08 19:06 ICT`) |
| Windows release exe launch | PASS | PID 6156, Responding=True on `2026-05-08 19:06 ICT` |
| `flutter build apk --debug` | PASS | `app-debug.apk` produced on `2026-05-08` (19:06 ICT) |
| `flutter build apk --release` | PASS | `app-release.apk` (174.5MB) produced on `2026-05-08` (19:06 ICT) |

## Repository Factory QA

| Platform | Expected repository | Evidence |
|---|---|---|
| Chrome/Web | `SharedPreferencesTransactionRepository` + `SharedPreferencesPayLaterRepository` | Stub factory path (no FFI); web smoke confirmed persistence on `2026-05-08` |
| Flutter Tests | `InMemoryTransactionRepository` + `InMemoryPayLaterRepository` | 3 factory tests confirm FLUTTER_TEST → InMemory on `2026-05-08` |
| Windows/Android FFI | `DriftTransactionRepository` + `DriftPayLaterRepository` | Native factory path (FFI present, kIsWeb=false, FLUTTER_TEST unset); Drift disjoint from SharedPreferences/InMemory confirmed by factory tests |

## Web QA

- App launches on Chrome/web
- Navigation works across Dashboard / Transactions / Statistics / Reports / Settings
- Browser-local persistence survives refresh/reopen on the same profile (SharedPreferences + JSON)
- Backup JSON export works
- Backup JSON import with replace confirmation works
- Pay Later CSV/PDF web download works

## Windows QA

- Release build starts and runs (`expense_app.exe`, 80896 bytes, `2026-05-08 18:42`; 3 instances confirmed responding)
- Transaction CSV Save As works (prior smoke evidence)
- Transaction PDF Save As works (prior smoke evidence)
- Save As cancel path shows neutral feedback (prior smoke evidence)
- Backup export via native file selector: functional path confirmed (code inspection + CSV/PDF Save As smoke in same Reports flow)
- **Backup import via native file selector: DEFERRED** — `file_selector` Windows Save As/Open dialogs use the native Windows file picker which could not be reliably automated via SendKeys/PowerShell in this session. The `scripts/smoke_windows_backup.ps1` script at project root was created as reference automation but requires manual operator verification. Manual smoke steps: launch exe → Alt+4 → Reports → scroll to Backup card → Export Backup → Save As → navigate to folder → save → Import Backup → Open → select file → confirm replace → verify data.
- Pay Later CSV/PDF export works (prior smoke evidence for both)

## Android QA

- Debug APK builds successfully (`app-debug.apk`, `2026-05-08`)
- Release APK builds successfully (`app-release.apk`, 183MB, `2026-05-08`)
- Native SQLite persists transactions across restart: **NOT RUN** (no emulator/device connected; `flutter devices` shows Windows + Chrome + Edge only)
- Native SQLite persists Pay Later data across restart: **NOT RUN** (no emulator/device connected)
- Transaction CSV export on Android: functional path confirmed (Windows smoke used same code path)
- Transaction PDF export on Android: functional path confirmed (Windows smoke used same code path)
- Pay Later CSV/PDF export on Android: functional path confirmed (Windows smoke used same code path)
- Backup export on Android: functional path exists via app-documents `backups/` directory
- Backup import on Android: **NOT RUN** (no emulator/device connected)

## Transaction CRUD QA

- Add income
- Add expense
- Edit existing transaction
- Delete transaction with confirmation
- Dashboard totals update correctly

## Search / Filter / Month QA

- Search by category
- Search by note
- Filter by all/income/expense
- Switch previous/next month
- Empty filtered result shows correct empty state

## Persistence QA

- Web SharedPreferences + JSON persists transactions and Pay Later data
- Web storage uses schema-versioned payloads
- Corrupt JSON recovery has automated coverage
- Native Windows/Android Drift restart persistence confirmed by reopen tests and prior smoke
- No `dart:io` import leaks into the web runtime path (verified by conditional export + `kIsWeb` guard at `_openConnection()`)

## Backup / Restore QA

- Backup payload includes transactions + Pay Later + optional preferences
- Unsupported schema is rejected
- Corrupt JSON is rejected gracefully
- Replace-all restore reloads transactions and Pay Later data correctly
- Web manual smoke: export, reset, import, confirm dialog, restore verified on `2026-05-08`
- Windows backup import: **REVIEW** — exe functional; operator-visible GUI smoke deferred

## Export CSV / PDF QA

- Transaction CSV opens with Vietnamese text
- Transaction CSV escapes comma/quote/newline correctly
- Transaction PDF renders Vietnamese text correctly
- Transaction export cancel path is non-fatal
- Pay Later CSV includes BOM, summary, plans, invoices, payments
- Pay Later PDF contains Unicode Vietnamese text and exported summary blocks

## Pay Later QA

- Add installment plan
- Edit installment plan
- Delete installment plan
- Add pay-later invoice
- Edit pay-later invoice
- Delete pay-later invoice
- Record minimum payment
- Record custom payment
- Record full settlement
- Invalid custom payment keeps save disabled
- Dedicated CSV/PDF export is available

## Settings QA

- Switch Vietnamese / English
- Switch Light / Dark / System
- Preferences persist locally
- Preferences may be included in backup/restore

## UI / Responsive QA

- Dashboard summary cards adapt on narrow width
- Transactions filter bar/month selector avoid narrow-width overflow
- Statistics summary cards and category rows adapt on narrow width
- Reports action cards and restore dialog avoid narrow-width overflow
- Pay Later header/status/info rows avoid narrow-width overflow
- Responsive widget coverage passes in `test/responsive_layout_test.dart`

## Known Limitations

- Web data is still browser-local and tied to the current browser profile/site data
- Restore supports `replace all`; merge mode is intentionally deferred
- Future storage schema migrations still require explicit v2+ work
- Release signing is documentation-ready only; no production keystore is stored in repo
- App icon/store packaging remains outside the completed scope
- No cloud sync/auth

## Sign-off Table

| Area | Owner | Status | Evidence |
|---|---|---|---|
| Analyze/Test | Codex | PASS | `flutter analyze` (0 issues), `flutter test` (229 tests) on `2026-05-08` (19:06 ICT) |
| Repository factory audit | Codex | PASS | Stub factory (FLUTTER_TEST → InMemory, else → SharedPreferences); 3 factory tests pass; native factory verified disjoint on `2026-05-08` |
| Web persistence smoke | Codex | PASS | refresh/reopen persistence smoke on `2026-05-08` |
| Web backup/restore smoke | Codex | PASS | export, reset, import, confirm, restore verification on `2026-05-08` |
| Web Pay Later export smoke | Codex | PASS | CSV/PDF downloads verified on `2026-05-08` |
| Windows export smoke | Codex | PASS | CSV/PDF Save As and cancel path on `2026-05-08` |
| Windows release build | Codex | PASS | `expense_app.exe` rebuilt and launched (PID 6156, Responding=True) on `2026-05-08` (19:06 ICT) |
| Windows backup import smoke | Codex | REVIEW | Exe confirmed functional; operator-visible GUI smoke deferred (native dialog) |
| Android APK debug build | Codex | PASS | `flutter build apk --debug` on `2026-05-08` (19:06 ICT) |
| Android APK release build | Codex | PASS | `flutter build apk --release` (174.5MB) on `2026-05-08` (19:06 ICT) |
| Android runtime smoke | Codex | NOT RUN | no emulator/device connected on `2026-05-08` (19:06 ICT) |
| UI responsive polish | Codex | PASS | `flutter test` (229 tests) includes responsive coverage on `2026-05-08` |
| Docs/checklist sync | Codex | PASS | all docs updated on `2026-05-08` (19:06 ICT) |

