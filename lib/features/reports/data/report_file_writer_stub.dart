/// Web-stub file writer — returns null to indicate unsupported on web.
///
/// This file is used when compiling for web targets (where `dart.library.io`
/// is not available). It contains no `dart:io` imports so the web bundle
/// will not include any native file system code.
ReportFileWriter createReportFileWriter() => const _StubReportFileWriter();

/// Stub writer: does not write to the filesystem on web.
class _StubReportFileWriter implements ReportFileWriter {
  const _StubReportFileWriter();

  @override
  Future<String?> writeBytes({
    required String fileName,
    required List<int> bytes,
  }) async {
    return null;
  }
}

/// Abstract interface for writing bytes to a platform-appropriate location.
abstract interface class ReportFileWriter {
  /// Writes [bytes] to a file named [fileName] in the platform documents directory.
  ///
  /// Returns the absolute path on success, or `null` if writing is not supported
  /// on the current platform.
  Future<String?> writeBytes({
    required String fileName,
    required List<int> bytes,
  });
}
