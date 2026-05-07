import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: const Key('month_selector_previous'),
            tooltip: context.strings.t(AppStringKey.previousMonth),
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
                context.strings.monthYear(selectedMonth),
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
            tooltip: context.strings.t(AppStringKey.nextMonth),
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
