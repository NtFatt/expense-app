import 'package:expense_app/features/reports/domain/report_export_format.dart';

enum ReportExportStatus { saved, cancelled, unsupported, failed }

/// Immutable result of an export operation.
///
/// Returned by [ReportExportService] methods; contains the generated file
/// metadata and a human-readable status message. Does not carry raw bytes.
final class ReportExportResult {
  const ReportExportResult({
    required this.format,
    required this.fileName,
    required this.status,
    required this.message,
    this.filePath,
  });

  /// Which export format produced this result.
  final ReportExportFormat format;

  /// The suggested file name (includes extension), e.g. `expense_transactions_20260504_2210.csv`.
  final String fileName;

  /// Structured result status so UI code does not need to parse free-form text.
  final ReportExportStatus status;

  /// A human-readable status or error message.
  final String message;

  /// Platform-reported save target.
  ///
  /// - Native desktop / Android: absolute filesystem path.
  /// - Web: suggested download file name when the browser download starts.
  /// - Cancelled / unsupported / failed: null.
  final String? filePath;

  bool get isSuccess => status == ReportExportStatus.saved;
  bool get isCancelled => status == ReportExportStatus.cancelled;
  bool get isUnsupported => status == ReportExportStatus.unsupported;
  bool get isFailure => status == ReportExportStatus.failed;
}
