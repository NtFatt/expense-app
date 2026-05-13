import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';

/// Stub file writer — signals unsupported on platforms that are not native or
/// web (e.g. the test VM during unit tests).
///
/// This file is selected by the conditional import in `report_file_writer.dart`
/// when neither `dart.library.io` nor `dart.library.js_interop` is available.
ReportFileWriter createReportFileWriter() => const _StubReportFileWriter();

class _StubReportFileWriter implements ReportFileWriter {
  const _StubReportFileWriter();

  @override
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
    String androidDirectoryName = 'reports',
  }) async {
    return const ReportFileWriteResult.unsupported();
  }
}
