import 'package:expense_app/features/pay_later/data/in_memory_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/data/pay_later_repository_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pay later factory defaults to in-memory during flutter test', () {
    expect(
      createDefaultPayLaterRepository(),
      isA<InMemoryPayLaterRepository>(),
    );
  });
}
