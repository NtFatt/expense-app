enum TransactionType {
  expense,
  income;

  String get label {
    switch (this) {
      case TransactionType.expense:
        return 'Chi tiêu';
      case TransactionType.income:
        return 'Thu nhập';
    }
  }

  bool get isExpense => this == TransactionType.expense;

  bool get isIncome => this == TransactionType.income;

  static TransactionType fromName(String value) {
    final String normalized = value.trim().toLowerCase();
    return TransactionType.values.firstWhere(
      (TransactionType type) => type.name == normalized,
      orElse: () => TransactionType.expense,
    );
  }
}
