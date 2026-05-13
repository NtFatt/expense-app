import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/features/transactions/presentation/widgets/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('changing transaction type resets category to a valid option', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocale.supportedLocales,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppStrings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: TransactionForm(
            description: 'Test form',
            submitButtonLabel: 'Lưu',
            isSubmitting: false,
            onSubmit: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ăn uống'), findsOneWidget);

    await tester.tap(find.text('Thu'));
    await tester.pumpAndSettle();

    expect(find.text('Lương'), findsOneWidget);

    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });
  });
}
