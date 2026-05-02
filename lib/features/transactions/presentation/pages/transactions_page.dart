import 'package:expense_app/features/transactions/domain/transaction_filters.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_filter_controller.dart';
import 'package:expense_app/features/transactions/presentation/widgets/delete_transaction_dialog.dart';
import 'package:expense_app/features/transactions/presentation/widgets/filtered_transactions_summary.dart';
import 'package:expense_app/features/transactions/presentation/widgets/transaction_filter_bar.dart';
import 'package:expense_app/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:expense_app/shared/widgets/app_bottom_navigation.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:expense_app/shared/widgets/empty_state.dart';
import 'package:expense_app/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  Future<void> _deleteTransaction(
    BuildContext context,
    WidgetRef ref,
    TransactionModel transaction,
  ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return const DeleteTransactionDialog();
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    try {
      await ref
          .read(transactionControllerProvider.notifier)
          .deleteTransaction(transaction.id);

      if (!context.mounted) {
        return;
      }

      messenger.showSnackBar(const SnackBar(content: Text('Đã xóa giao dịch')));
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Không thể xóa giao dịch: $error')),
      );
    }
  }

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
      title: 'Giao dịch',
      bottomNavigationBar: const AppBottomNavigation(),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('transactions_add_transaction_fab'),
        onPressed: () => context.push('/transactions/new'),
        icon: const Icon(Icons.add),
        label: const Text('Thêm giao dịch'),
      ),
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
                'Không thể tải danh sách giao dịch.\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.5),
              ),
            ),
          );
        },
        data: (TransactionState data) {
          final List<TransactionModel> filteredTransactions =
              applyTransactionFilters(
            transactions: data.transactions,
            filter: filter,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TransactionFilterBar(
                filter: filter,
                onPreviousMonth: filterCtrl.previousMonth,
                onNextMonth: filterCtrl.nextMonth,
                onTypeChanged: filterCtrl.setTypeFilter,
                onSearchChanged: filterCtrl.setSearchQuery,
                onClearSearch: filterCtrl.clearSearch,
                onClearNonMonthFilters: filterCtrl.clearNonMonthFilters,
              ),
              const SizedBox(height: 16),
              FilteredTransactionsSummary(transactions: filteredTransactions),
              const SizedBox(height: 20),
              SectionHeader(
                title: 'Danh sách giao dịch',
                actionLabel: data.isEmpty ? null : 'Thêm mới',
                onActionPressed: data.isEmpty
                    ? null
                    : () => context.push('/transactions/new'),
              ),
              const SizedBox(height: 8),
              if (data.isEmpty)
                EmptyState(
                  title: 'Chưa có giao dịch',
                  message:
                      'Hãy thêm giao dịch đầu tiên để bắt đầu theo dõi chi tiêu.',
                  icon: Icons.receipt_long_rounded,
                  actionLabel: 'Thêm giao dịch',
                  onActionPressed: () => context.push('/transactions/new'),
                )
              else if (filteredTransactions.isEmpty)
                EmptyState(
                  title: 'Không tìm thấy giao dịch phù hợp',
                  message:
                      'Thử đổi tháng, loại giao dịch hoặc từ khóa tìm kiếm.',
                  icon: Icons.search_off_rounded,
                  actionLabel: 'Xóa bộ lọc',
                  onActionPressed: filterCtrl.clearNonMonthFilters,
                )
              else
                for (final TransactionModel transaction
                    in filteredTransactions)
                  TransactionTile(
                    transaction: transaction,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          key: Key('edit_transaction_button_${transaction.id}'),
                          tooltip: 'Sửa giao dịch',
                          onPressed: () => context.push(
                            '/transactions/${transaction.id}/edit',
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Xóa giao dịch',
                          onPressed: () =>
                              _deleteTransaction(context, ref, transaction),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
