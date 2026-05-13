import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/features/pay_later/presentation/widgets/payment_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('custom payment save button disables until amount is valid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('vi'),
        supportedLocales: AppLocale.supportedLocales,
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          AppStrings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: _DialogLauncher(),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trả số tiền khác'));
    await tester.pumpAndSettle();

    FilledButton saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Lưu'),
    );
    expect(saveButton.onPressed, isNull);

    await tester.enterText(find.byType(TextFormField), '150000');
    await tester.pumpAndSettle();
    saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Lưu'),
    );
    expect(saveButton.onPressed, isNull);

    await tester.enterText(find.byType(TextFormField), '80000');
    await tester.pumpAndSettle();
    saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Lưu'),
    );
    expect(saveButton.onPressed, isNotNull);
  });
}

class _DialogLauncher extends StatelessWidget {
  const _DialogLauncher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () {
            showPaymentActionDialog(
              context: context,
              title: 'Phone',
              outstandingAmount: 100000,
              minimumAmount: 20000,
            );
          },
          child: const Text('Open'),
        ),
      ),
    );
  }
}
