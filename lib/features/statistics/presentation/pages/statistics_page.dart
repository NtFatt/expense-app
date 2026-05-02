import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/statistics/presentation/widgets/spending_by_category_chart.dart';
import 'package:expense_app/features/statistics/presentation/widgets/statistics_summary_card.dart';
import 'package:expense_app/features/statistics/presentation/widgets/top_category_card.dart';
import 'package:expense_app/features/transactions/domain/monthly_transaction_summary.dart';
import 'package:expense_app/features/transactions/domain/transaction_filters.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_filter_controller.dart';
import 'package:expense_app/features/transactions/presentation/widgets/month_selector.dart';
import 'package:expense_app/shared/widgets/app_bottom_navigation.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:expense_app/shared/widgets/empty_state.dart';
import 'package:expense_app/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

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
      title: 'Thống kê',
      bottomNavigationBar: const AppBottomNavigation(),
      child: transactionState.when(
        loading: () => const SizedBox(
          height: 320,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (Object error, StackTrace stackTrace) {
          return SizedBox(
            height: 320,
            child: Center(
              child: Text(
                'Không thể tải thống kê.\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.5),
              ),
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
                'Bức tranh tài chính hiện tại từ các giao dịch bạn đã nhập.',
                style: TextStyle(color: Color(0xFF64748B), height: 1.45),
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
              const SizedBox(height: 4),
              Center(
                child: Text(
                  _monthLabel(filter.selectedMonth),
                  key: const Key('statistics_month_label'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  StatisticsSummaryCard(
                    title: 'Tổng thu',
                    value: formatCurrency(summary.totalIncome, withSign: false),
                    icon: Icons.south_west_rounded,
                    accentColor: const Color(0xFF16A34A),
                  ),
                  StatisticsSummaryCard(
                    title: 'Tổng chi',
                    value: formatCurrency(summary.totalExpense, withSign: false),
                    icon: Icons.north_east_rounded,
                    accentColor: const Color(0xFFEA580C),
                  ),
                  StatisticsSummaryCard(
                    title: 'Số dư',
                    value: formatCurrency(summary.balance, withSign: false),
                    icon: Icons.account_balance_wallet_rounded,
                    accentColor: const Color(0xFF2563EB),
                  ),
                  StatisticsSummaryCard(
                    title: 'Số giao dịch',
                    value: summary.totalTransactions.toString(),
                    icon: Icons.receipt_long_rounded,
                    accentColor: const Color(0xFF7C3AED),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (summary.totalExpense == 0)
                EmptyState(
                  title: 'Chưa có dữ liệu chi tiêu',
                  message:
                      'Tháng này chưa có khoản chi nào để thống kê.',
                  icon: Icons.pie_chart_outline_rounded,
                  actionLabel: 'Thêm giao dịch',
                  onActionPressed: () => context.push('/transactions/new'),
                )
              else ...[
                if (summary.topExpenseCategory != null) ...[
                  TopCategoryCard(
                    summary: summary.topExpenseCategory!,
                    totalExpense: summary.totalExpense,
                  ),
                  const SizedBox(height: 24),
                ],
                SpendingByCategoryChart(
                  summaries: summary.expenseCategorySummaries,
                  totalExpense: summary.totalExpense,
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Chi tiêu theo danh mục'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      for (
                        int index = 0;
                        index < summary.expenseCategorySummaries.length;
                        index++
                      ) ...[
                        _CategoryBreakdownRow(
                          summary: summary.expenseCategorySummaries[index],
                          totalExpense: summary.totalExpense,
                        ),
                        if (index != summary.expenseCategorySummaries.length - 1)
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryBreakdownRow extends StatelessWidget {
  const _CategoryBreakdownRow({
    required this.summary,
    required this.totalExpense,
  });

  final CategoryExpenseSummary summary;
  final int totalExpense;

  @override
  Widget build(BuildContext context) {
    final double percent = summary.percentageOf(totalExpense) * 100;

    return Row(
      children: [
        Expanded(
          child: Text(
            summary.category,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          formatCurrency(summary.amount, withSign: false),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 56,
          child: Text(
            '${percent.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
