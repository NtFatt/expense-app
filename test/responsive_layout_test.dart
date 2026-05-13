import 'package:expense_app/app/app.dart';
import 'package:expense_app/app/router.dart';
import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/features/pay_later/data/in_memory_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/presentation/controllers/pay_later_controller.dart';
import 'package:expense_app/features/pay_later/presentation/pages/pay_later_page.dart';
import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    appRouter.go('/');
  });

  testWidgets('Dashboard renders on a narrow viewport without overflow', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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

    expect(find.text('Tổng quan'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Transactions and statistics render on a narrow viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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
    expect(find.text('Giao dịch'), findsWidgets);
    expect(tester.takeException(), isNull);

    appRouter.go('/statistics');
    await tester.pumpAndSettle();
    expect(find.text('Thống kê'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Reports page renders on a narrow viewport without overflow', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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

    appRouter.go('/reports');
    await tester.pumpAndSettle();

    expect(find.text('Báo cáo'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Pay Later cards render on a narrow viewport with seeded data', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final InMemoryPayLaterRepository repository = InMemoryPayLaterRepository();
    final DateTime now = DateTime(2026, 5, 8);
    await repository.addInstallmentPlan(
      InstallmentPlan(
        id: 'plan-1',
        title: 'Web Plan 20260508 Ultra Long Name',
        providerName: 'Ngân hàng số rất dài',
        originalAmount: 1200000,
        monthlyPaymentAmount: 200000,
        minimumPaymentAmount: 180000,
        paidAmount: 400000,
        totalInstallments: 6,
        paidInstallments: 2,
        startDate: DateTime(2026, 3, 1),
        dueDayOfMonth: 18,
        status: InstallmentStatus.active,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repository.addInvoice(
      PayLaterInvoice(
        id: 'invoice-1',
        providerName: 'Card B Premium Rewards',
        statementMonth: DateTime(2026, 5),
        statementDate: DateTime(2026, 5, 1),
        dueDate: DateTime(2026, 5, 20),
        totalAmount: 820000,
        minimumPaymentAmount: 80000,
        paidAmount: 300000,
        status: PayLaterInvoiceStatus.unpaid,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [payLaterRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocale.supportedLocales,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppStrings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const PayLaterPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Trả sau & trả góp'), findsOneWidget);
    expect(find.text('Web Plan 20260508 Ultra Long Name'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
