import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.trailing});

  final TransactionModel transaction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.isIncome;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color accentColor = isIncome
        ? const Color(0xFF16A34A)
        : colorScheme.error;
    final Widget amountColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatCurrency(transaction.signedAmount),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (trailing != null) ...[const SizedBox(height: 8), trailing!],
      ],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Widget leading = CircleAvatar(
            backgroundColor: accentColor.withValues(alpha: 0.12),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: accentColor,
            ),
          );
          final Widget titleBlock = Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.displayTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.category} • ${context.strings.relativeDate(transaction.transactionDate)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
          final bool useCompactLayout =
              trailing != null && constraints.maxWidth < 420;

          if (useCompactLayout) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    leading,
                    const SizedBox(width: 14),
                    titleBlock,
                  ],
                ),
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerRight, child: amountColumn),
              ],
            );
          }

          return Row(
            children: <Widget>[
              leading,
              const SizedBox(width: 14),
              titleBlock,
              const SizedBox(width: 12),
              amountColumn,
            ],
          );
        },
      ),
    );
  }
}
