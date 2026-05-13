import 'package:expense_app/features/pay_later/domain/pay_later_report_data.dart';
import 'package:expense_app/features/reports/data/pdf_font_loader.dart';
import 'package:expense_app/features/reports/data/report_formatters.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract interface class PayLaterPdfExporter {
  Future<List<int>> generate(PayLaterReportData data);
}

class PdfPayLaterExporter implements PayLaterPdfExporter {
  const PdfPayLaterExporter({required PdfFontLoader fontLoader})
    : _fontLoader = fontLoader;

  final PdfFontLoader _fontLoader;

  @override
  Future<List<int>> generate(PayLaterReportData data) async {
    final PdfFontBundle fonts = await _fontLoader.load();
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (_) => _buildHeader(data, fonts),
        footer: (context) => _buildFooter(context, fonts),
        build: (context) => <pw.Widget>[
          _buildSummary(data, fonts),
          pw.SizedBox(height: 16),
          _buildPlans(data, fonts),
          pw.SizedBox(height: 16),
          _buildInvoices(data, fonts),
          pw.SizedBox(height: 16),
          _buildPayments(data, fonts),
          pw.SizedBox(height: 16),
          _buildGeneratedAt(data, fonts),
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(PayLaterReportData data, PdfFontBundle fonts) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Text(
        'BÁO CÁO TRẢ SAU & TRẢ GÓP',
        style: pw.TextStyle(font: fonts.bold, fontSize: 16),
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context, PdfFontBundle fonts) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Text(
        'Trang ${context.pageNumber} / ${context.pagesCount}',
        style: pw.TextStyle(font: fonts.regular, fontSize: 10),
      ),
    );
  }

  pw.Widget _buildSummary(PayLaterReportData data, PdfFontBundle fonts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        _sectionTitle('1. Tổng quan', fonts),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(font: fonts.bold, fontSize: 10),
          cellStyle: pw.TextStyle(font: fonts.regular, fontSize: 10),
          cellAlignments: const <int, pw.Alignment>{
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
          },
          data: <List<String>>[
            [
              'Tổng dư nợ',
              ReportFormatters.currency(data.summary.totalOutstanding.round()),
            ],
            [
              'Tối thiểu cần trả',
              ReportFormatters.currency(data.summary.totalMinimumDue.round()),
            ],
            [
              'Đã trả tháng này',
              ReportFormatters.currency(
                data.summary.totalPaidThisMonth.round(),
              ),
            ],
            ['Khoản trả góp đang mở', '${data.summary.activeInstallmentCount}'],
            ['Hóa đơn chưa trả hết', '${data.summary.unpaidInvoiceCount}'],
            ['Sắp đến hạn', '${data.summary.dueSoonCount}'],
            ['Quá hạn', '${data.summary.overdueCount}'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPlans(PayLaterReportData data, PdfFontBundle fonts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        _sectionTitle('2. Khoản trả góp', fonts),
        pw.SizedBox(height: 8),
        if (data.plans.isEmpty)
          _emptyBox('Chưa có khoản trả góp nào trong bản sao lưu.', fonts)
        else
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: fonts.bold, fontSize: 9),
            cellStyle: pw.TextStyle(font: fonts.regular, fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            headers: const <String>[
              'Tên',
              'Nhà cung cấp',
              'Còn lại',
              'Tối thiểu',
              'Kỳ còn',
              'Trạng thái',
            ],
            data: data.plans
                .map((plan) {
                  return <String>[
                    plan.title,
                    plan.providerName,
                    ReportFormatters.currency(plan.outstandingAmount.round()),
                    ReportFormatters.currency(plan.minimumAmountDue.round()),
                    '${plan.remainingInstallments}',
                    plan.status.name,
                  ];
                })
                .toList(growable: false),
          ),
      ],
    );
  }

  pw.Widget _buildInvoices(PayLaterReportData data, PdfFontBundle fonts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        _sectionTitle('3. Hóa đơn trả sau', fonts),
        pw.SizedBox(height: 8),
        if (data.invoices.isEmpty)
          _emptyBox('Chưa có hóa đơn trả sau nào trong bản sao lưu.', fonts)
        else
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: fonts.bold, fontSize: 9),
            cellStyle: pw.TextStyle(font: fonts.regular, fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            headers: const <String>[
              'Nhà cung cấp',
              'Kỳ sao kê',
              'Còn lại',
              'Tối thiểu',
              'Đến hạn',
              'Trạng thái',
            ],
            data: data.invoices
                .map((invoice) {
                  return <String>[
                    invoice.providerName,
                    ReportFormatters.monthLabel(invoice.statementMonth),
                    ReportFormatters.currency(
                      invoice.outstandingAmount.round(),
                    ),
                    ReportFormatters.currency(invoice.minimumAmountDue.round()),
                    ReportFormatters.shortDate(invoice.dueDate),
                    invoice.status.name,
                  ];
                })
                .toList(growable: false),
          ),
      ],
    );
  }

  pw.Widget _buildPayments(PayLaterReportData data, PdfFontBundle fonts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        _sectionTitle('4. Lịch sử thanh toán', fonts),
        pw.SizedBox(height: 8),
        if (data.payments.isEmpty)
          _emptyBox('Chưa có thanh toán nào được ghi nhận.', fonts)
        else
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: fonts.bold, fontSize: 9),
            cellStyle: pw.TextStyle(font: fonts.regular, fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            headers: const <String>[
              'Loại đích',
              'Mã đích',
              'Số tiền',
              'Kiểu thanh toán',
              'Ngày',
              'Ghi chú',
            ],
            data: data.payments
                .map((payment) {
                  return <String>[
                    payment.targetType.name,
                    payment.targetId,
                    ReportFormatters.currency(payment.amount.round()),
                    payment.paymentType.name,
                    ReportFormatters.shortDate(payment.paidAt),
                    payment.note ?? '',
                  ];
                })
                .toList(growable: false),
          ),
      ],
    );
  }

  pw.Widget _buildGeneratedAt(PayLaterReportData data, PdfFontBundle fonts) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Text(
        'Báo cáo được tạo lúc ${ReportFormatters.dateTime(data.generatedAt)}',
        style: pw.TextStyle(
          font: fonts.regular,
          fontSize: 9,
          color: PdfColors.grey600,
        ),
      ),
    );
  }

  pw.Widget _sectionTitle(String title, PdfFontBundle fonts) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        font: fonts.bold,
        fontSize: 13,
        color: PdfColors.blueGrey900,
      ),
    );
  }

  pw.Widget _emptyBox(String message, PdfFontBundle fonts) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        message,
        style: pw.TextStyle(font: fonts.regular, fontSize: 11),
      ),
    );
  }
}
