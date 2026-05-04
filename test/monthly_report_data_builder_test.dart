import 'package:expense_app/features/reports/data/monthly_report_data_builder.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionModel _tx({
  required String id,
  required TransactionType type,
  required int amount,
  required String category,
  String? note,
  required DateTime date,
  DateTime? createdAt,
}) {
  final ts = createdAt ?? date;
  return TransactionModel(
    id: id,
    type: type,
    amount: amount,
    category: category,
    note: note,
    transactionDate: date,
    createdAt: ts,
    updatedAt: ts,
  );
}

void main() {
  group('MonthlyReportDataBuilder', () {
    late MonthlyReportDataBuilder builder;

    setUp(() {
      builder = const MonthlyReportDataBuilder();
    });

    test('filters transactions by selected month', () {
      final transactions = [
        _tx(id: '1', type: TransactionType.expense, amount: 10000,
            category: 'Food', date: DateTime(2026, 5, 5)),
        _tx(id: '2', type: TransactionType.expense, amount: 20000,
            category: 'Transport', date: DateTime(2026, 5, 10)),
        _tx(id: '3', type: TransactionType.income, amount: 50000,
            category: 'Salary', date: DateTime(2026, 6, 1)),
      ];

      final report = builder.build(
        transactions: transactions,
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 4, 12, 0),
      );

      expect(report.transactions.length, 2);
      expect(report.selectedMonth, DateTime(2026, 5));
    });

    test('does not include transactions from other months', () {
      final transactions = [
        _tx(id: '1', type: TransactionType.expense, amount: 10000,
            category: 'Food', date: DateTime(2026, 3, 15)),
        _tx(id: '2', type: TransactionType.expense, amount: 20000,
            category: 'Food', date: DateTime(2026, 5, 15)),
        _tx(id: '3', type: TransactionType.expense, amount: 30000,
            category: 'Food', date: DateTime(2026, 7, 15)),
      ];

      final report = builder.build(
        transactions: transactions,
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 31),
      );

      expect(report.transactions.length, 1);
      expect(report.transactions.first.id, '2');
    });

    test('builds correct totalIncome and totalExpense', () {
      final transactions = [
        _tx(id: '1', type: TransactionType.expense, amount: 30000,
            category: 'Food', date: DateTime(2026, 5, 5)),
        _tx(id: '2', type: TransactionType.income, amount: 100000,
            category: 'Salary', date: DateTime(2026, 5, 1)),
        _tx(id: '3', type: TransactionType.expense, amount: 20000,
            category: 'Transport', date: DateTime(2026, 5, 10)),
      ];

      final report = builder.build(
        transactions: transactions,
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 31),
      );

      expect(report.summary.totalIncome, 100000);
      expect(report.summary.totalExpense, 50000);
      expect(report.summary.balance, 50000);
    });

    test('empty month returns empty transactions and zero summary', () {
      final transactions = [
        _tx(id: '1', type: TransactionType.expense, amount: 10000,
            category: 'Food', date: DateTime(2026, 3, 5)),
      ];

      final report = builder.build(
        transactions: transactions,
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 31),
      );

      expect(report.transactions, isEmpty);
      expect(report.summary.totalIncome, 0);
      expect(report.summary.totalExpense, 0);
      expect(report.summary.balance, 0);
      expect(report.transactionCount, 0);
    });

    test('does not mutate original list', () {
      final transactions = [
        _tx(id: '1', type: TransactionType.expense, amount: 10000,
            category: 'Food', date: DateTime(2026, 5, 5)),
        _tx(id: '2', type: TransactionType.expense, amount: 20000,
            category: 'Transport', date: DateTime(2026, 5, 10)),
      ];
      final originalLength = transactions.length;

      builder.build(
        transactions: transactions,
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 31),
      );

      expect(transactions.length, originalLength);
    });

    test('hasTransactions is true when transactions exist', () {
      final transactions = [
        _tx(id: '1', type: TransactionType.expense, amount: 10000,
            category: 'Food', date: DateTime(2026, 5, 5)),
      ];

      final report = builder.build(
        transactions: transactions,
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 31),
      );

      expect(report.hasTransactions, isTrue);
    });

    test('hasTransactions is false when no transactions', () {
      final report = builder.build(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 31),
      );

      expect(report.hasTransactions, isFalse);
    });

    test('hasExpenses is true when expenses exist', () {
      final transactions = [
        _tx(id: '1', type: TransactionType.expense, amount: 10000,
            category: 'Food', date: DateTime(2026, 5, 5)),
      ];

      final report = builder.build(
        transactions: transactions,
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 31),
      );

      expect(report.hasExpenses, isTrue);
    });

    test('hasExpenses is false when only income', () {
      final transactions = [
        _tx(id: '1', type: TransactionType.income, amount: 50000,
            category: 'Salary', date: DateTime(2026, 5, 1)),
      ];

      final report = builder.build(
        transactions: transactions,
        selectedMonth: DateTime(2026, 5),
        generatedAt: DateTime(2026, 5, 31),
      );

      expect(report.hasExpenses, isFalse);
    });

    test('generatedAt is preserved in report data', () {
      final generatedAt = DateTime(2026, 5, 31, 14, 30);

      final report = builder.build(
        transactions: [],
        selectedMonth: DateTime(2026, 5),
        generatedAt: generatedAt,
      );

      expect(report.generatedAt, generatedAt);
    });
  });
}
