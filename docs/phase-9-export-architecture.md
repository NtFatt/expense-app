# Phase 9 — Export Architecture Document

> Created during Phase 9A. Contains design decisions, data source mapping, and implementation notes for Phase 9B/9C/9D. No real export code is implemented in Phase 9A.

---

## 1. Phase 9 Scope

| Sub-phase | Name | Status |
|---|---|---|
| 9A | Export Architecture & Contract | **Current** |
| 9B | CSV Export | Not started |
| 9C | PDF Export | Not started |
| 9D | Export UX / Integration | Not started |

### Out of Scope for Phase 9

- Backup/export backup functionality (ReportsPage "Sao lưu dữ liệu" card remains "coming soon").
- Web download implementation (may be added in 9B/9D if straightforward).
- Cloud sync or sharing endpoints.

---

## 2. Phase 9A Decisions

### 2.1 Domain Contracts Created

| File | Purpose |
|---|---|
| `lib/features/reports/domain/report_export_format.dart` | Enum: `csv`, `pdf` |
| `lib/features/reports/domain/report_export_request.dart` | Immutable request: transactions, selectedMonth, generatedAt |
| `lib/features/reports/domain/report_export_result.dart` | Immutable result: format, fileName, message, filePath |
| `lib/features/reports/data/report_export_service.dart` | Abstract interface: `exportTransactionsCsv`, `exportMonthlyPdf` |
| `lib/features/reports/data/report_file_namer.dart` | Pure-Dart name generators |

### 2.2 File Naming Convention

| Format | Pattern | Example |
|---|---|---|
| CSV | `expense_transactions_YYYYMMDD_HHmm.csv` | `expense_transactions_20260504_2210.csv` |
| PDF | `expense_monthly_report_YYYY_MM.pdf` | `expense_monthly_report_2026_05.pdf` |

- Uses zero-padded month/day/hour/minute (no `intl` dependency needed).
- `generatedAt` = wall-clock export timestamp (for CSV).
- `selectedMonth` = month being reported on (for PDF).

### 2.3 Data Source Mapping

#### CSV Export — All Transactions

```
Data source : TransactionRepository.getTransactions()
Provider     : transactionControllerProvider (AsyncNotifier)
              -> TransactionState.transactions
How to call  : await repository.getTransactions()
              (full unfiltered list)
```

#### PDF Export — Monthly Report

```
Data source  : TransactionRepository.getTransactions()
Providers    : transactionControllerProvider (all transactions)
             + transactionFilterControllerProvider (selectedMonth)
Filter       : filterTransactionsByMonth(transactions, selectedMonth)
              (from lib/features/transactions/domain/transaction_filters.dart)
Content      : MonthlyTransactionSummary from all-filtered-month transactions
```

### 2.4 Service Interface Design

```dart
abstract interface class ReportExportService {
  Future<ReportExportResult> exportTransactionsCsv(ReportExportRequest request);
  Future<ReportExportResult> exportMonthlyPdf(ReportExportRequest request);
}
```

- No `BuildContext` dependency.
- No `SnackBar` or UI calls in service.
- `ReportExportRequest` carries the pre-filtered transaction list from the UI layer.
- Platform save strategy is deferred to 9B/9C (see below).

### 2.5 Platform Save Strategy (Design)

This section documents the intended strategy without implementing it in 9A.

#### Native (Windows / Android)

- Use `path_provider` (already in `pubspec.yaml`) to get `getApplicationDocumentsDirectory()`.
- Write file bytes to `$directory/$fileName` using `dart:io` `File`.
- Return `ReportExportResult` with populated `filePath`.
- **TODO 9B/9C**: Implement `ReportExportService` that writes to `path_provider` directory on native.
- Conditional imports may be needed to exclude `dart:io` from the web bundle (pattern already established by `repository_factory.dart`).

#### Web (Chrome / Web)

- **TODO 9B/9D**: Implement web file save using browser download APIs (e.g. `dart:html` `AnchorElement` with `download` attribute or a web-compatible package).
- Must not crash on web — export functions should either succeed or return a result with `filePath: null` and an informative `message`.
- The app currently runs with `InMemoryTransactionRepository` on web — web export would export that in-memory data.

---

## 3. PDF Font Strategy

### Current State

- `pubspec.yaml`: **No font assets declared.**
- `assets/` folder: **Does not exist** in the project root.
- Existing packages: `pdf`, `printing`, or PDF-related packages — **Not present** in `pubspec.yaml`.
- `intl` package: **Present** (`^0.20.2`), can be used for date/number formatting in PDF if needed.

### Required for Phase 9C

To support Vietnamese text in PDF:

1. **Acquire a legal Unicode font** that covers Vietnamese (Latin Extended characters with diacritics).
   - Candidates: Noto Sans (Google Fonts, OFL license), DejaVu Sans (OFL), or similar open-source Unicode font.
   - Font must support: `ă, â, đ, ê, ô, ơ, ư, ơ, ạ, ả, ấ, ầ, ậ, ...` (Vietnamese diacritics).
2. **Add the font asset** to the project:
   - Download the `.ttf` file to a project directory (e.g. `assets/fonts/NotoSans/`).
   - Register in `pubspec.yaml` under the `flutter/fonts` section.
