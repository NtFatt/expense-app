import 'package:expense_app/features/reports/data/csv_transaction_exporter.dart';
import 'package:expense_app/features/reports/data/local_report_export_service.dart';
import 'package:expense_app/features/reports/data/monthly_report_data_builder.dart';
import 'package:expense_app/features/reports/data/pdf_font_loader.dart';
import 'package:expense_app/features/reports/data/pdf_monthly_report_exporter.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/reports/data/report_export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:expense_app/features/reports/data/report_export_service.dart'
    show ReportExportService;

final reportExportServiceProvider = Provider<ReportExportService>((Ref ref) {
  return LocalReportExportService(
    csvExporter: const CsvTransactionExporter(),
    fileWriter: createReportFileWriter(),
    monthlyReportDataBuilder: const MonthlyReportDataBuilder(),
    pdfExporter: PdfMonthlyReportExporter(fontLoader: const PdfFontLoader()),
  );
});
