import 'package:expense_app/features/transactions/domain/transaction_type.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.note,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final TransactionType type;
  final int amount;
  final String category;
  final String? note;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isIncome => type.isIncome;

  bool get isExpense => type.isExpense;

  int get signedAmount => isIncome ? amount : -amount;

  String get displayTitle {
    final String? trimmedNote = note?.trim();
    if (trimmedNote == null || trimmedNote.isEmpty) {
      return category;
    }

    return trimmedNote;
  }

  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    int? amount,
    String? category,
    Object? note = _copySentinel,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: identical(note, _copySentinel) ? this.note : note as String?,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

const Object _copySentinel = Object();
