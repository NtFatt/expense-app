import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/widgets/transaction_form.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  static const Uuid _uuid = Uuid();

  bool _isSubmitting = false;

  Future<void> _submit(TransactionFormData formData) async {
    if (_isSubmitting) {
      return;
    }

    final DateTime now = DateTime.now();
    final TransactionModel transaction = TransactionModel(
      id: _uuid.v4(),
      type: formData.type,
      amount: formData.amount,
      category: formData.category,
      note: formData.note,
      transactionDate: formData.transactionDate,
      createdAt: now,
      updatedAt: now,
    );

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(transactionControllerProvider.notifier)
          .addTransaction(transaction);

      if (!mounted) {
        return;
      }

      context.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Đã thêm giao dịch')),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Không thể thêm giao dịch: $error')),
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
    return AppScaffold(
      title: 'Thêm giao dịch',
      contentMaxWidth: 680,
      child: TransactionForm(
        description:
            'Ghi lại một khoản thu hoặc chi để cập nhật số dư của bạn.',
        submitButtonLabel: 'Lưu giao dịch',
        isSubmitting: _isSubmitting,
        amountFieldKey: const Key('add_transaction_amount_field'),
        submitButtonKey: const Key('add_transaction_submit_button'),
        onSubmit: _submit,
      ),
    );
  }
}
