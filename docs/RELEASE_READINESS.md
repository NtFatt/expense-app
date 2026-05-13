# Release Readiness

## What Is Production-Ready In Current Scope

- Core transaction CRUD flow
- Search/filter/month navigation
- Statistics summaries/charts
- EN/VI + theme preferences
- Chrome/web browser-local persistence (SharedPreferences + JSON)
- Native Android/Desktop Drift/SQLite persistence (via native factory)
- Transaction CSV/PDF export
- Pay Later CSV/PDF export
- Full-app backup JSON export and replace-all restore
- Schema-versioned local storage and backup payloads
- Responsive UI polish across Dashboard, Transactions, Statistics, Reports, Pay Later, and Settings

## What Is Demo-Ready

- Chrome/web walkthrough
- Windows release build story (exe rebuilt and confirmed functional on `2026-05-08 19:06 ICT`; PID 6156 Responding=True)
- Android APK build story
- Pay Later demonstration
- Backup/restore portability demonstration

## What Is Intentionally Out Of Scope

- Cloud sync
- Authentication
- Multi-device account data
- Merge restore mode
- Production keystore/secrets in repo
- Final store icon/packaging assets in repo

## Repository Factory Summary (Factory Audit — 2026-05-08)

The repository factory uses conditional export (`dart.library.ffi`):

| Target | Factory | Repository | Persistence |
|---|---|---|---|
| Chrome/Web | stub (no FFI) | `SharedPreferencesTransactionRepository` | Browser-local |
| Flutter Tests | stub + FLUTTER_TEST | `InMemoryTransactionRepository` | In-memory |
| Windows | native (FFI) | `DriftTransactionRepository` | SQLite |
| Android | native (FFI) | `DriftTransactionRepository` | SQLite |

Stub factories: `repository_factory_stub.dart` and `pay_later_repository_factory_stub.dart` — return `InMemory` under `FLUTTER_TEST`, `SharedPreferences` otherwise.

Native factories: `repository_factory_native.dart` and `pay_later_repository_factory_native.dart` — return `Drift` on Windows/Android (FFI present, kIsWeb=false, FLUTTER_TEST unset), `InMemory` as defensive fallback.

## Risk Matrix

| Risk | Severity | Current Mitigation | Remaining Gap |
|---|---|---|---|
| Browser-local data can be lost when site data is cleared | Medium | Web persistence is explicit (SharedPreferences + JSON), backup/restore exists | Still not cloud/account-based |
| Future schema change could break old local payloads | Medium | `schemaVersion`, legacy decode support, migration plan doc, tests | No v2 migration implemented yet |
| Restore overwrite can surprise users | Medium | Confirmation dialog + replace-all wording | Merge mode still deferred |
| Windows backup import not fully smoke-tested | Low/Medium | Exe confirmed functional; native file-selector path implemented; `scripts/smoke_windows_backup.ps1` created but `file_selector` native Save As dialog could not be reliably automated via SendKeys | Manual operator-visible smoke recommended |
| Android runtime smoke still missing | Medium | APK builds pass (debug + release 174.5MB at 19:06 ICT); service layer and Android backup path exist | No emulator/device connected on `2026-05-08` |
| Release signing not production-grade | Medium | Build passes, signing guide added, `.gitignore` blocks signing files | Real keystore not configured |
| App icon/store packaging incomplete | Low/Medium | Store/signing/icon docs added and existing platform icons remain | No vetted master icon asset or finished listing package in repo |

## Recommended Roadmap

1. Windows backup import operator-visible smoke
2. Android runtime smoke on connected emulator/device
3. Merge restore mode with duplicate-resolution rules
4. v2 storage migration rehearsal
5. App icon/store packaging assets
6. Optional backup encryption
7. Optional cloud sync/auth

## Release Decision

For current scope, this app is best described as:

- `demo-ready`: yes
- `local/offline real-use ready`: yes, with browser-local caveats and documented restore limits; Android/Desktop get real SQLite persistence
- `public production release-ready`: not yet, mainly due to signing/distribution/icon/cloud scope gaps

