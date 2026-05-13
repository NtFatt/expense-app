import 'package:expense_app/features/pay_later/domain/pay_later_export_request.dart';
import 'package:expense_app/features/reports/domain/report_export_result.dart';

abstract interface class PayLaterExportService {
  Future<ReportExportResult> exportPayLaterCsv(PayLaterExportRequest request);

  Future<ReportExportResult> exportPayLaterPdf(PayLaterExportRequest request);
}
