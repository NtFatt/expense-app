import 'package:expense_app/features/pay_later/data/local_pay_later_export_service.dart';
import 'package:expense_app/features/pay_later/data/pay_later_csv_exporter.dart';
import 'package:expense_app/features/pay_later/data/pay_later_export_service.dart';
import 'package:expense_app/features/pay_later/data/pay_later_pdf_exporter.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary_builder.dart';
import 'package:expense_app/features/reports/data/pdf_font_loader.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final payLaterExportServiceProvider = Provider<PayLaterExportService>((
  Ref ref,
) {
  return LocalPayLaterExportService(
    csvExporter: const PayLaterCsvExporter(),
    pdfExporter: PdfPayLaterExporter(fontLoader: const PdfFontLoader()),
    fileWriter: createReportFileWriter(),
    summaryBuilder: const PayLaterSummaryBuilder(),
  );
});
