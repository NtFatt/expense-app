import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/features/pay_later/data/in_memory_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/presentation/controllers/pay_later_controller.dart';
import 'package:expense_app/features/pay_later/presentation/pages/pay_later_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'PayLaterPage renders summary cards, empty state, and policy notes',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            payLaterRepositoryProvider.overrideWithValue(
              InMemoryPayLaterRepository(),
            ),
          ],
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
      expect(
        find.byKey(const Key('pay_later_total_outstanding_card')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('pay_later_empty_state')), findsOneWidget);
      expect(find.text('Lưu ý chính sách'), findsOneWidget);
      expect(find.text('Chưa có dữ liệu trả sau'), findsOneWidget);
    },
  );
}
