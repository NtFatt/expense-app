import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportFileWriteResult', () {
    test('saved has path and isSaved is true', () {
      final result = ReportFileWriteResult.saved('/tmp/report.csv');
      expect(result.filePath, '/tmp/report.csv');
      expect(result.isSaved, true);
    });

    test('saved has isCancelled and isUnsupported as false', () {
      final result = ReportFileWriteResult.saved('/tmp/report.csv');
      expect(result.isCancelled, false);
      expect(result.isUnsupported, false);
    });

    test('cancelled has null path and isCancelled is true', () {
      const result = ReportFileWriteResult.cancelled();
      expect(result.filePath, isNull);
      expect(result.isCancelled, true);
    });

    test('cancelled has isSaved and isUnsupported as false', () {
      const result = ReportFileWriteResult.cancelled();
      expect(result.isSaved, false);
      expect(result.isUnsupported, false);
    });

    test('unsupported has null path and isUnsupported is true', () {
      const result = ReportFileWriteResult.unsupported();
      expect(result.filePath, isNull);
      expect(result.isUnsupported, true);
    });

    test('unsupported has isSaved and isCancelled as false', () {
      const result = ReportFileWriteResult.unsupported();
      expect(result.isSaved, false);
      expect(result.isCancelled, false);
    });
  });
}
