import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:expense_app/features/transactions/data/transaction_repository.dart';

TransactionRepository createDefaultTransactionRepository() {
  return InMemoryTransactionRepository();
}
