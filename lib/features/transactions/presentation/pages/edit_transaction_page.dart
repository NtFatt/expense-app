import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/widgets/transaction_form.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:expense_app/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditTransactionPage extends ConsumerStatefulWidget {
  const EditTransactionPage({super.key, required this.transactionId});

  final String transactionId;

  @override
  ConsumerState<EditTransactionPage> createState() =>
      _EditTransactionPageState();
}

class _EditTransactionPageState extends ConsumerState<EditTransactionPage> {
  bool _isSubmitting = false;

  Future<void> _submit(
    TransactionModel existingTransaction,
    TransactionFormData formData,
  ) async {
    if (_isSubmitting) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final TransactionModel updatedTransaction = existingTransaction.copyWith(
      type: formData.type,
      amount: formData.amount,
      category: formData.category,
      note: formData.note,
      transactionDate: formData.transactionDate,
      updatedAt: DateTime.now(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(transactionControllerProvider.notifier)
          .updateTransaction(updatedTransaction);

      if (!mounted) {
        return;
      }

      context.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Đã cập nhật giao dịch')),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Không thể cập nhật giao dịch: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<TransactionState> transactionState = ref.watch(
      transactionControllerProvider,
    );

    return AppScaffold(
      title: 'Sửa giao dịch',
      contentMaxWidth: 680,
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
                'Không thể tải giao dịch.\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.5),
              ),
            ),
          );
        },
        data: (TransactionState data) {
          final TransactionModel? transaction = data.transactionById(
            widget.transactionId,
          );
          if (transaction == null) {
            return EmptyState(
              title: 'Không tìm thấy giao dịch',
              message: 'Giao dịch này có thể đã bị xóa hoặc chưa được tải.',
              icon: Icons.search_off_rounded,
              actionLabel: 'Quay lại giao dịch',
              onActionPressed: () => context.go('/transactions'),
            );
          }

          return TransactionForm(
            key: ValueKey<String>(transaction.id),
            initialTransaction: transaction,
            description: 'Chỉnh sửa thông tin giao dịch và lưu lại thay đổi.',
            submitButtonLabel: 'Cập nhật giao dịch',
            isSubmitting: _isSubmitting,
            amountFieldKey: const Key('edit_transaction_amount_field'),
            submitButtonKey: const Key('edit_transaction_submit_button'),
            onSubmit: (TransactionFormData formData) {
              _submit(transaction, formData);
            },
          );
        },
      ),
    );
  }
}