3. **Load the font** in the PDF generator (using `pdf` package's `Font` API: `PdfGoogleFont.notoSansRegular()`, or load from asset bytes).
4. **Use the font** for all text rendering in the PDF document.

### TODO for Phase 9C

```
[TODO 9C] Add Vietnamese Unicode font asset for PDF export:
  - Acquire OFL-licensed font covering Vietnamese (e.g. Noto Sans or DejaVu Sans)
  - Place .ttf file in assets/fonts/ directory
  - Register font in pubspec.yaml under flutter/fonts
  - Load font in PDF generator (pdf package Font API)
  - Apply font to all TextPainter / paragraph calls
  - Do NOT download font automatically at runtime
  - Do NOT use proprietary or unlicenced fonts
```

---

## 4. Package Audit

### Currently in `pubspec.yaml`

| Package | Version | Used by |
|---|---|---|
| `flutter_riverpod` | `^3.3.1` | All state management |
| `go_router` | `^17.2.2` | Navigation |
| `intl` | `^0.20.2` | Date/number formatting |
| `uuid` | `^4.5.3` | Transaction ID generation |
| `fl_chart` | `^1.2.0` | Statistics charts |
| `drift` | `^2.32.1` | SQLite ORM |
| `sqlite3_flutter_libs` | `^0.6.0+eol` | SQLite native libs |
| `path_provider` | `^2.1.5` | App documents directory |
| `path` | `^1.9.1` | Path manipulation |

### Packages NOT in `pubspec.yaml` — Required for Phase 9B/9C

| Package | Purpose | Phase |
|---|---|---|
| `pdf` | PDF document generation | 9C |
| `printing` | PDF preview/print/share | 9C |

**No new packages should be added in Phase 9A.** Both `pdf` and `printing` are deferred to Phase 9C. A CSV generator does not require any new package — pure Dart `StringBuffer` is sufficient.

---

## 5. What Was NOT Done in Phase 9A

- No real CSV generation (no `StringBuffer` serialization of `TransactionModel`).
- No real PDF generation (no `pdf` package usage).
- No file system write (no `dart:io` File write, no `path_provider` integration).
- No web download implementation.
- `ReportsPage` buttons remain as `ComingSoon` SnackBar — not wired to the new service.
- No changes to `TransactionModel`, persistence layer, or any existing architecture.

---

## 6. Next Steps for Phase 9B

1. Implement `ReportExportService` concrete class (or factory) in `lib/features/reports/data/`.
2. Implement CSV serialization: convert `List<TransactionModel>` to CSV string using `StringBuffer`.
3. Implement native file save: write bytes to `path_provider` directory.
4. Wire `ReportsPage` CSV button to call the service via a Riverpod provider/hook.
5. Add unit tests for CSV generation logic.
6. Add unit tests for `ReportFileNamer`.
7. Ensure web bundle does not include `dart:io` — use conditional imports (existing pattern from `repository_factory.dart`).

---

## 7. Next Steps for Phase 9C

1. Add `pdf` and `printing` packages to `pubspec.yaml`.
2. Acquire and register a Vietnamese Unicode font in `pubspec.yaml`.
3. Implement PDF generation using `MonthlyTransactionSummary` and category breakdown.
4. Implement PDF file save (same native path_provider approach as CSV).
5. Wire `ReportsPage` PDF button to the service.
6. Add unit tests for PDF generation logic.

---

## 8. Next Steps for Phase 9D

1. Add success/error `SnackBar` UX after export.
2. Implement web download flow using browser APIs.
3. Add optional share functionality (`printing` package share on mobile).
4. Audit all export error paths (disk full, permission denied, no transactions, etc.).
5. Consider adding export format selection in a bottom sheet if UX warrants.

---

## 9. Audit Summary

| Item | Finding |
|---|---|
| `ReportsPage` audited | 3 action cards (CSV, PDF, Backup); CSV/PDF buttons call `_showComingSoon` |
| `ReportActionCard` audited | Stateless; accepts `onPressed`; button label parameterised |
| `transactionControllerProvider` | `AsyncNotifierProvider`; exposes `TransactionState.transactions` |
| `transactionFilterControllerProvider` | `NotifierProvider`; exposes `selectedMonth` |
| `filterTransactionsByMonth` | Pure function in `transaction_filters.dart`; non-mutating |
| `TransactionModel` fields | `id, type, amount, category, note, transactionDate, createdAt, updatedAt` |
| `MonthlyTransactionSummary` | `totalIncome, totalExpense, balance, transactions, expenseByCategory` |
| `TransactionRepository` | `getTransactions()` returns full list |
| Existing export code | **None found** — clean slate for export architecture |
| `assets/fonts/` folder | **Does not exist** |
| `pdf` / `printing` packages | **Not present** in `pubspec.yaml` |
| `intl` package | **Present** (`^0.20.2`) — available for date/number formatting |
| `path_provider` | **Present** (`^2.1.5`) — available for native file paths |
| `dart:io` / `File` usage | Only in `app_database.dart` for SQLite path; isolated there |
| Reports `domain/` folder | **Did not exist** — created fresh |
| Reports `data/` folder | **Did not exist** — created fresh |
