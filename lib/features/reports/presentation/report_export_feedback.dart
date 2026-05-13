import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_result.dart';

String buildReportExportFeedback(
  AppStrings strings,
  ReportExportResult result,
) {
  final String successPrefix = result.format == ReportExportFormat.csv
      ? strings.t(AppStringKey.csvExported)
      : strings.t(AppStringKey.pdfExported);

  switch (result.status) {
    case ReportExportStatus.saved:
      final String target = result.filePath ?? result.fileName;
      return '$successPrefix: $target';
    case ReportExportStatus.cancelled:
      return result.format == ReportExportFormat.csv
          ? strings.t(AppStringKey.csvExportCancelled)
          : strings.t(AppStringKey.pdfExportCancelled);
    case ReportExportStatus.unsupported:
      return result.format == ReportExportFormat.csv
          ? strings.t(AppStringKey.csvExportUnsupported)
          : strings.t(AppStringKey.pdfExportUnsupported);
    case ReportExportStatus.failed:
      final String fallback = result.format == ReportExportFormat.csv
          ? strings.t(AppStringKey.couldNotExportCsv)
          : strings.t(AppStringKey.couldNotExportPdf);
      return result.message.isEmpty ? fallback : '$fallback ${result.message}';
  }
}
