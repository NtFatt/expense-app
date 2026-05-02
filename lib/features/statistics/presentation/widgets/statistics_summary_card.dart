import 'package:expense_app/shared/widgets/metric_card.dart';
import 'package:flutter/material.dart';

class StatisticsSummaryCard extends StatelessWidget {
  const StatisticsSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return MetricCard(
      title: title,
      value: value,
      icon: icon,
      accentColor: accentColor,
    );
  }
}
