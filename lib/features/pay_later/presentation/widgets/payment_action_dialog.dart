import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:flutter/material.dart';

class PaymentActionResult {
  const PaymentActionResult({required this.type, this.amount});

  final PayLaterPaymentType type;
  final double? amount;
}

Future<PaymentActionResult?> showPaymentActionDialog({
  required BuildContext context,
  required String title,
  required double outstandingAmount,
  required double minimumAmount,
}) {
  return showDialog<PaymentActionResult>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _PaymentActionDialog(
        title: title,
        outstandingAmount: outstandingAmount,
        minimumAmount: minimumAmount,
      );
    },
  );
}

class _PaymentActionDialog extends StatefulWidget {
  const _PaymentActionDialog({
    required this.title,
    required this.outstandingAmount,
    required this.minimumAmount,
  });

  final String title;
  final double outstandingAmount;
  final double minimumAmount;

  @override
  State<_PaymentActionDialog> createState() => _PaymentActionDialogState();
}

class _PaymentActionDialogState extends State<_PaymentActionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  PayLaterPaymentType _selectedType = PayLaterPaymentType.minimumPayment;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedType == PayLaterPaymentType.customPayment &&
        !_formKey.currentState!.validate()) {
      return;
    }

    final PaymentActionResult result = switch (_selectedType) {
      PayLaterPaymentType.minimumPayment => PaymentActionResult(
        type: _selectedType,
      ),
      PayLaterPaymentType.customPayment => PaymentActionResult(
        type: _selectedType,
        amount: double.parse(_amountController.text.trim()),
      ),
      PayLaterPaymentType.fullSettlement => PaymentActionResult(
        type: _selectedType,
      ),
    };

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(context.strings.t(AppStringKey.recordPayment)),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${context.strings.t(AppStringKey.outstanding)}: ${formatCurrency(widget.outstandingAmount, withSign: false)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${context.strings.t(AppStringKey.minimumPayment)}: ${formatCurrency(widget.minimumAmount, withSign: false)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                SegmentedButton<PayLaterPaymentType>(
                  segments: <ButtonSegment<PayLaterPaymentType>>[
                    ButtonSegment<PayLaterPaymentType>(
                      value: PayLaterPaymentType.minimumPayment,
                      label: Text(context.strings.t(AppStringKey.payMinimum)),
                    ),
                    ButtonSegment<PayLaterPaymentType>(
                      value: PayLaterPaymentType.customPayment,
                      label: Text(
                        context.strings.t(AppStringKey.payCustomAmount),
                      ),
                    ),
                    ButtonSegment<PayLaterPaymentType>(
                      value: PayLaterPaymentType.fullSettlement,
                      label: Text(
                        context.strings.t(AppStringKey.settleFullAmount),
                      ),
                    ),
                  ],
                  selected: <PayLaterPaymentType>{_selectedType},
                  onSelectionChanged:
                      (Set<PayLaterPaymentType> selectedValues) {
                        if (selectedValues.isEmpty) {
                          return;
                        }
                        setState(() => _selectedType = selectedValues.first);
                      },
                ),
                if (_selectedType ==
                    PayLaterPaymentType.customPayment) ...<Widget>[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.strings.t(AppStringKey.paymentAmount),
                    ),
                    validator: (String? value) {
                      final double? amount = double.tryParse(
                        value?.trim() ?? '',
                      );
                      if (amount == null) {
                        return context.strings.t(AppStringKey.amountRequired);
                      }
                      if (amount <= 0) {
                        return context.strings.t(
                          AppStringKey.amountGreaterThanZero,
                        );
                      }
                      if (amount > widget.outstandingAmount) {
                        return context.strings.t(
                          AppStringKey.paymentExceedsOutstanding,
                        );
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.45,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    context.strings.t(AppStringKey.paymentDisclaimer),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
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
}
