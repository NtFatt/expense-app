import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';

export 'package:expense_app/features/reports/data/report_file_writer_stub.dart';

/// Web-stub file writer — signals unsupported on web so the browser download
/// path can be deferred to Phase 9D.
///
/// This file is used when compiling for web targets (where `dart.library.io`
/// is not available). It contains no `dart:io` imports so the web bundle
/// will not include any native file system code.
ReportFileWriter createReportFileWriter() => const _StubReportFileWriter();

class _StubReportFileWriter implements ReportFileWriter {
  const _StubReportFileWriter();

  @override
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
  }) async {
    return const ReportFileWriteResult.unsupported();
  }
}
