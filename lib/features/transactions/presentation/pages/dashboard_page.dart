import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/transactions/domain/monthly_transaction_summary.dart';
import 'package:expense_app/features/pay_later/presentation/widgets/pay_later_dashboard_entry_card.dart';
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
import 'package:expense_app/shared/widgets/state_feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

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
      title: context.strings.t(AppStringKey.dashboardTitle),
      bottomNavigationBar: const AppBottomNavigation(),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('dashboard_add_transaction_fab'),
        onPressed: () => context.push('/transactions/new'),
        icon: const Icon(Icons.add),
        label: Text(context.strings.t(AppStringKey.addTransaction)),
      ),
      child: transactionState.when(
        loading: () => StateFeedbackCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 14),
              Text(
                context.strings.t(AppStringKey.loadingData),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        error: (Object error, StackTrace stackTrace) {
          return StateFeedbackCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.sync_problem_rounded,
                  size: 40,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 14),
                Text(
                  context.strings.t(AppStringKey.couldNotLoadTransactions),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
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
                context.strings.t(AppStringKey.dashboardSubtitle),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
                context.strings.monthYear(filter.selectedMonth),
                key: const Key('dashboard_month_label'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              BalanceCard(
                title: context.strings.t(AppStringKey.currentBalance),
                balance: formatCurrency(summary.balance, withSign: false),
                updatedLabel: context.strings.trackingTransactions(
                  summary.totalTransactions,
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double itemWidth = constraints.maxWidth >= 640
                      ? (constraints.maxWidth - 12) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      SizedBox(
                        width: itemWidth,
                        child: SummaryCard(
                          title: context.strings.t(AppStringKey.totalIncome),
                          amount: formatCurrency(
                            summary.totalIncome,
                            withSign: false,
                          ),
                          icon: Icons.trending_up,
                          accentColor: const Color(0xFF16A34A),
                          backgroundColor: const Color(
                            0xFF16A34A,
                          ).withValues(alpha: 0.12),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: SummaryCard(
                          title: context.strings.t(AppStringKey.totalExpense),
                          amount: formatCurrency(
                            summary.totalExpense,
                            withSign: false,
                          ),
                          icon: Icons.trending_down,
                          accentColor: const Color(0xFFEA580C),
                          backgroundColor: const Color(
                            0xFFEA580C,
                          ).withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              const PayLaterDashboardEntryCard(),
              const SizedBox(height: 24),
              SectionHeader(
                title: context.strings.t(AppStringKey.recentTransactions),
                actionLabel: context.strings.t(AppStringKey.viewAll),
                onActionPressed: () => context.go('/transactions'),
              ),
              const SizedBox(height: 8),
              if (summary.transactions.isEmpty)
                EmptyState(
                  title: context.strings.t(
                    AppStringKey.noTransactionsThisMonth,
                  ),
                  message: context.strings.t(
                    AppStringKey.noTransactionsThisMonthMessage,
                  ),
                  icon: Icons.wallet_outlined,
                  actionLabel: context.strings.t(AppStringKey.addTransaction),
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
