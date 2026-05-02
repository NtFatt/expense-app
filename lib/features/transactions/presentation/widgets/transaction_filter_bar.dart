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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonthSelector(
                selectedMonth: widget.filter.selectedMonth,
                onPreviousMonth: widget.onPreviousMonth,
                onNextMonth: widget.onNextMonth,
              ),
            ],
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
        hintText: 'Tìm theo danh mục, ghi chú...',
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
            label: 'Tất cả',
            isSelected: widget.filter.typeFilter == TransactionTypeFilter.all,
            onTap: () => widget.onTypeChanged(TransactionTypeFilter.all),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TypeChip(
            label: 'Thu nhập',
            isSelected: widget.filter.typeFilter == TransactionTypeFilter.income,
            onTap: () => widget.onTypeChanged(TransactionTypeFilter.income),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TypeChip(
            label: 'Chi tiêu',
            isSelected: widget.filter.typeFilter == TransactionTypeFilter.expense,
            onTap: () => widget.onTypeChanged(TransactionTypeFilter.expense),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilterBadge() {
    return Row(
      children: [
        const Icon(
          Icons.filter_list,
          size: 14,
          color: Color(0xFF2563EB),
        ),
        const SizedBox(width: 4),
        Text(
          '${widget.filter.activeFilterCount} bộ lọc',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2563EB),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: widget.onClearNonMonthFilters,
          child: const Text(
            'Xóa lọc',
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
