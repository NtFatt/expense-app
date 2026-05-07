import 'dart:io';

import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Native file writer.
///
/// Desktop platforms use `file_selector` Save As. Android falls back to the
/// app documents directory because `getSaveLocation` is not supported there.
/// This file MUST NOT be imported on web targets.
ReportFileWriter createReportFileWriter() => const NativeReportFileWriter();

class NativeReportFileWriter implements ReportFileWriter {
  const NativeReportFileWriter();

  @override
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
  }) async {
    if (Platform.isAndroid) {
      final File file = await _writeToAndroidDocumentsDirectory(
        fileName: fileName,
        bytes: bytes,
      );
      return ReportFileWriteResult.saved(file.path);
    }

    final location = await getSaveLocation(suggestedName: fileName);

    if (location == null) {
      return const ReportFileWriteResult.cancelled();
    }

    final file = File(location.path);
    await file.writeAsBytes(bytes, flush: true);

    return ReportFileWriteResult.saved(file.path);
  }

  Future<File> _writeToAndroidDocumentsDirectory({
    required String fileName,
    required List<int> bytes,
  }) async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final Directory exportDirectory = Directory(
      path.join(documentsDirectory.path, 'reports'),
    );
    await exportDirectory.create(recursive: true);

    final File file = await _nextAvailableFile(exportDirectory, fileName);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<File> _nextAvailableFile(Directory directory, String fileName) async {
    final String extension = path.extension(fileName);
    final String baseName = path.basenameWithoutExtension(fileName);
    File candidate = File(path.join(directory.path, fileName));
    int suffix = 1;

    while (await candidate.exists()) {
      candidate = File(
        path.join(directory.path, '${baseName}_$suffix$extension'),
      );
      suffix += 1;
    }

    return candidate;
  }
}
