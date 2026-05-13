import 'package:expense_app/features/reports/data/report_file_write_result.dart';

export 'package:expense_app/features/reports/data/report_file_writer_stub.dart'
    if (dart.library.io) 'package:expense_app/features/reports/data/report_file_writer_native.dart'
    if (dart.library.js_interop) 'package:expense_app/features/reports/data/report_file_writer_web.dart';

/// Abstract interface for writing bytes to a platform-appropriate location.
abstract interface class ReportFileWriter {
  /// Writes [bytes] to a platform-appropriate destination and returns a
  /// [ReportFileWriteResult] that precisely distinguishes saved, cancelled,
  /// and unsupported outcomes.
  ///
  /// - On desktop native (Windows/macOS/Linux): opens a Save As dialog via
  ///   `file_selector` so the user picks the destination path.
  /// - On Android: writes to the app documents directory because Save As is
  ///   not supported by the current `file_selector` package there.
  /// - On web (Chrome/Firefox/Safari): triggers a browser download using a
  ///   Blob URL so the browser saves the file.
  /// - In other environments (e.g. test VM): returns `unsupported`.
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
    String androidDirectoryName = 'reports',
  });
}
