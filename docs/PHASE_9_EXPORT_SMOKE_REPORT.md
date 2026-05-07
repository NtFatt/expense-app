# Phase 9 Export Smoke Report

**Date:** 2026-05-07  
**Scope:** Reconcile current CSV/PDF export status with web evidence plus Android hardening/manual smoke

## Final Decision

**Phase 9 = REVIEW**

Reason:

- Web export smoke is fully verified in this stabilization pass.
- Android export hardening is now implemented and manually verified on emulator.
- Windows release build still passes.
- Manual Windows Save As and cancel-path smoke still is not completed in this environment, so the phase cannot be marked fully done without overstating verification.

## Web Smoke Result

| Check | Result | Evidence |
|---|---|---|
| CSV button on Reports page downloads a file | PASS | Browser download completed successfully during manual web smoke |
| CSV file name generation works | PASS | Suggested filename: `expense_transactions_20260506_1237.csv` |
| CSV includes BOM and header | PASS | File starts with `EF BB BF`; header present |
| CSV preserves Vietnamese text | PASS | `Ăn uống`, `Trà sữa`, `Bún bò`, `Lương` verified |
| CSV escapes comma/quote/newline correctly | PASS | Notes containing comma, quotes, and newlines were serialized correctly |
| CSV signed amounts are correct | PASS | Income positive, expenses negative in `signed_amount` |
| PDF button on Reports page downloads a file | PASS | Browser download completed successfully during manual web smoke |
| PDF month title and totals are correct | PASS | Text extraction shows `BÁO CÁO CHI TIÊU THÁNG 5/2026`, `Tổng thu 1.700.000 ₫`, `Tổng chi 137.000 ₫`, `Số dư 1.563.000 ₫` |
| PDF Vietnamese rendering works | PASS | Vietnamese text extracted correctly from generated PDF |
| PDF category breakdown works | PASS | `Ăn uống 92.000 ₫ 67.2%`, `Giải trí 45.000 ₫ 32.8%` verified |
| PDF empty-month export does not crash | PASS | April 2026 PDF export completed and rendered zero-state text without crash |
| Backup card remains out of scope | PASS | Reports page still shows coming-soon message for backup |

## Native Status

| Check | Result | Notes |
|---|---|---|
| Windows release build | PASS | `flutter build windows --release` succeeded |
| Windows release exe launch | PASS | `build\windows\x64\runner\Release\expense_app.exe` launched and stayed running until terminated |
| Android CSV export | PASS | Manual emulator smoke created `app_flutter/reports/expense_transactions_20260507_0209.csv` |
| Android PDF export | PASS | Manual emulator smoke created `app_flutter/reports/expense_monthly_report_2026_05.pdf` |
| Android export root cause audit | PASS | `file_selector.getSaveLocation()` is unsupported on Android; native writer now saves into app documents `reports/` |
| Native CSV Save As dialog flow | PENDING | Manual GUI verification not completed |
| Native PDF Save As dialog flow | PENDING | Manual GUI verification not completed |
| Native cancel-from-Save As flow | PENDING | Manual GUI verification not completed |

## Current Limitations

- This report does **not** claim native CSV/PDF Save As is manually verified.
- Backup export remains out of scope.
- Pay Later-specific export remains deferred.

## Recommended Next Step

Run one short manual Windows release session:

1. Launch `build\windows\x64\runner\Release\expense_app.exe`
2. Export CSV and complete Save As
3. Export PDF and complete Save As
4. Trigger one cancel from Save As and confirm no crash
5. If all three pass, update Phase 9 to `[x] DONE`
