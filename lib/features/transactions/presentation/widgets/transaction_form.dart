import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/categories/data/default_categories.dart';
import 'package:expense_app/features/categories/domain/category_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:expense_app/features/transactions/presentation/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({
    super.key,
    this.initialTransaction,
    required this.description,
    required this.submitButtonLabel,
    required this.isSubmitting,
    required this.onSubmit,
    this.amountFieldKey,
    this.submitButtonKey,
  });

  final TransactionModel? initialTransaction;
  final String description;
  final String submitButtonLabel;
  final bool isSubmitting;
  final ValueChanged<TransactionFormData> onSubmit;
  final Key? amountFieldKey;
  final Key? submitButtonKey;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late TransactionType _selectedType;
  late String _selectedCategory;
  late DateTime _selectedDate;

  List<CategoryModel> get _availableCategories =>
      defaultCategoriesForType(_selectedType);

  @override
  void initState() {
    super.initState();
    _syncFromInitialTransaction();
  }

  @override
  void didUpdateWidget(covariant TransactionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTransaction?.id != widget.initialTransaction?.id) {
      _syncFromInitialTransaction();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _syncFromInitialTransaction() {
    final TransactionModel? transaction = widget.initialTransaction;
    _selectedType = transaction?.type ?? TransactionType.expense;
    _selectedCategory =
        transaction?.category ??
        defaultCategoriesForType(_selectedType).first.name;
    _selectedDate = transaction?.transactionDate ?? DateTime.now();
    _amountController.text = transaction?.amount.toString() ?? '';
    _noteController.text = transaction?.note ?? '';

    if (!_availableCategories.any(
      (CategoryModel category) => category.name == _selectedCategory,
    )) {
      _selectedCategory = _availableCategories.first.name;
    }
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

  void _submit() {
    final FormState? formState = _formKey.currentState;
    if (formState == null || !formState.validate() || widget.isSubmitting) {
      return;
    }

    widget.onSubmit(
      TransactionFormData(
        type: _selectedType,
        amount: int.parse(_amountController.text.trim()),
        category: _selectedCategory,
        note: _normalizedNote,
        transactionDate: _selectedDate,
      ),
    );
  }

  String? get _normalizedNote {
    final String trimmedNote = _noteController.text.trim();
    if (trimmedNote.isEmpty) {
      return null;
    }

    return trimmedNote;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            TransactionTypeSelector(
              selectedType: _selectedType,
              onChanged: _handleTypeChanged,
            ),
            const SizedBox(height: 20),
            TextFormField(
              key: widget.amountFieldKey,
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: context.strings.t(AppStringKey.amount),
                hintText: context.strings.t(AppStringKey.amountHint),
                suffixText: context.strings.t(AppStringKey.currencyCode),
                helperText: context.strings.t(AppStringKey.amountHelper),
              ),
              validator: (String? value) {
                final String normalizedValue = value?.trim() ?? '';
                if (normalizedValue.isEmpty) {
                  return context.strings.t(AppStringKey.amountRequired);
                }

                final int? amount = int.tryParse(normalizedValue);
                if (amount == null || amount <= 0) {
                  return context.strings.t(AppStringKey.amountGreaterThanZero);
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: context.strings.t(AppStringKey.category),
              ),
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
              decoration: InputDecoration(
                labelText: context.strings.t(AppStringKey.note),
                hintText: context.strings.t(AppStringKey.noteHint),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.strings.t(AppStringKey.transactionDate),
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
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.strings.shortDate(_selectedDate),
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
              key: widget.submitButtonKey,
              onPressed: widget.isSubmitting ? null : _submit,
              child: widget.isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.submitButtonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionFormData {
  const TransactionFormData({
    required this.type,
    required this.amount,
    required this.category,
    required this.note,
    required this.transactionDate,
  });

  final TransactionType type;
  final int amount;
  final String category;
  final String? note;
  final DateTime transactionDate;
}
