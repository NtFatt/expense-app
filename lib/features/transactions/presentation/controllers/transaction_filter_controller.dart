import 'package:expense_app/features/transactions/domain/transaction_filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionFilterControllerProvider =
    NotifierProvider<TransactionFilterController, TransactionFilterState>(
  TransactionFilterController.new,
);

class TransactionFilterController extends Notifier<TransactionFilterState> {
  @override
  TransactionFilterState build() {
    return TransactionFilterState.initial();
  }

  void setMonth(DateTime month) {
    state = state.copyWith(selectedMonth: normalizeMonth(month));
  }

  void previousMonth() {
    final current = state.selectedMonth;
    state = state.copyWith(
      selectedMonth: DateTime(current.year, current.month - 1),
    );
  }

  void nextMonth() {
    final current = state.selectedMonth;
    state = state.copyWith(
      selectedMonth: DateTime(current.year, current.month + 1),
    );
  }

  void setTypeFilter(TransactionTypeFilter filter) {
    state = state.copyWith(typeFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  void clearNonMonthFilters() {
    state = state.copyWith(
      typeFilter: TransactionTypeFilter.all,
      searchQuery: '',
    );
  }

  void reset() {
    state = TransactionFilterState.initial();
  }
}
