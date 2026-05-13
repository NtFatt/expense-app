import 'dart:js_interop';
import 'dart:typed_data';

import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:web/web.dart' as web;

/// Web browser file writer — triggers a native browser download using a hidden
/// anchor element with the Blob URL pattern.
///
/// Uses `package:web` (the modern replacement for `dart:html`) with `dart:js_interop`
/// to ensure compatibility with current and future Flutter/Dart SDK versions.
/// This file MUST only be compiled on web targets.
ReportFileWriter createReportFileWriter() => const WebReportFileWriter();

class WebReportFileWriter implements ReportFileWriter {
  const WebReportFileWriter();

  @override
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
    String androidDirectoryName = 'reports',
  }) async {
    final Uint8List data = Uint8List.fromList(bytes);

    final JSArrayBuffer buffer = data.buffer.toJS;
    final JSArray<JSArrayBuffer> parts = [buffer].toJS;
    final web.Blob blob = web.Blob(
      parts,
      web.BlobPropertyBag(type: _mimeType(fileName)),
    );
    final String url = web.URL.createObjectURL(blob);

    try {
      final web.HTMLAnchorElement anchor = web.HTMLAnchorElement()
        ..href = url
        ..download = fileName
        ..style.cssText = 'display:none';

      web.document.body?.appendChild(anchor);
      anchor.click();
      anchor.remove();
      web.URL.revokeObjectURL(url);

      return ReportFileWriteResult.saved(fileName);
    } catch (_) {
      web.URL.revokeObjectURL(url);
      return const ReportFileWriteResult.unsupported();
    }
  }

  String _mimeType(String fileName) {
    if (fileName.toLowerCase().endsWith('.json')) {
      return 'application/json;charset=utf-8';
    }
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return 'application/pdf';
    }
    if (fileName.toLowerCase().endsWith('.csv')) {
      return 'text/csv;charset=utf-8';
    }
    return 'application/octet-stream';
  }
}
