import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'report_file_writer_stub.dart';

export 'report_file_writer_stub.dart';

/// Native file writer — uses `dart:io` to write bytes to the app documents
/// directory. This file MUST NOT be imported on web targets.
ReportFileWriter createReportFileWriter() => const _NativeReportFileWriter();

class _NativeReportFileWriter implements ReportFileWriter {
  const _NativeReportFileWriter();

  @override
  Future<String?> writeBytes({
    required String fileName,
    required List<int> bytes,
  }) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
