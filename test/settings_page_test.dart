import 'package:expense_app/app/app.dart';
import 'package:expense_app/app/router.dart';
import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/features/settings/data/app_preferences_repository.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:expense_app/features/settings/presentation/controllers/app_preferences_controller.dart';
import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Settings page renders and language selection updates UI', (
    WidgetTester tester,
  ) async {
    final FakeAppPreferencesRepository repository =
        FakeAppPreferencesRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(
            InMemoryTransactionRepository(),
          ),
          appPreferencesRepositoryProvider.overrideWithValue(repository),
        ],
        child: const ExpenseApp(),
      ),
    );
    await tester.pumpAndSettle();

    appRouter.go('/settings');
    await tester.pumpAndSettle();

    expect(find.text('Cài đặt'), findsWidgets);
    expect(find.text('Ngôn ngữ'), findsOneWidget);
    expect(find.text('Giao diện'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Language'), findsOneWidget);
    expect(repository.saved.locale, AppLocale.en);
  });
}

class FakeAppPreferencesRepository implements AppPreferencesRepository {
  AppPreferences saved = AppPreferences.defaults.copyWith(
    theme: AppThemePreference.system,
  );

  @override
  Future<AppPreferences> loadPreferences() async {
    return saved;
  }

  @override
  Future<void> savePreferences(AppPreferences preferences) async {
    saved = preferences;
  }
}
