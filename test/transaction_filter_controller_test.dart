import 'package:expense_app/features/transactions/domain/transaction_filters.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_filter_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionFilterController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial selectedMonth is current normalized month', () {
      final state = container.read(transactionFilterControllerProvider);
      final now = DateTime.now();

      expect(state.selectedMonth.year, now.year);
      expect(state.selectedMonth.month, now.month);
      expect(state.selectedMonth.day, 1);
    });

    test('setMonth normalizes the month', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );

      controller.setMonth(DateTime(2025, 7, 15, 14, 30));

      final state = container.read(transactionFilterControllerProvider);
      expect(state.selectedMonth, DateTime(2025, 7));
    });

    test('previousMonth moves back one month', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );

      controller.setMonth(DateTime(2025, 6, 15));
      controller.previousMonth();

      final state = container.read(transactionFilterControllerProvider);
      expect(state.selectedMonth, DateTime(2025, 5));
    });

    test('previousMonth across January wraps to previous year', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );

      controller.setMonth(DateTime(2025, 1, 15));
      controller.previousMonth();

      final state = container.read(transactionFilterControllerProvider);
      expect(state.selectedMonth, DateTime(2024, 12));
    });

    test('nextMonth moves forward one month', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );

      controller.setMonth(DateTime(2025, 6, 15));
      controller.nextMonth();

      final state = container.read(transactionFilterControllerProvider);
      expect(state.selectedMonth, DateTime(2025, 7));
    });

    test('nextMonth across December wraps to next year', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );

      controller.setMonth(DateTime(2025, 12, 15));
      controller.nextMonth();

      final state = container.read(transactionFilterControllerProvider);
      expect(state.selectedMonth, DateTime(2026, 1));
    });

    test('setTypeFilter updates type filter', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );

      controller.setTypeFilter(TransactionTypeFilter.income);

      final state = container.read(transactionFilterControllerProvider);
      expect(state.typeFilter, TransactionTypeFilter.income);
    });

    test('setSearchQuery trims input', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );

      controller.setSearchQuery('  lương  ');

      final state = container.read(transactionFilterControllerProvider);
      expect(state.searchQuery, 'lương');
    });

    test('clearSearch sets query to empty string', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );

      controller.setSearchQuery('some query');
      controller.clearSearch();

      final state = container.read(transactionFilterControllerProvider);
      expect(state.searchQuery, '');
    });

    test('reset restores initial state', () {
      final controller = container.read(
        transactionFilterControllerProvider.notifier,
      );
      final now = DateTime.now();

      controller.setMonth(DateTime(2024, 1));
      controller.setTypeFilter(TransactionTypeFilter.expense);
      controller.setSearchQuery('test');

      controller.reset();

      final state = container.read(transactionFilterControllerProvider);
      expect(state.selectedMonth.year, now.year);
      expect(state.selectedMonth.month, now.month);
      expect(state.typeFilter, TransactionTypeFilter.all);
      expect(state.searchQuery, '');
    });
  });
}
