import 'package:expense_app/features/transactions/domain/transaction_type.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.iconKey,
  });

  final String id;
  final String name;
  final TransactionType type;
  final String? iconKey;
}
