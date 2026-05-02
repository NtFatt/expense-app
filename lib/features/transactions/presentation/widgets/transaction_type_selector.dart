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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại giao dịch',
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
                  label: Text(type.label),
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
