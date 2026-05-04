import 'package:expense_app/features/reports/data/csv_transaction_exporter.dart';
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
  const exporter = CsvTransactionExporter();

  group('CsvTransactionExporter', () {
    test('generates UTF-8 BOM as first character', () {
      final output = exporter.generate([]);
      expect(output.codeUnitAt(0), 0xFEFF);
    });

    test('generates correct header after BOM', () {
      final output = exporter.generate([]);
      final nonBom = output.substring(1);
      final lines = nonBom.split('\n').where((l) => l.isNotEmpty).toList();
      expect(lines[0], 'id,date,type,category,amount,signed_amount,note,created_at,updated_at');
    });

    test('empty list produces BOM line plus header line', () {
      final output = exporter.generate([]);
      final nonBom = output.substring(1);
      final lines = nonBom.split('\n').where((l) => l.isNotEmpty).toList();
      expect(lines.length, 1);
      expect(lines[0], 'id,date,type,category,amount,signed_amount,note,created_at,updated_at');
    });

    test('exports id field', () {
      final output = exporter.generate([
        _tx(id: 'tx-123', type: TransactionType.expense, amount: 1,
            category: 'X', date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('tx-123'));
    });

    test('date formatted as YYYY-MM-DD', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'X', date: DateTime(2026, 3, 7)),
      ]);
      expect(output, contains('2026-03-07'));
    });

    test('type field is income', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.income, amount: 1000000,
            category: 'Lương', date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('income'));
    });

    test('type field is expense', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 50000,
            category: 'Ăn uống', date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('expense'));
    });

    test('exports category', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'Di chuyển', date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('Di chuyển'));
    });

    test('amount field is positive', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 98765,
            category: 'Ăn uống', date: DateTime(2026, 1, 1)),
      ]);
      final nonBom = output.substring(1);
      final dataLine = nonBom.split('\n').firstWhere((l) => l.contains('a,'));
      // Amount (5th field) should NOT start with '-'. It should start with the digit.
      // The 5th field: id,date,type,category,amount,signed_amount,...
      // Use regex to ensure we match the amount field, not the signed_amount field.
      expect(RegExp(r',98765,').hasMatch(dataLine), isTrue);
    });

    test('expense signed_amount is negative', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 35000,
            category: 'Ăn uống', date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('-35000'));
    });

    test('income signed_amount is positive (no minus)', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.income, amount: 1500000,
            category: 'Lương', date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('1500000'));
      expect(output.contains('-1500000'), isFalse);
    });

    test('null note exports as empty cell', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'X', note: null, date: DateTime(2026, 1, 1)),
      ]);
      final nonBom = output.substring(1);
      final dataLine = nonBom.split('\n').firstWhere((l) => l.contains('a,'));
      expect(dataLine, contains(',,'));
    });

    test('non-null note is exported', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'Ăn uống', note: 'Ăn sáng', date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('Ăn sáng'));
    });

    test('Vietnamese text preserved', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'Ăn uống', note: 'Cơm trưa công ty',
            date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('Ăn uống'));
      expect(output, contains('Cơm trưa công ty'));
    });

    test('escapes comma inside cell value', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'Ăn uống', note: 'Hàng, Quán',
            date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('"Hàng, Quán"'));
    });

    test('escapes double quote inside cell value', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'X', note: 'Nói "Cảm ơn"',
            date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('"Nói ""Cảm ơn"""'));
    });

    test('escapes newline inside cell value', () {
      final output = exporter.generate([
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'X', note: 'Line1\nLine2',
            date: DateTime(2026, 1, 1)),
      ]);
      expect(output, contains('"Line1\nLine2"'));
    });

    test('sorts newest transactionDate first', () {
      final output = exporter.generate([
        _tx(id: 'older', type: TransactionType.expense, amount: 1, category: 'X',
            date: DateTime(2026, 1, 1)),
        _tx(id: 'newer', type: TransactionType.expense, amount: 2, category: 'X',
            date: DateTime(2026, 3, 1)),
        _tx(id: 'mid',   type: TransactionType.expense, amount: 3, category: 'X',
            date: DateTime(2026, 2, 1)),
      ]);
      final nonBom = output.substring(1);
      final lines = nonBom.split('\n').where((l) => l.isNotEmpty).toList();
      expect(lines[0], 'id,date,type,category,amount,signed_amount,note,created_at,updated_at');
      expect(lines[1], contains('newer'));
      expect(lines[2], contains('mid'));
      expect(lines[3], contains('older'));
    });

    test('same transactionDate sorted by createdAt descending', () {
      final sameDate = DateTime(2026, 5, 1);
      final output = exporter.generate([
        _tx(id: 'early', type: TransactionType.expense, amount: 1, category: 'X',
            date: sameDate, createdAt: DateTime(2026, 5, 1, 8, 0)),
        _tx(id: 'late',  type: TransactionType.expense, amount: 2, category: 'X',
            date: sameDate, createdAt: DateTime(2026, 5, 1, 12, 0)),
      ]);
      final nonBom = output.substring(1);
      final lines = nonBom.split('\n').where((l) => l.isNotEmpty).toList();
      expect(lines[1], contains('late'));
      expect(lines[2], contains('early'));
    });

    test('does not mutate original list', () {
      final original = [
        _tx(id: 'a', type: TransactionType.expense, amount: 1,
            category: 'X', date: DateTime(2026, 1, 1)),
      ];
      final copyLength = original.length;
      exporter.generate(original);
      expect(original.length, copyLength);
    });
  });
}
