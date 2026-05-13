import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/transactions/domain/transaction_filters.dart';
import 'package:expense_app/features/transactions/presentation/widgets/month_selector.dart';
import 'package:flutter/material.dart';

class TransactionFilterBar extends StatefulWidget {
  const TransactionFilterBar({
    super.key,
    required this.filter,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onTypeChanged,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onClearNonMonthFilters,
  });

  final TransactionFilterState filter;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<TransactionTypeFilter> onTypeChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onClearNonMonthFilters;

  @override
  State<TransactionFilterBar> createState() => _TransactionFilterBarState();
}

class _TransactionFilterBarState extends State<TransactionFilterBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filter.searchQuery);
  }

  @override
  void didUpdateWidget(TransactionFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter.searchQuery != _searchController.text) {
      _searchController.text = widget.filter.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MonthSelector(
                  selectedMonth: widget.filter.selectedMonth,
                  onPreviousMonth: widget.onPreviousMonth,
                  onNextMonth: widget.onNextMonth,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildSearchField(),
          const SizedBox(height: 12),
          _buildTypeFilterChips(),
          if (widget.filter.activeFilterCount > 0) ...[
            const SizedBox(height: 8),
            _buildActiveFilterBadge(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      key: const Key('transaction_filter_search_field'),
      controller: _searchController,
      onChanged: widget.onSearchChanged,
      decoration: InputDecoration(
        labelText: context.strings.t(AppStringKey.searchTransactions),
        hintText: context.strings.t(AppStringKey.searchByCategoryOrNote),
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: widget.filter.hasSearch
            ? IconButton(
                key: const Key('transaction_filter_clear_search'),
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  _searchController.clear();
                  widget.onClearSearch();
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        isDense: true,
      ),
    );
  }

  Widget _buildTypeFilterChips() {
    return Row(
      children: [
        Expanded(
          child: _TypeChip(
            label: context.strings.t(AppStringKey.all),
            isSelected: widget.filter.typeFilter == TransactionTypeFilter.all,
            onTap: () => widget.onTypeChanged(TransactionTypeFilter.all),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TypeChip(
            label: context.strings.t(AppStringKey.income),
            isSelected:
                widget.filter.typeFilter == TransactionTypeFilter.income,
            onTap: () => widget.onTypeChanged(TransactionTypeFilter.income),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TypeChip(
            label: context.strings.t(AppStringKey.expense),
            isSelected:
                widget.filter.typeFilter == TransactionTypeFilter.expense,
            onTap: () => widget.onTypeChanged(TransactionTypeFilter.expense),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilterBadge() {
    return Row(
      children: [
        const Icon(Icons.filter_list, size: 14, color: Color(0xFF2563EB)),
        const SizedBox(width: 4),
        Text(
          context.strings.activeFilterCount(widget.filter.activeFilterCount),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2563EB),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: widget.onClearNonMonthFilters,
          child: Text(
            context.strings.t(AppStringKey.clearFilters),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFDC2626),
            ),
          ),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
