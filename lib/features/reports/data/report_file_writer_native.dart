import 'dart:io';

import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:file_selector/file_selector.dart';

export 'package:expense_app/features/reports/data/report_file_writer_stub.dart';

/// Native file writer — uses `file_selector` to present a Save As dialog,
/// then writes bytes to the user-chosen path. This file MUST NOT be imported
/// on web targets.
ReportFileWriter createReportFileWriter() => const NativeReportFileWriter();

class NativeReportFileWriter implements ReportFileWriter {
  const NativeReportFileWriter();

  @override
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
  }) async {
    final location = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'CSV files',
          extensions: ['csv'],
          mimeTypes: ['text/csv'],
        ),
      ],
    );

    if (location == null) {
      return const ReportFileWriteResult.cancelled();
    }

    final file = File(location.path);
    await file.writeAsBytes(bytes, flush: true);

    return ReportFileWriteResult.saved(file.path);
  }
}
