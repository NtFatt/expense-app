import 'package:expense_app/features/reports/data/pdf_font_loader.dart';
import 'package:expense_app/features/reports/data/report_formatters.dart';
import 'package:expense_app/features/reports/domain/monthly_report_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Abstract interface for PDF report generation.
///
/// Implementations like [PdfMonthlyReportExporter] generate PDF bytes from
/// [MonthlyReportData]. This interface allows fake implementations for testing.
abstract interface class MonthlyPdfExporter {
  /// Generates PDF bytes from [data].
  Future<List<int>> generate(MonthlyReportData data);
}

/// Generates a monthly PDF report with Vietnamese text support.
///
/// The PDF contains a title, monthly overview totals, a category breakdown,
/// a full transaction table, and a generated-at timestamp.
class PdfMonthlyReportExporter implements MonthlyPdfExporter {
  const PdfMonthlyReportExporter({required PdfFontLoader fontLoader})
    : _fontLoader = fontLoader;

  final PdfFontLoader _fontLoader;

  /// Generates PDF bytes from [data].
  ///
  /// Throws if the font assets cannot be loaded.
  @override
  Future<List<int>> generate(MonthlyReportData data) async {
    final PdfFontBundle fonts = await _fontLoader.load();
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (_) => _buildHeader(data, fonts),
        footer: (context) => _buildFooter(context, fonts),
        build: (context) => [
          _buildOverview(data, fonts),
          pw.SizedBox(height: 16),
          _buildCategorySection(data, fonts),
          pw.SizedBox(height: 16),
          _buildTransactionSection(data, fonts),
          pw.SizedBox(height: 16),
          _buildGeneratedAt(data, fonts),
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(MonthlyReportData data, PdfFontBundle fonts) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Text(
        'BÁO CÁO CHI TIÊU ${ReportFormatters.monthLabel(data.selectedMonth).toUpperCase()}',
        style: pw.TextStyle(
          font: fonts.bold,
          fontSize: 16,
          color: PdfColors.blueGrey800,
        ),
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

  pw.Widget _buildOverview(MonthlyReportData data, PdfFontBundle fonts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('1. Tổng quan', fonts),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(font: fonts.bold, fontSize: 10),
          cellStyle: pw.TextStyle(font: fonts.regular, fontSize: 10),
          cellAlignments: const {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
          },
          data: [
            ['Tổng thu', ReportFormatters.currency(data.summary.totalIncome)],
            ['Tổng chi', ReportFormatters.currency(data.summary.totalExpense)],
            ['Số dư', ReportFormatters.currency(data.summary.balance)],
            ['Số giao dịch', '${data.transactionCount}'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildCategorySection(MonthlyReportData data, PdfFontBundle fonts) {
    final categories = data.summary.expenseCategorySummaries;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('2. Chi tiêu theo danh mục', fonts),
        pw.SizedBox(height: 8),
        if (categories.isEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              'Tháng này chưa có khoản chi nào để thống kê.',
              style: pw.TextStyle(font: fonts.regular, fontSize: 11),
            ),
          )
        else
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: fonts.bold, fontSize: 10),
            cellStyle: pw.TextStyle(font: fonts.regular, fontSize: 10),
            headerAlignments: const {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
            },
            cellAlignments: const {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
            },
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            headers: ['Danh mục', 'Số tiền', 'Tỷ lệ'],
            data: categories.map((cat) {
              final pct = cat.percentageOf(data.summary.totalExpense);
              return [
                cat.category,
                ReportFormatters.currency(cat.amount),
                ReportFormatters.percentage(pct),
              ];
            }).toList(),
          ),
      ],
    );
  }

  pw.Widget _buildTransactionSection(
    MonthlyReportData data,
    PdfFontBundle fonts,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('3. Danh sách giao dịch', fonts),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(font: fonts.bold, fontSize: 10),
          cellStyle: pw.TextStyle(font: fonts.regular, fontSize: 10),
          headerAlignments: const {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerLeft,
          },
          cellAlignments: const {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerLeft,
          },
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          headers: ['Ngày', 'Loại', 'Danh mục', 'Số tiền', 'Ghi chú'],
          data: data.transactions.isEmpty
              ? [
                  ['Không có giao dịch nào trong tháng này.', '', '', '', ''],
                ]
              : data.transactions.map((tx) {
                  final int signedAmount = tx.isIncome ? tx.amount : -tx.amount;
                  return [
                    ReportFormatters.shortDate(tx.transactionDate),
                    tx.type.label,
                    tx.category,
                    ReportFormatters.currency(signedAmount),
                    tx.note ?? '',
                  ];
                }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildGeneratedAt(MonthlyReportData data, PdfFontBundle fonts) {
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
}
