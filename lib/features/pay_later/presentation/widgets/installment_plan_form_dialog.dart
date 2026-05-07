import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:flutter/material.dart';

class InstallmentPlanFormResult {
  const InstallmentPlanFormResult({
    required this.title,
    required this.providerName,
    required this.originalAmount,
    required this.monthlyPaymentAmount,
    required this.minimumPaymentAmount,
    required this.totalInstallments,
    required this.paidInstallments,
    required this.startDate,
    required this.dueDayOfMonth,
    required this.note,
  });

  final String title;
  final String providerName;
  final double originalAmount;
  final double monthlyPaymentAmount;
  final double minimumPaymentAmount;
  final int totalInstallments;
  final int paidInstallments;
  final DateTime startDate;
  final int dueDayOfMonth;
  final String? note;
}

Future<InstallmentPlanFormResult?> showInstallmentPlanFormDialog({
  required BuildContext context,
  InstallmentPlan? initialValue,
}) {
  return showDialog<InstallmentPlanFormResult>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _InstallmentPlanFormDialog(initialValue: initialValue);
    },
  );
}

class _InstallmentPlanFormDialog extends StatefulWidget {
  const _InstallmentPlanFormDialog({this.initialValue});

  final InstallmentPlan? initialValue;

  @override
  State<_InstallmentPlanFormDialog> createState() =>
      _InstallmentPlanFormDialogState();
}

