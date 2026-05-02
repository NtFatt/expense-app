import 'package:expense_app/app/app.dart';
import 'package:expense_app/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Expense app renders dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ExpenseApp()));
    await tester.pumpAndSettle();

    expect(find.text('Quản lý chi tiêu'), findsOneWidget);
    expect(find.text('Số dư hiện tại'), findsOneWidget);
    expect(find.text('Giao dịch gần đây'), findsOneWidget);
    expect(find.text('Tổng quan'), findsOneWidget);
  });

  testWidgets('Bottom navigation opens transactions page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ExpenseApp()));
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
    await tester.pumpWidget(const ProviderScope(child: ExpenseApp()));
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
    await tester.pumpWidget(const ProviderScope(child: ExpenseApp()));
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
}
