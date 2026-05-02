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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiêu theo danh mục',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tỷ trọng từng danh mục trên tổng chi hiện tại.',
            style: TextStyle(color: Color(0xFF64748B), height: 1.4),
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
                    const Text(
                      'Tổng chi',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatCurrency(totalExpense, withSign: false),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
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
