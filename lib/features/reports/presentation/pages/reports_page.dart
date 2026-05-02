import 'package:expense_app/features/reports/presentation/widgets/report_action_card.dart';
import 'package:expense_app/shared/widgets/app_bottom_navigation.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  void _showComingSoon(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$featureName đang được phát triển')),
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
            buttonLabel: 'Chuẩn bị xuất',
            onPressed: () => _showComingSoon(context, 'Xuất CSV'),
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.picture_as_pdf_rounded,
            title: 'Xuất PDF',
            description:
                'Tạo báo cáo thu chi theo tháng để chia sẻ hoặc lưu trữ.',
            buttonLabel: 'Chuẩn bị xuất',
            onPressed: () => _showComingSoon(context, 'Xuất PDF'),
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.backup_table_rounded,
            title: 'Sao lưu dữ liệu',
            description:
                'Chuẩn bị cho SQLite/Drift persistence ở các phase sau.',
            buttonLabel: 'Xem lộ trình',
            onPressed: () => _showComingSoon(context, 'Sao lưu dữ liệu'),
          ),
        ],
      ),
    );
  }
}
