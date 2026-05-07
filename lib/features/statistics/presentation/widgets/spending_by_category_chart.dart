import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingByCategoryChart extends StatelessWidget {
  const SpendingByCategoryChart({
    super.key,
    required this.summaries,
    required this.totalExpense,
  });

  final List<CategoryExpenseSummary> summaries;
  final int totalExpense;

  static const List<Color> _palette = <Color>[
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFF16A34A),
    Color(0xFFEA580C),
    Color(0xFF0F766E),
    Color(0xFFDB2777),
    Color(0xFFCA8A04),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings.t(AppStringKey.spendingByCategory),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.strings.t(AppStringKey.spendingByCategorySubtitle),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 58,
                    sectionsSpace: 3,
                    pieTouchData: PieTouchData(enabled: false),
                    sections: [
                      for (int index = 0; index < summaries.length; index++)
                        PieChartSectionData(
                          value: summaries[index].amount.toDouble(),
                          color: _palette[index % _palette.length],
                          radius: 74,
                          title: _buildSectionTitle(summaries[index]),
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                          borderSide: BorderSide.none,
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.strings.t(AppStringKey.totalExpense),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatCurrency(totalExpense, withSign: false),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildSectionTitle(CategoryExpenseSummary summary) {
    final double percent = summary.percentageOf(totalExpense) * 100;
    if (percent < 8) {
      return '';
    }

    return '${percent.toStringAsFixed(0)}%';
  }
}
