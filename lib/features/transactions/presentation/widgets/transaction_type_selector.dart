import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:flutter/material.dart';

class TransactionTypeSelector extends StatelessWidget {
  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final TransactionType selectedType;
  final ValueChanged<TransactionType> onChanged;

  String _labelForType(BuildContext context, TransactionType type) {
    return switch (type) {
      TransactionType.expense => context.strings.t(AppStringKey.expense),
      TransactionType.income => context.strings.t(AppStringKey.income),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.t(AppStringKey.transactionType),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        SegmentedButton<TransactionType>(
          showSelectedIcon: false,
          multiSelectionEnabled: false,
          segments: TransactionType.values
              .map(
                (TransactionType type) => ButtonSegment<TransactionType>(
                  value: type,
                  label: Text(_labelForType(context, type)),
                  icon: Icon(
                    type.isExpense
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                  ),
                ),
              )
              .toList(),
          selected: <TransactionType>{selectedType},
          onSelectionChanged: (Set<TransactionType> selection) {
            onChanged(selection.first);
          },
        ),
      ],
    );
  }
}
