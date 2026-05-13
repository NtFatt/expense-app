# Export Smoke Checklist

## Goal

Track automated coverage and runtime/manual evidence for:

- transaction CSV/PDF export
- Pay Later CSV/PDF export
- backup JSON export where it shares the same writer/download path

## Automated Coverage In Repo

- Transaction CSV generator
  - UTF-8 BOM
  - Vietnamese content
  - comma/quote/newline escaping
  - deterministic file naming
- Transaction PDF service flow
  - monthly request wiring
  - saved/cancelled/unsupported/failed handling
- Pay Later CSV generator
  - UTF-8 BOM
  - summary/plans/invoices/payments sections
  - Vietnamese content
  - escaping and empty-state coverage
- Pay Later PDF service flow
  - PDF byte generation
  - deterministic file naming
  - Unicode text path through bundled fonts
- Feedback mapping
  - saved path/file name
  - cancelled message
  - failure detail handling

## Manual Smoke Matrix

| Check | Status | Notes |
|---|---|---|
| Web transaction CSV download | Covered historically | Existing web path retained |
| Web transaction PDF download | Covered historically | Existing web path retained |
| Web backup JSON download | PASS | `2026-05-08`: downloaded `expense_backup_20260508_1302.json` |
| Web Pay Later CSV download | PASS | `2026-05-08`: downloaded `expense_pay_later_20260508_1304.csv` |
| Web Pay Later PDF download | PASS | `2026-05-08`: downloaded `expense_pay_later_report_20260508_1304.pdf` |
| Windows CSV Save As | PASS | `2026-05-08`: release exe saved `expense_transactions_20260508_0223.csv` |
| Windows PDF Save As | PASS | `2026-05-08`: release exe saved `expense_monthly_report_2026_05.pdf` |
| Windows cancel Save As | PASS | `2026-05-08`: cancelling CSV/PDF kept app responsive |
| Android transaction CSV path write | Covered historically | Existing Android smoke history |
| Android transaction PDF path write | Covered historically | Existing Android smoke history |
| Android Pay Later export path | REVIEW | code path exists; manual runtime smoke not rerun in this pass |
| Vietnamese PDF font rendering | PASS | transaction Windows PDF smoke + Pay Later web PDF extraction both show intact Vietnamese text |

## Latest Evidence - 2026-05-08

- Web backup JSON export
  - Clicked `Reports -> Xuất backup JSON`
  - Downloaded `expense_backup_20260508_1302.json`
  - Verified payload contains:
    - `"schemaVersion": 1`
    - `"app": "expense_app"`
    - transaction data including `Backup smoke tx 20260508`
    - Pay Later data including `Web Plan 20260508` and `Card B`

- Web Pay Later CSV export
  - Clicked `Reports -> Xuất CSV trả sau`
  - Downloaded `expense_pay_later_20260508_1304.csv`
  - Verified:
    - BOM bytes `239,187,191`
    - summary rows
    - plan `Web Plan 20260508`
    - invoice `Card B`
    - payment history section

- Web Pay Later PDF export
  - Clicked `Reports -> Xuất PDF trả sau`
  - Downloaded `expense_pay_later_report_20260508_1304.pdf`
  - Verified:
    - file header `%PDF`
    - extracted text contains `BÁO CÁO TRẢ SAU & TRẢ GÓP`
    - extracted text contains `Web Plan 20260508`
    - extracted text contains `Card B`

- Windows CSV Save As
  - Built `build\windows\x64\runner\Release\expense_app.exe` (`2026-05-08 16:21`)
  - Opened `Reports -> Export CSV -> Save As`
  - Saved `C:\Users\LENOVO\Desktop\expense_transactions_20260508_0223.csv`
  - Artifact check: UTF-8 BOM present and Vietnamese category `Ăn uống` is intact

- Windows PDF Save As
  - Saved `C:\Users\LENOVO\Desktop\expense_monthly_report_2026_05.pdf`
  - Artifact check: extracted text contains `BÁO CÁO CHI TIÊU THÁNG 5/2026`, `Ăn uống`, `Chi tiêu`
  - Visual check: rendered artifact showed Vietnamese glyphs correctly

- Windows cancel path
  - Cancelled CSV Save As
  - Cancelled PDF Save As
  - App stayed responsive
  - Feedback remained neutral

