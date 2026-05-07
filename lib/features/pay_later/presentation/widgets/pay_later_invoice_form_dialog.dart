import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:flutter/material.dart';

class PayLaterInvoiceFormResult {
  const PayLaterInvoiceFormResult({
    required this.providerName,
    required this.statementMonth,
    required this.statementDate,
    required this.dueDate,
    required this.totalAmount,
    required this.minimumPaymentAmount,
    required this.note,
  });

  final String providerName;
  final DateTime statementMonth;
  final DateTime statementDate;
  final DateTime dueDate;
  final double totalAmount;
  final double minimumPaymentAmount;
  final String? note;
}

Future<PayLaterInvoiceFormResult?> showPayLaterInvoiceFormDialog({
  required BuildContext context,
  PayLaterInvoice? initialValue,
}) {
  return showDialog<PayLaterInvoiceFormResult>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _PayLaterInvoiceFormDialog(initialValue: initialValue);
    },
  );
}

class _PayLaterInvoiceFormDialog extends StatefulWidget {
  const _PayLaterInvoiceFormDialog({this.initialValue});

  final PayLaterInvoice? initialValue;

  @override
  State<_PayLaterInvoiceFormDialog> createState() =>
      _PayLaterInvoiceFormDialogState();
}

class _PayLaterInvoiceFormDialogState
    extends State<_PayLaterInvoiceFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _providerController;
  late final TextEditingController _totalAmountController;
  late final TextEditingController _minimumPaymentController;
  late final TextEditingController _noteController;
  late DateTime _statementMonth;
  late DateTime _statementDate;
  late DateTime _dueDate;

  bool get _isEditing => widget.initialValue != null;

  @override
  void initState() {
    super.initState();
    final PayLaterInvoice? initialValue = widget.initialValue;
    _providerController = TextEditingController(
      text: initialValue?.providerName ?? '',
    );
    _totalAmountController = TextEditingController(
      text: _formatDouble(initialValue?.totalAmount),
    );
    _minimumPaymentController = TextEditingController(
      text: _formatDouble(initialValue?.minimumPaymentAmount),
    );
    _noteController = TextEditingController(text: initialValue?.note ?? '');
    final DateTime now = DateTime.now();
    _statementMonth =
        initialValue?.statementMonth ?? DateTime(now.year, now.month);
    _statementDate = initialValue?.statementDate ?? now;
    _dueDate = initialValue?.dueDate ?? now.add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _providerController.dispose();
    _totalAmountController.dispose();
    _minimumPaymentController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickStatementMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _statementMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }

    setState(() => _statementMonth = DateTime(picked.year, picked.month));
  }

  Future<void> _pickStatementDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _statementDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }

    setState(() => _statementDate = picked);
  }

  Future<void> _pickDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }

    setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      PayLaterInvoiceFormResult(
        providerName: _providerController.text.trim(),
        statementMonth: _statementMonth,
        statementDate: _statementDate,
        dueDate: _dueDate,
        totalAmount: double.parse(_totalAmountController.text.trim()),
        minimumPaymentAmount: double.parse(
          _minimumPaymentController.text.trim(),
        ),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        context.strings.t(
          _isEditing
              ? AppStringKey.editPayLaterInvoice
              : AppStringKey.addPayLaterInvoice,
        ),
      ),
      content: SizedBox(
        width: 540,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _providerController,
                  decoration: InputDecoration(
                    labelText: context.strings.t(AppStringKey.provider),
                  ),
                  validator: _requiredTextValidator,
                ),
                const SizedBox(height: 12),
                _DateFieldTile(
                  label: context.strings.t(AppStringKey.statementMonth),
                  value: context.strings.monthYear(_statementMonth),
                  onTap: _pickStatementMonth,
                ),
                const SizedBox(height: 12),
                _DateFieldTile(
                  label: context.strings.t(AppStringKey.statementDate),
                  value: context.strings.shortDate(_statementDate),
                  onTap: _pickStatementDate,
                ),
                const SizedBox(height: 12),
                _DateFieldTile(
                  label: context.strings.t(AppStringKey.dueDate),
                  value: context.strings.shortDate(_dueDate),
                  onTap: _pickDueDate,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _totalAmountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: context.strings.t(AppStringKey.originalAmount),
                  ),
                  validator: _positiveNumberValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _minimumPaymentController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: context.strings.t(AppStringKey.minimumPayment),
                  ),
                  validator: _positiveNumberValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: context.strings.t(AppStringKey.note),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.strings.t(AppStringKey.cancel)),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(context.strings.t(AppStringKey.save)),
        ),
      ],
    );
  }

  String? _requiredTextValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.strings.t(AppStringKey.fieldRequired);
    }

    return null;
  }

  String? _positiveNumberValidator(String? value) {
    final double? parsedValue = double.tryParse(value?.trim() ?? '');
    if (parsedValue == null) {
      return context.strings.t(AppStringKey.invalidNumber);
    }
    if (parsedValue <= 0) {
      return context.strings.t(AppStringKey.amountGreaterThanZero);
    }
    return null;
  }

  String _formatDouble(double? value) {
    if (value == null || value == 0) {
      return '';
    }

    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toString();
  }
}

class _DateFieldTile extends StatelessWidget {
  const _DateFieldTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Row(
          children: <Widget>[
            const Icon(Icons.calendar_month_rounded),
            const SizedBox(width: 12),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }
}
