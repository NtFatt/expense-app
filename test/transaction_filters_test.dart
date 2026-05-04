import 'package:expense_app/features/transactions/domain/transaction_filters.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionModel _tx({
  required String id,
  required TransactionType type,
  required int amount,
  required String category,
  String? note,
  required DateTime date,
  DateTime? createdAt,
}) {
  final timestamp = createdAt ?? date;
  return TransactionModel(
    id: id,
    type: type,
    amount: amount,
    category: category,
    note: note,
    transactionDate: date,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

void main() {
  group('normalizeMonth', () {
    test('removes day and time, returns first day of month', () {
      final input = DateTime(2025, 3, 15, 14, 30, 45);
      final result = normalizeMonth(input);
      expect(result, DateTime(2025, 3));
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
    });

    test('handles end-of-month date', () {
      final input = DateTime(2025, 1, 31, 23, 59, 59);
      final result = normalizeMonth(input);
      expect(result, DateTime(2025, 1));
    });
  });

  group('isSameMonth', () {
    test('returns true for same year and month', () {
      final a = DateTime(2025, 6, 10);
      final b = DateTime(2025, 6, 25);
      expect(isSameMonth(a, b), isTrue);
    });

    test('returns false for different month', () {
      final a = DateTime(2025, 6, 10);
      final b = DateTime(2025, 7, 10);
      expect(isSameMonth(a, b), isFalse);
    });

    test('returns false for different year', () {
      final a = DateTime(2025, 6, 10);
      final b = DateTime(2026, 6, 10);
      expect(isSameMonth(a, b), isFalse);
    });

    test('returns false when only day differs', () {
      final a = DateTime(2025, 6, 1);
      final b = DateTime(2025, 6, 30);
      expect(isSameMonth(a, b), isTrue);
    });
  });

  group('TransactionFilterState', () {
    test('initializes with current month if not provided', () {
      final state = TransactionFilterState.initial();
      final now = DateTime.now();
      expect(state.selectedMonth.year, now.year);
      expect(state.selectedMonth.month, now.month);
    });

    test('normalizes selectedMonth on construction', () {
      final state = TransactionFilterState(
        selectedMonth: DateTime(2025, 4, 15),
      );
      expect(state.selectedMonth, DateTime(2025, 4));
    });

    test('normalizedSearchQuery trims and lowercases', () {
      final state = TransactionFilterState(searchQuery: '  ĂN Uống  ');
      expect(state.normalizedSearchQuery, 'ăn uống');
    });

    test('hasSearch is true when query is non-empty', () {
      final state = TransactionFilterState(searchQuery: 'abc');
      expect(state.hasSearch, isTrue);
    });

    test('hasSearch is false when query is empty', () {
      final state = TransactionFilterState(searchQuery: '');
      expect(state.hasSearch, isFalse);
    });

    test('activeFilterCount: all + empty search => 0', () {
      final state = TransactionFilterState(
        typeFilter: TransactionTypeFilter.all,
        searchQuery: '',
      );
      expect(state.activeFilterCount, 0);
    });

    test('activeFilterCount: income + empty search => 1', () {
      final state = TransactionFilterState(
        typeFilter: TransactionTypeFilter.income,
        searchQuery: '',
      );
      expect(state.activeFilterCount, 1);
    });

    test('activeFilterCount: all + query => 1', () {
      final state = TransactionFilterState(
        typeFilter: TransactionTypeFilter.all,
        searchQuery: 'lương',
      );
      expect(state.activeFilterCount, 1);
    });

    test('activeFilterCount: expense + query => 2', () {
      final state = TransactionFilterState(
        typeFilter: TransactionTypeFilter.expense,
        searchQuery: 'ăn',
      );
      expect(state.activeFilterCount, 2);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = TransactionFilterState(
        selectedMonth: DateTime(2025, 3),
        typeFilter: TransactionTypeFilter.all,
        searchQuery: 'abc',
      );
      final updated = original.copyWith(
        typeFilter: TransactionTypeFilter.income,
        searchQuery: 'xyz',
      );
      expect(updated.typeFilter, TransactionTypeFilter.income);
      expect(updated.searchQuery, 'xyz');
      expect(updated.selectedMonth, DateTime(2025, 3));
    });

    test('equality works correctly', () {
      final a = TransactionFilterState(
        selectedMonth: DateTime(2025, 5),
        typeFilter: TransactionTypeFilter.income,
        searchQuery: 'test',
      );
      final b = TransactionFilterState(
        selectedMonth: DateTime(2025, 5),
        typeFilter: TransactionTypeFilter.income,
        searchQuery: 'test',
      );
      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('applyTransactionFilters', () {
    final mar2025 = DateTime(2025, 3, 10);
    final apr2025 = DateTime(2025, 4, 5);
    final may2025 = DateTime(2025, 5, 1);

    final transactions = <TransactionModel>[
      _tx(
        id: '1',
        type: TransactionType.income,
        amount: 1000,
        category: 'Lương',
        note: 'Lương tháng 3',
        date: mar2025,
        createdAt: mar2025,
      ),
      _tx(
        id: '2',
        type: TransactionType.expense,
        amount: 200,
        category: 'Ăn uống',
        note: 'Ăn sáng',
        date: mar2025,
        createdAt: mar2025,
      ),
      _tx(
        id: '3',
        type: TransactionType.expense,
        amount: 150,
        category: 'Giải trí',
        note: 'Cà phê',
        date: apr2025,
        createdAt: apr2025,
      ),
      _tx(
        id: '4',
        type: TransactionType.income,
        amount: 500,
        category: 'Thưởng',
        note: null,
        date: apr2025,
        createdAt: apr2025,
      ),
      _tx(
        id: '5',
        type: TransactionType.expense,
        amount: 80,
        category: 'Di chuyển',
        note: 'Grab',
        date: may2025,
        createdAt: may2025,
      ),
    ];

    test('filters by selected month', () {
      final filter = TransactionFilterState(selectedMonth: DateTime(2025, 3));
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 2);
      expect(result.every((t) => t.transactionDate.month == 3), isTrue);
    });

    test('filters income type', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 3),
        typeFilter: TransactionTypeFilter.income,
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 1);
      expect(result.first.type, TransactionType.income);
    });

    test('filters expense type', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 4),
        typeFilter: TransactionTypeFilter.expense,
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 1);
      expect(result.first.type, TransactionType.expense);
      expect(result.first.category, 'Giải trí');
    });

    test('searches by category (Vietnamese)', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 4),
        searchQuery: 'giải trí',
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 1);
      expect(result.first.category, 'Giải trí');
    });

    test('searches by note (Vietnamese)', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 3),
        searchQuery: 'ăn',
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 1);
      expect(result.first.note, 'Ăn sáng');
    });

    test('searches by displayTitle (uses note when available)', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 3),
        searchQuery: 'lương',
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 1);
      expect(result.first.displayTitle, 'Lương tháng 3');
    });

    test('searches by category when note is null', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 4),
        searchQuery: 'thưởng',
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 1);
      expect(result.first.category, 'Thưởng');
    });

    test('combined filter: month + type + search', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 3),
        typeFilter: TransactionTypeFilter.expense,
        searchQuery: 'ăn',
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 1);
      expect(result.first.category, 'Ăn uống');
    });

    test('empty search does not restrict results beyond month/type', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 3),
        typeFilter: TransactionTypeFilter.all,
        searchQuery: '',
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 2);
    });

    test('output sorted by transactionDate descending', () {
      final filter = TransactionFilterState(selectedMonth: DateTime(2025, 4));
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(
        result[0].transactionDate.isAfter(result[1].transactionDate) ||
            result[0].transactionDate.isAtSameMomentAs(
              result[1].transactionDate,
            ),
        isTrue,
      );
    });

    test('same transactionDate sorted by createdAt descending', () {
      final later = DateTime(2025, 6, 1, 12, 0);
      final earlier = DateTime(2025, 6, 1, 8, 0);

      final sameDateTxns = <TransactionModel>[
        _tx(
          id: 'early',
          type: TransactionType.expense,
          amount: 1,
          category: 'A',
          note: 'a',
          date: DateTime(2025, 6, 1),
          createdAt: earlier,
        ),
        _tx(
          id: 'late',
          type: TransactionType.expense,
          amount: 2,
          category: 'B',
          note: 'b',
          date: DateTime(2025, 6, 1),
          createdAt: later,
        ),
      ];

      final filter = TransactionFilterState(selectedMonth: DateTime(2025, 6));
      final result = applyTransactionFilters(
        transactions: sameDateTxns,
        filter: filter,
      );
      expect(result[0].id, 'late');
      expect(result[1].id, 'early');
    });

    test('does not mutate input list', () {
      final input = [
        _tx(
          id: '1',
          type: TransactionType.expense,
          amount: 1,
          category: 'X',
          note: 'x',
          date: DateTime(2025, 7, 1),
        ),
      ];
      final originalLength = input.length;
      applyTransactionFilters(
        transactions: input,
        filter: TransactionFilterState(selectedMonth: DateTime(2025, 7)),
      );
      expect(input.length, originalLength);
    });

    test('all type filter returns all transactions in month', () {
      final filter = TransactionFilterState(
        selectedMonth: DateTime(2025, 3),
        typeFilter: TransactionTypeFilter.all,
      );
      final result = applyTransactionFilters(
        transactions: transactions,
        filter: filter,
      );
      expect(result.length, 2);
    });
  });
}
