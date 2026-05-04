import 'package:expense_app/app/app.dart';
import 'package:expense_app/app/router.dart';
import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Expense app renders dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quản lý chi tiêu'), findsOneWidget);
    expect(find.text('Số dư hiện tại'), findsOneWidget);
    expect(find.text('Giao dịch tháng này'), findsOneWidget);
    expect(find.text('Tổng quan'), findsOneWidget);
  });

  testWidgets('Bottom navigation opens transactions page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('bottom_nav_transactions')));
    await tester.pumpAndSettle();

    expect(find.text('Tổng số giao dịch'), findsOneWidget);
    expect(
      find.byKey(const Key('transactions_add_transaction_fab')),
      findsOneWidget,
    );
  });

  testWidgets('Tap add transaction opens transaction form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton).first);
    await tester.pumpAndSettle();

    expect(find.text('Thêm giao dịch'), findsOneWidget);
    expect(
      find.byKey(const Key('add_transaction_amount_field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('add_transaction_submit_button')),
      findsOneWidget,
    );
  });

  testWidgets('Tap edit transaction opens edit form with seeded data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/transactions');
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('edit_transaction_button_seed_income_salary')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('edit_transaction_button_seed_income_salary')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sửa giao dịch'), findsOneWidget);
    expect(
      find.byKey(const Key('edit_transaction_amount_field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('edit_transaction_submit_button')),
      findsOneWidget,
    );
    expect(find.text('Cập nhật giao dịch'), findsOneWidget);
  });

  testWidgets('Transactions page shows filter UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/transactions');
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('transaction_filter_search_field')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('month_selector_previous')), findsOneWidget);
    expect(find.byKey(const Key('month_selector_next')), findsOneWidget);
  });

  testWidgets('Type filter chips are visible on transactions page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/transactions');
    await tester.pumpAndSettle();

    expect(find.text('Tất cả'), findsWidgets);
    expect(find.text('Thu nhập'), findsWidgets);
    expect(find.text('Chi tiêu'), findsWidgets);
  });

  testWidgets('Month selector label is visible on transactions page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/transactions');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('month_selector_label')), findsOneWidget);
  });

  testWidgets('Search field accepts text input', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/transactions');
    await tester.pumpAndSettle();

    final Finder searchField = find.byKey(
      const Key('transaction_filter_search_field'),
    );
    await tester.enterText(searchField, 'lương');
    await tester.pumpAndSettle();

    expect(find.text('lương'), findsOneWidget);
  });

  testWidgets('Add transaction FAB still works from transactions page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/transactions');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('transactions_add_transaction_fab')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('add_transaction_amount_field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('add_transaction_submit_button')),
      findsOneWidget,
    );
  });

  testWidgets('Dashboard shows month selector buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('month_selector_previous')), findsWidgets);
    expect(find.byKey(const Key('month_selector_next')), findsWidgets);
  });

  testWidgets('Dashboard shows month label key', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('dashboard_month_label')), findsOneWidget);
  });

  testWidgets('Dashboard month label is present and shows current month', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/');
    await tester.pumpAndSettle();

    final label = tester.widget<Text>(
      find.byKey(const Key('dashboard_month_label')),
    );
    expect(label.data, contains('Tháng'));
  });

  testWidgets('Dashboard month changes when previous is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    appRouter.go('/');
    await tester.pumpAndSettle();

    final prevBtn = find.descendant(
      of: find.byType(DashboardPage),
      matching: find.byKey(const Key('month_selector_previous')),
    );

    final labelBefore = tester.widget<Text>(
      find.byKey(const Key('dashboard_month_label')),
    );
    final labelBeforeData = labelBefore.data;

    await tester.tap(prevBtn.first);
    await tester.pumpAndSettle();

    final labelAfter = tester.widget<Text>(
      find.byKey(const Key('dashboard_month_label')),
    );
    expect(labelAfter.data, isNot(equals(labelBeforeData)));
  });

  testWidgets('Statistics page shows month label via goRouter', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    await tester.pumpAndSettle();

    appRouter.go('/statistics');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('statistics_month_label')), findsOneWidget);
  });

  testWidgets('Search does not crash dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
        ],
        child: const ExpenseApp(),
      ),
    );
    await tester.pumpAndSettle();

    appRouter.go('/transactions');
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('transaction_filter_search_field')),
      'lương',
    );
    await tester.pumpAndSettle();

    appRouter.go('/');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('dashboard_month_label')), findsOneWidget);
    expect(find.text('Số dư hiện tại'), findsOneWidget);
  });
}
