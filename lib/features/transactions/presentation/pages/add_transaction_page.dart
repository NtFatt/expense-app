import 'package:expense_app/core/utils/date_formatter.dart';
import 'package:expense_app/features/categories/data/default_categories.dart';
import 'package:expense_app/features/categories/domain/category_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/widgets/transaction_type_selector.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  late String _selectedCategory = _availableCategories.first.name;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  List<CategoryModel> get _availableCategories =>
      defaultCategoriesForType(_selectedType);

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1, 12, 31),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _handleTypeChanged(TransactionType selectedType) {
    setState(() {
      _selectedType = selectedType;
      final List<String> categoryNames = _availableCategories
          .map((CategoryModel category) => category.name)
          .toList();
      if (!categoryNames.contains(_selectedCategory)) {
        _selectedCategory = _availableCategories.first.name;
      }
    });
  }

  Future<void> _submit() async {
    final FormState? formState = _formKey.currentState;
    if (formState == null || !formState.validate() || _isSubmitting) {
      return;
    }

    final int amount = int.parse(_amountController.text.trim());
    final String trimmedNote = _noteController.text.trim();
    final DateTime now = DateTime.now();
    final TransactionModel transaction = TransactionModel(
      id: _uuid.v4(),
      type: _selectedType,
      amount: amount,
      category: _selectedCategory,
      note: trimmedNote.isEmpty ? null : trimmedNote,
      transactionDate: _selectedDate,
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ghi lại một khoản thu hoặc chi để cập nhật số dư của bạn.',
                style: TextStyle(color: Color(0xFF64748B), height: 1.45),
              ),
              const SizedBox(height: 20),
              TransactionTypeSelector(
                selectedType: _selectedType,
                onChanged: _handleTypeChanged,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('add_transaction_amount_field'),
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  hintText: 'Nhập số tiền giao dịch',
                  suffixText: 'VNĐ',
                  helperText:
                      'Chỉ nhập số dương, hệ thống tự phân loại thu/chi.',
                ),
                validator: (String? value) {
                  final String normalizedValue = value?.trim() ?? '';
                  if (normalizedValue.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }

                  final int? amount = int.tryParse(normalizedValue);
                  if (amount == null || amount <= 0) {
                    return 'Số tiền phải lớn hơn 0';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Danh mục'),
                items: _availableCategories
                    .map(
                      (CategoryModel category) => DropdownMenuItem<String>(
                        value: category.name,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  hintText: 'Ví dụ: ăn sáng, mua sách, lương tháng này...',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ngày giao dịch',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          formatShortDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('add_transaction_submit_button'),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Lưu giao dịch'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
