/// Possible outcomes when attempting to write a report file to disk.
enum ReportFileWriteStatus {
  /// User confirmed the save location and the file was written.
  saved,

  /// User cancelled the save dialog; no file was written.
  cancelled,

  /// Writing is not supported on the current platform.
  unsupported,
}

/// Result of a [ReportFileWriter.writeBytes] call.
///
/// Provides a precise, unambiguous outcome rather than conflating "no path
/// returned" with "user cancelled" or "platform unsupported".
final class ReportFileWriteResult {
  const ReportFileWriteResult._({required this.status, this.filePath});

  final ReportFileWriteStatus status;
  final String? filePath;

  const ReportFileWriteResult.saved(String savedPath)
    : this._(status: ReportFileWriteStatus.saved, filePath: savedPath);

  const ReportFileWriteResult.cancelled()
    : this._(status: ReportFileWriteStatus.cancelled);

  const ReportFileWriteResult.unsupported()
    : this._(status: ReportFileWriteStatus.unsupported);

  bool get isSaved => status == ReportFileWriteStatus.saved;
  bool get isCancelled => status == ReportFileWriteStatus.cancelled;
  bool get isUnsupported => status == ReportFileWriteStatus.unsupported;
}
