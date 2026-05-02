import 'package:expense_app/features/transactions/domain/transaction_model.dart';

/// Filter mode for transaction type.
enum TransactionTypeFilter {
  all,
  income,
  expense;

  String get label {
    switch (this) {
      case TransactionTypeFilter.all:
        return 'Tất cả';
      case TransactionTypeFilter.income:
        return 'Thu nhập';
      case TransactionTypeFilter.expense:
        return 'Chi tiêu';
    }
  }

  bool get isAll => this == TransactionTypeFilter.all;
  bool get isIncome => this == TransactionTypeFilter.income;
  bool get isExpense => this == TransactionTypeFilter.expense;
}

/// Returns a [DateTime] at the first day of the month, midnight.
DateTime normalizeMonth(DateTime value) {
  return DateTime(value.year, value.month);
}

/// Returns true if both dates share the same year and month.
bool isSameMonth(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month;
}

/// Normalizes search text: trims whitespace and converts to lowercase.
/// Accent stripping is intentionally deferred to a later phase.
String normalizeSearchText(String value) {
  return value.trim().toLowerCase();
}

/// Holds the current filter state for transactions.
class TransactionFilterState {
  TransactionFilterState({
    DateTime? selectedMonth,
    this.typeFilter = TransactionTypeFilter.all,
    this.searchQuery = '',
  }) : selectedMonth = normalizeMonth(selectedMonth ?? DateTime.now());

  final DateTime selectedMonth;
  final TransactionTypeFilter typeFilter;
  final String searchQuery;

  factory TransactionFilterState.initial([DateTime? now]) {
    return TransactionFilterState(selectedMonth: now ?? DateTime.now());
  }

  String get normalizedSearchQuery => normalizeSearchText(searchQuery);

  bool get hasSearch => normalizedSearchQuery.isNotEmpty;

  bool get hasActiveTypeFilter => typeFilter != TransactionTypeFilter.all;

  int get activeFilterCount {
    var count = 0;
    if (hasActiveTypeFilter) count++;
    if (hasSearch) count++;
    return count;
  }

  TransactionFilterState copyWith({
    DateTime? selectedMonth,
    TransactionTypeFilter? typeFilter,
    String? searchQuery,
  }) {
    return TransactionFilterState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      typeFilter: typeFilter ?? this.typeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionFilterState &&
        other.selectedMonth == selectedMonth &&
        other.typeFilter == typeFilter &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode => Object.hash(selectedMonth, typeFilter, searchQuery);
}

/// Applies month, type, and search filters to a list of transactions.
/// Returns a new list sorted newest-first by transactionDate, then by createdAt.
List<TransactionModel> applyTransactionFilters({
  required List<TransactionModel> transactions,
  required TransactionFilterState filter,
}) {
  final selectedMonth = normalizeMonth(filter.selectedMonth);
  final query = filter.normalizedSearchQuery;

  final result = transactions.where((TransactionModel transaction) {
    if (!isSameMonth(transaction.transactionDate, selectedMonth)) {
      return false;
    }

    final matchesType = switch (filter.typeFilter) {
      TransactionTypeFilter.all => true,
      TransactionTypeFilter.income => transaction.isIncome,
      TransactionTypeFilter.expense => transaction.isExpense,
    };

    if (!matchesType) {
      return false;
    }

    if (query.isEmpty) {
      return true;
    }

    final category = normalizeSearchText(transaction.category);
    final note = normalizeSearchText(transaction.note ?? '');
    final title = normalizeSearchText(transaction.displayTitle);

    return category.contains(query) ||
        note.contains(query) ||
        title.contains(query);
  }).toList();

  result.sort((TransactionModel a, TransactionModel b) {
    final byDate = b.transactionDate.compareTo(a.transactionDate);
    if (byDate != 0) return byDate;
    return b.createdAt.compareTo(a.createdAt);
  });

  return result;
}
