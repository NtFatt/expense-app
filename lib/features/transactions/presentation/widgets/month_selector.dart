import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.onTapMonth,
  });

  final DateTime selectedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback? onTapMonth;

  static const List<String> _months = [
    'Tháng 1',
    'Tháng 2',
    'Tháng 3',
    'Tháng 4',
    'Tháng 5',
    'Tháng 6',
    'Tháng 7',
    'Tháng 8',
    'Tháng 9',
    'Tháng 10',
    'Tháng 11',
    'Tháng 12',
  ];

  String get _label =>
      '${_months[selectedMonth.month - 1]} ${selectedMonth.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: const Key('month_selector_previous'),
            tooltip: 'Tháng trước',
            onPressed: onPreviousMonth,
            icon: const Icon(Icons.chevron_left),
            iconSize: 24,
            visualDensity: VisualDensity.compact,
          ),
          GestureDetector(
            onTap: onTapMonth,
            child: Container(
              constraints: const BoxConstraints(minWidth: 100),
              alignment: Alignment.center,
              child: Text(
                _label,
                key: const Key('month_selector_label'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('month_selector_next'),
            tooltip: 'Tháng sau',
            onPressed: onNextMonth,
            icon: const Icon(Icons.chevron_right),
            iconSize: 24,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
