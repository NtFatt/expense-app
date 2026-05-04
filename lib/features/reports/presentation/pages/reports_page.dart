import 'package:expense_app/features/reports/data/report_export_service_provider.dart';
import 'package:expense_app/features/reports/domain/report_export_request.dart';
import 'package:expense_app/features/reports/presentation/widgets/report_action_card.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_filter_controller.dart';
import 'package:expense_app/shared/widgets/app_bottom_navigation.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  bool _isExportingCsv = false;
  bool _isExportingPdf = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onExportCsv() async {
    if (_isExportingCsv) return;

    final AsyncValue<TransactionState> state = ref.read(
      transactionControllerProvider,
    );

    await state.when(
      data: (TransactionState data) async {
        if (data.isEmpty) {
          _showSnackBar('Không có giao dịch để xuất.');
          return;
        }

        setState(() => _isExportingCsv = true);
        try {
          final DateTime selectedMonth = ref
              .read(transactionFilterControllerProvider)
              .selectedMonth;

          final ReportExportRequest request = ReportExportRequest(
            transactions: data.transactions,
            selectedMonth: selectedMonth,
            generatedAt: DateTime.now(),
          );

          final service = ref.read(reportExportServiceProvider);
          final result = await service.exportTransactionsCsv(request);
          _showSnackBar(result.message);
        } catch (e) {
          _showSnackBar('Không thể xuất CSV. Vui lòng thử lại.');
        } finally {
          if (mounted) {
            setState(() => _isExportingCsv = false);
          }
        }
      },
      loading: () {
        _showSnackBar('Dữ liệu giao dịch đang tải, thử lại sau.');
      },
      error: (Object error, StackTrace stack) {
        _showSnackBar('Không thể đọc dữ liệu giao dịch.');
      },
    );
  }

  Future<void> _onExportPdf() async {
    if (_isExportingPdf) return;

    final AsyncValue<TransactionState> state = ref.read(
      transactionControllerProvider,
    );

    await state.when(
      data: (TransactionState data) async {
        setState(() => _isExportingPdf = true);
        try {
          final DateTime selectedMonth = ref
              .read(transactionFilterControllerProvider)
              .selectedMonth;

          final ReportExportRequest request = ReportExportRequest(
            transactions: data.transactions,
            selectedMonth: selectedMonth,
            generatedAt: DateTime.now(),
          );

          final service = ref.read(reportExportServiceProvider);
          final result = await service.exportMonthlyPdf(request);
          _showSnackBar(result.message);
        } catch (e) {
          _showSnackBar('Không thể xuất PDF. Vui lòng thử lại.');
        } finally {
          if (mounted) {
            setState(() => _isExportingPdf = false);
          }
        }
      },
      loading: () {
        _showSnackBar('Dữ liệu giao dịch đang tải, thử lại sau.');
      },
      error: (Object error, StackTrace stack) {
        _showSnackBar('Không thể đọc dữ liệu giao dịch.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Báo cáo',
      bottomNavigationBar: const AppBottomNavigation(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xuất và sao lưu dữ liệu chi tiêu cá nhân',
            style: TextStyle(color: Color(0xFF64748B), height: 1.45),
          ),
          const SizedBox(height: 20),
          ReportActionCard(
            icon: Icons.table_chart_rounded,
            title: 'Xuất CSV',
            description: 'Tải danh sách giao dịch dạng bảng để xử lý tiếp.',
            buttonLabel: _isExportingCsv ? 'Đang xuất...' : 'Xuất CSV',
            onPressed: _isExportingCsv ? () {} : _onExportCsv,
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.picture_as_pdf_rounded,
            title: 'Xuất PDF',
            description:
                'Tạo báo cáo thu chi theo tháng để chia sẻ hoặc lưu trữ.',
            buttonLabel: _isExportingPdf ? 'Đang xuất...' : 'Xuất PDF',
            onPressed: _isExportingPdf ? () {} : _onExportPdf,
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.backup_table_rounded,
            title: 'Sao lưu dữ liệu',
            description:
                'Chuẩn bị cho SQLite/Drift persistence ở các phase sau.',
            buttonLabel: 'Xem lộ trình',
            onPressed: () =>
                _showSnackBar('Sao lưu dữ liệu đang được phát triển'),
          ),
        ],
      ),
    );
  }
}
