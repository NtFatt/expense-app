/// Supported export formats for transaction reports.
enum ReportExportFormat {
  /// Comma-separated values — all transactions in tabular form.
  csv,

  /// Portable document format — formatted monthly summary report.
  pdf;

  String get extension {
    switch (this) {
      case ReportExportFormat.csv:
        return 'csv';
      case ReportExportFormat.pdf:
        return 'pdf';
    }
  }
}
