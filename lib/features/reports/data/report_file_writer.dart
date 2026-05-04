import 'package:expense_app/features/reports/data/report_file_write_result.dart';

export 'package:expense_app/features/reports/data/report_file_writer_stub.dart'
    if (dart.library.io) 'package:expense_app/features/reports/data/report_file_writer_native.dart';

/// Abstract interface for writing bytes to a platform-appropriate location.
abstract interface class ReportFileWriter {
  /// Prompts the user to choose a save location and writes [bytes] to the
  /// chosen path on native, or signals unsupported status on web.
  ///
  /// Returns a [ReportFileWriteResult] that precisely distinguishes saved,
  /// cancelled, and unsupported outcomes.
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
  });
}