class _InstallmentPlanFormDialogState
    extends State<_InstallmentPlanFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _providerController;
  late final TextEditingController _originalAmountController;
  late final TextEditingController _monthlyPaymentController;
  late final TextEditingController _minimumPaymentController;
  late final TextEditingController _totalInstallmentsController;
  late final TextEditingController _paidInstallmentsController;
  late final TextEditingController _dueDayController;
  late final TextEditingController _noteController;
  late DateTime _startDate;

  bool get _isEditing => widget.initialValue != null;

  @override
  void initState() {
    super.initState();
    final InstallmentPlan? initialValue = widget.initialValue;
    _titleController = TextEditingController(text: initialValue?.title ?? '');
    _providerController = TextEditingController(
      text: initialValue?.providerName ?? '',
    );
    _originalAmountController = TextEditingController(
      text: _formatDouble(initialValue?.originalAmount),
    );
    _monthlyPaymentController = TextEditingController(
      text: _formatDouble(initialValue?.monthlyPaymentAmount),
    );
    _minimumPaymentController = TextEditingController(
      text: _formatDouble(initialValue?.minimumPaymentAmount),
    );
    _totalInstallmentsController = TextEditingController(
      text: initialValue?.totalInstallments.toString() ?? '1',
    );
    _paidInstallmentsController = TextEditingController(
      text: initialValue?.paidInstallments.toString() ?? '0',
    );
    _dueDayController = TextEditingController(
      text:
          initialValue?.dueDayOfMonth.toString() ??
          DateTime.now().day.clamp(1, 31).toString(),
    );
    _noteController = TextEditingController(text: initialValue?.note ?? '');
    _startDate = initialValue?.startDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _providerController.dispose();
    _originalAmountController.dispose();
    _monthlyPaymentController.dispose();
    _minimumPaymentController.dispose();
    _totalInstallmentsController.dispose();
    _paidInstallmentsController.dispose();
    _dueDayController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }

    setState(() => _startDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int totalInstallments = int.parse(
      _totalInstallmentsController.text.trim(),
    );
    final int paidInstallments = int.parse(
      _paidInstallmentsController.text.trim(),
    );

    if (paidInstallments > totalInstallments) {
      return;
    }

    Navigator.of(context).pop(
      InstallmentPlanFormResult(
        title: _titleController.text.trim(),
        providerName: _providerController.text.trim(),
        originalAmount: double.parse(_originalAmountController.text.trim()),
        monthlyPaymentAmount: double.parse(
          _monthlyPaymentController.text.trim(),
        ),
        minimumPaymentAmount: double.parse(
          _minimumPaymentController.text.trim(),
        ),
        totalInstallments: totalInstallments,
        paidInstallments: paidInstallments,
        startDate: _startDate,
        dueDayOfMonth: int.parse(_dueDayController.text.trim()),
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
              ? AppStringKey.editInstallmentPlan
              : AppStringKey.addInstallmentPlan,
        ),
      ),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _LabeledTextField(
                  controller: _titleController,
                  label: context.strings.t(AppStringKey.planTitle),
                  validator: _requiredTextValidator,
                ),
                const SizedBox(height: 12),
                _LabeledTextField(
                  controller: _providerController,
                  label: context.strings.t(AppStringKey.provider),
                  validator: _requiredTextValidator,
                ),
                const SizedBox(height: 12),
                _LabeledNumberField(
                  controller: _originalAmountController,
                  label: context.strings.t(AppStringKey.originalAmount),
                  validator: _positiveNumberValidator,
                ),
                const SizedBox(height: 12),
                _LabeledNumberField(
                  controller: _monthlyPaymentController,
                  label: context.strings.t(AppStringKey.monthlyPayment),
                  validator: _positiveNumberValidator,
                ),
                const SizedBox(height: 12),
                _LabeledNumberField(
                  controller: _minimumPaymentController,
                  label: context.strings.t(AppStringKey.minimumPayment),
                  validator: _positiveNumberValidator,
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _LabeledNumberField(
                        controller: _totalInstallmentsController,
                        label: context.strings.t(
                          AppStringKey.totalInstallments,
                        ),
                        isInteger: true,
                        validator: _positiveIntegerValidator,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledNumberField(
                        controller: _paidInstallmentsController,
                        label: context.strings.t(AppStringKey.paidInstallments),
                        isInteger: true,
                        validator: (String? value) {
                          final String? baseValidation =
                              _nonNegativeIntegerValidator(value);
                          if (baseValidation != null) {
                            return baseValidation;
                          }
                          final int paidInstallments = int.parse(value!.trim());
                          final int? totalInstallments = int.tryParse(
                            _totalInstallmentsController.text.trim(),
                          );
                          if (totalInstallments != null &&
                              paidInstallments > totalInstallments) {
                            return context.strings.t(
                              AppStringKey.paidInstallmentsRange,
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _DateFieldTile(
                  label: context.strings.t(AppStringKey.startDate),
                  value: context.strings.shortDate(_startDate),
                  onTap: _pickStartDate,
                ),
                const SizedBox(height: 12),
                _LabeledNumberField(
                  controller: _dueDayController,
                  label: context.strings.t(AppStringKey.dueDayOfMonth),
                  isInteger: true,
                  validator: (String? value) {
                    final String? baseValidation = _positiveIntegerValidator(
                      value,
                    );
                    if (baseValidation != null) {
                      return baseValidation;
                    }
                    final int dueDay = int.parse(value!.trim());
                    if (dueDay < 1 || dueDay > 31) {
                      return context.strings.t(AppStringKey.dueDayRange);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _LabeledTextField(
                  controller: _noteController,
                  label: context.strings.t(AppStringKey.note),
                  maxLines: 3,
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

  String? _positiveIntegerValidator(String? value) {
    final int? parsedValue = int.tryParse(value?.trim() ?? '');
    if (parsedValue == null) {
      return context.strings.t(AppStringKey.invalidNumber);
    }
    if (parsedValue <= 0) {
      return context.strings.t(AppStringKey.amountGreaterThanZero);
    }
    return null;
  }

  String? _nonNegativeIntegerValidator(String? value) {
    final int? parsedValue = int.tryParse(value?.trim() ?? '');
    if (parsedValue == null) {
      return context.strings.t(AppStringKey.invalidNumber);
    }
    if (parsedValue < 0) {
      return context.strings.t(AppStringKey.invalidNumber);
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

class _LabeledTextField extends StatelessWidget {
  const _LabeledTextField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}

class _LabeledNumberField extends StatelessWidget {
  const _LabeledNumberField({
    required this.controller,
    required this.label,
    this.validator,
    this.isInteger = false,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool isInteger;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
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
