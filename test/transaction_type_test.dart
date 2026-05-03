import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionType.fromName', () {
    test('returns expense for "expense"', () {
      expect(TransactionType.fromName('expense'), TransactionType.expense);
    });

    test('returns income for "income"', () {
      expect(TransactionType.fromName('income'), TransactionType.income);
    });

    test('is case-insensitive for "EXPENSE"', () {
      expect(TransactionType.fromName('EXPENSE'), TransactionType.expense);
    });

    test('is case-insensitive for "Income"', () {
      expect(TransactionType.fromName('Income'), TransactionType.income);
    });

    test('trims whitespace and returns expense', () {
      expect(TransactionType.fromName('  expense  '), TransactionType.expense);
    });

    test('trims whitespace and returns income', () {
      expect(TransactionType.fromName('  income  '), TransactionType.income);
    });

    test('falls back to expense for unknown string', () {
      expect(TransactionType.fromName('unknown'), TransactionType.expense);
      expect(TransactionType.fromName(''), TransactionType.expense);
      expect(TransactionType.fromName('  '), TransactionType.expense);
    });
  });

  group('TransactionType.label', () {
    test('expense label is Vietnamese', () {
      expect(TransactionType.expense.label, 'Chi tiêu');
    });

    test('income label is Vietnamese', () {
      expect(TransactionType.income.label, 'Thu nhập');
    });
  });

  group('TransactionType helpers', () {
    test('isExpense returns true for expense', () {
      expect(TransactionType.expense.isExpense, true);
      expect(TransactionType.expense.isIncome, false);
    });

    test('isIncome returns true for income', () {
      expect(TransactionType.income.isIncome, true);
      expect(TransactionType.income.isExpense, false);
    });
  });
}
