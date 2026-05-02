import 'package:expense_app/core/constants/app_constants.dart';
import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/transactions/domain/monthly_transaction_summary.dart';
import 'package:expense_app/features/transactions/domain/transaction_filters.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_filter_controller.dart';
import 'package:expense_app/features/transactions/presentation/widgets/balance_card.dart';
import 'package:expense_app/features/transactions/presentation/widgets/month_selector.dart';
import 'package:expense_app/features/transactions/presentation/widgets/summary_card.dart';
import 'package:expense_app/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:expense_app/shared/widgets/app_bottom_navigation.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:expense_app/shared/widgets/empty_state.dart';
import 'package:expense_app/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  static const List<String> _months = [
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4',
    'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8',
    'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
  ];

  String _monthLabel(DateTime month) =>
      '${_months[month.month - 1]} ${month.year}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<TransactionState> transactionState = ref.watch(
      transactionControllerProvider,
    );
    final TransactionFilterState filter = ref.watch(
      transactionFilterControllerProvider,
    );
    final TransactionFilterController filterCtrl = ref.read(
      transactionFilterControllerProvider.notifier,
    );

    return AppScaffold(
      title: AppConstants.dashboardTitle,
      bottomNavigationBar: const AppBottomNavigation(),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('dashboard_add_transaction_fab'),
        onPressed: () => context.push('/transactions/new'),
        icon: const Icon(Icons.add),
        label: const Text('Thêm giao dịch'),
      ),
      child: transactionState.when(
        loading: () =>
            const _DashboardFeedbackState(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) {
          return _DashboardFeedbackState(
            child: Text(
              'Không thể tải giao dịch.\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.5),
            ),
          );
        },
        data: (TransactionState data) {
          final List<TransactionModel> monthlyTransactions =
              filterTransactionsByMonth(
            transactions: data.transactions,
            selectedMonth: filter.selectedMonth,
          );
          final MonthlyTransactionSummary summary =
              MonthlyTransactionSummary(transactions: monthlyTransactions);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Theo dõi thu chi cá nhân của bạn',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MonthSelector(
                    selectedMonth: filter.selectedMonth,
                    onPreviousMonth: filterCtrl.previousMonth,
                    onNextMonth: filterCtrl.nextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _monthLabel(filter.selectedMonth),
                key: const Key('dashboard_month_label'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              BalanceCard(
                balance: formatCurrency(summary.balance, withSign: false),
                updatedLabel:
                    'Đang theo dõi ${summary.totalTransactions} giao dịch',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Thu nhập',
                      amount:
                          formatCurrency(summary.totalIncome, withSign: false),
                      icon: Icons.trending_up,
                      accentColor: const Color(0xFF16A34A),
                      backgroundColor: const Color(0xFFF0FDF4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Chi tiêu',
                      amount:
                          formatCurrency(summary.totalExpense, withSign: false),
                      icon: Icons.trending_down,
                      accentColor: const Color(0xFFEA580C),
                      backgroundColor: const Color(0xFFFFF7ED),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Giao dịch tháng này',
                actionLabel: 'Xem tất cả',
                onActionPressed: () => context.go('/transactions'),
              ),
              const SizedBox(height: 8),
              if (summary.transactions.isEmpty)
                EmptyState(
                  title: 'Chưa có giao dịch tháng này',
                  message:
                      'Thêm giao dịch mới hoặc chuyển sang tháng khác để xem dữ liệu.',
                  icon: Icons.wallet_outlined,
                  actionLabel: 'Thêm giao dịch',
                  onActionPressed: () => context.push('/transactions/new'),
                )
              else
                for (final TransactionModel transaction
                    in summary.recentTransactions(limit: 5))
                  TransactionTile(transaction: transaction),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardFeedbackState extends StatelessWidget {
  const _DashboardFeedbackState({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 320, child: Center(child: child));
  }
}
