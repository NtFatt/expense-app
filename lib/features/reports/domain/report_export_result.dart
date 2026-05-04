import 'package:expense_app/features/reports/domain/report_export_format.dart';

/// Immutable result of an export operation.
///
/// Returned by [ReportExportService] methods; contains the generated file
/// metadata and a human-readable status message. Does not carry raw bytes.
final class ReportExportResult {
  const ReportExportResult({
    required this.format,
    required this.fileName,
    required this.message,
    this.filePath,
  });

  /// Which export format produced this result.
  final ReportExportFormat format;

  /// The suggested file name (includes extension), e.g. `expense_transactions_20260504_2210.csv`.
  final String fileName;

  /// A human-readable status or error message.
  final String message;

  /// Absolute path on the local filesystem where the file was saved.
  /// May be null if the file was only held in memory (e.g. web download).
  final String? filePath;

  bool get isSuccess => filePath != null || message.contains('successfully');
}
