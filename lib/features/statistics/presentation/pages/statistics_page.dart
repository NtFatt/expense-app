import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AppScaffold(
      title: context.strings.t(AppStringKey.statisticsTitle),
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
                '${context.strings.t(AppStringKey.couldNotLoadStatistics)}\n$error',
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
          final MonthlyTransactionSummary summary = MonthlyTransactionSummary(
            transactions: monthlyTransactions,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.strings.t(AppStringKey.statisticsSubtitle),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
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
              const SizedBox(height: 4),
              Center(
                child: Text(
                  context.strings.monthYear(filter.selectedMonth),
                  key: const Key('statistics_month_label'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
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
                    title: context.strings.t(AppStringKey.totalIncome),
                    value: formatCurrency(summary.totalIncome, withSign: false),
                    icon: Icons.south_west_rounded,
                    accentColor: const Color(0xFF16A34A),
                  ),
                  StatisticsSummaryCard(
                    title: context.strings.t(AppStringKey.totalExpense),
                    value: formatCurrency(
                      summary.totalExpense,
                      withSign: false,
                    ),
                    icon: Icons.north_east_rounded,
                    accentColor: const Color(0xFFEA580C),
                  ),
                  StatisticsSummaryCard(
                    title: context.strings.t(AppStringKey.balance),
                    value: formatCurrency(summary.balance, withSign: false),
                    icon: Icons.account_balance_wallet_rounded,
                    accentColor: const Color(0xFF2563EB),
                  ),
                  StatisticsSummaryCard(
                    title: context.strings.t(AppStringKey.transactionCount),
                    value: summary.totalTransactions.toString(),
                    icon: Icons.receipt_long_rounded,
                    accentColor: const Color(0xFF7C3AED),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (summary.totalExpense == 0)
                EmptyState(
                  title: context.strings.t(AppStringKey.noSpendingData),
                  message: context.strings.t(
                    AppStringKey.noSpendingDataMessage,
                  ),
                  icon: Icons.pie_chart_outline_rounded,
                  actionLabel: context.strings.t(AppStringKey.addTransaction),
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
                SectionHeader(
                  title: context.strings.t(AppStringKey.spendingByCategory),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colorScheme.outlineVariant),
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
                        if (index !=
                            summary.expenseCategorySummaries.length - 1)
                          Divider(
                            height: 24,
                            color: colorScheme.outlineVariant,
                          ),
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            summary.category,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          formatCurrency(summary.amount, withSign: false),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 56,
          child: Text(
            '${percent.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
