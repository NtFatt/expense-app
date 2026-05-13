import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:expense_app/features/transactions/data/transaction_repository.dart';
import 'package:expense_app/features/transactions/data/transaction_storage_codec.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTransactionRepository implements TransactionRepository {
  SharedPreferencesTransactionRepository({
    Future<SharedPreferences> Function()? preferencesLoader,
    List<TransactionModel> Function()? seedBuilder,
  }) : _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance,
       _seedBuilder =
           seedBuilder ?? InMemoryTransactionRepository.seedTransactions;

  static const String _storageKey = 'expense_app.web.transactions.v1';
  static const String _corruptStorageKey =
      'expense_app.web.transactions.corrupt.v1';

  final Future<SharedPreferences> Function() _preferencesLoader;
  final List<TransactionModel> Function() _seedBuilder;

  List<TransactionModel>? _transactions;
  Future<void>? _loadFuture;

  @override
  Future<List<TransactionModel>> getTransactions() async {
    await _ensureLoaded();
    return List<TransactionModel>.unmodifiable(_transactions!);
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _ensureLoaded();
    _transactions!.add(transaction);
    await _persist();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _ensureLoaded();
    final int transactionIndex = _transactions!.indexWhere(
      (TransactionModel item) => item.id == transaction.id,
    );

    if (transactionIndex == -1) {
      throw StateError('Transaction not found: ${transaction.id}');
    }

    _transactions![transactionIndex] = transaction;
    await _persist();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _ensureLoaded();
    _transactions!.removeWhere(
      (TransactionModel transaction) => transaction.id == id,
    );
    await _persist();
  }

  @override
  Future<void> clearAll() async {
    await _ensureLoaded();
    _transactions!.clear();
    await _persist();
  }

  @override
  Future<void> replaceAll(List<TransactionModel> transactions) async {
    await _ensureLoaded();
    _transactions!
      ..clear()
      ..addAll(transactions);
    await _persist();
  }

  Future<void> _ensureLoaded() {
    return _loadFuture ??= _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final SharedPreferences preferences = await _preferencesLoader();
    final String? rawJson = preferences.getString(_storageKey);
    if (rawJson == null || rawJson.trim().isEmpty) {
      _transactions = <TransactionModel>[..._seedBuilder()];
      return;
    }

    try {
      _transactions = <TransactionModel>[...decodeTransactionsJson(rawJson)];
    } on FormatException {
      await preferences.setString(_corruptStorageKey, rawJson);
      _transactions = <TransactionModel>[..._seedBuilder()];
      await _persist();
    }
  }

  Future<void> _persist() async {
    final SharedPreferences preferences = await _preferencesLoader();
    await preferences.setString(
      _storageKey,
      encodeTransactionsJson(_transactions!),
    );
  }
}
