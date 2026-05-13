import 'package:expense_app/features/pay_later/data/pay_later_repository.dart';
import 'package:expense_app/features/pay_later/data/pay_later_storage_codec.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPayLaterRepository implements PayLaterRepository {
  SharedPreferencesPayLaterRepository({
    Future<SharedPreferences> Function()? preferencesLoader,
  }) : _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance;

  static const String _storageKey = 'expense_app.web.pay_later.v1';
  static const String _corruptStorageKey =
      'expense_app.web.pay_later.corrupt.v1';

  final Future<SharedPreferences> Function() _preferencesLoader;

  final List<InstallmentPlan> _plans = <InstallmentPlan>[];
  final List<PayLaterInvoice> _invoices = <PayLaterInvoice>[];
  final List<PayLaterPayment> _payments = <PayLaterPayment>[];

  Future<void>? _loadFuture;

  @override
  Future<List<InstallmentPlan>> getInstallmentPlans() async {
    await _ensureLoaded();
    return List<InstallmentPlan>.unmodifiable(_plans);
  }

  @override
  Future<List<PayLaterInvoice>> getInvoices() async {
    await _ensureLoaded();
    return List<PayLaterInvoice>.unmodifiable(_invoices);
  }

  @override
  Future<List<PayLaterPayment>> getPayments() async {
    await _ensureLoaded();
    return List<PayLaterPayment>.unmodifiable(_payments);
  }

  @override
  Future<void> addInstallmentPlan(InstallmentPlan plan) async {
    await _ensureLoaded();
    _plans.add(plan);
    await _persist();
  }

  @override
  Future<void> updateInstallmentPlan(InstallmentPlan plan) async {
    await _ensureLoaded();
    final int index = _plans.indexWhere(
      (InstallmentPlan item) => item.id == plan.id,
    );
    if (index == -1) {
      throw StateError('Installment plan not found: ${plan.id}');
    }

    _plans[index] = plan;
    await _persist();
  }

  @override
  Future<void> deleteInstallmentPlan(String id) async {
    await _ensureLoaded();
    _plans.removeWhere((InstallmentPlan plan) => plan.id == id);
    await _persist();
  }

  @override
  Future<void> addInvoice(PayLaterInvoice invoice) async {
    await _ensureLoaded();
    _invoices.add(invoice);
    await _persist();
  }

  @override
  Future<void> updateInvoice(PayLaterInvoice invoice) async {
    await _ensureLoaded();
    final int index = _invoices.indexWhere(
      (PayLaterInvoice item) => item.id == invoice.id,
    );
    if (index == -1) {
      throw StateError('Pay later invoice not found: ${invoice.id}');
    }

    _invoices[index] = invoice;
    await _persist();
  }

  @override
  Future<void> deleteInvoice(String id) async {
    await _ensureLoaded();
    _invoices.removeWhere((PayLaterInvoice invoice) => invoice.id == id);
    await _persist();
  }

  @override
  Future<void> recordPayment(
    PayLaterPayment payment, {
    InstallmentPlan? updatedPlan,
    PayLaterInvoice? updatedInvoice,
  }) async {
    await _ensureLoaded();
    if (payment.targetType == PayLaterTargetType.installmentPlan) {
      if (updatedPlan == null ||
          updatedPlan.id != payment.targetId ||
          updatedInvoice != null) {
        throw ArgumentError(
          'An updated installment plan is required for payment ${payment.id}.',
        );
      }

      final int index = _plans.indexWhere(
        (InstallmentPlan item) => item.id == payment.targetId,
      );
      if (index == -1) {
        throw StateError('Installment plan not found: ${payment.targetId}');
      }

      _plans[index] = updatedPlan;
    } else {
      if (updatedInvoice == null ||
          updatedInvoice.id != payment.targetId ||
          updatedPlan != null) {
        throw ArgumentError(
          'An updated invoice is required for payment ${payment.id}.',
        );
      }

      final int index = _invoices.indexWhere(
        (PayLaterInvoice item) => item.id == payment.targetId,
      );
      if (index == -1) {
        throw StateError('Pay later invoice not found: ${payment.targetId}');
      }

      _invoices[index] = updatedInvoice;
    }

    _payments.add(payment);
    await _persist();
  }

  Future<void> _ensureLoaded() {
    return _loadFuture ??= _loadSnapshot();
  }

  Future<void> _loadSnapshot() async {
    final SharedPreferences preferences = await _preferencesLoader();
    final String? rawJson = preferences.getString(_storageKey);
    if (rawJson == null || rawJson.trim().isEmpty) {
      return;
    }

    try {
      final (
        :List<InstallmentPlan> plans,
        :List<PayLaterInvoice> invoices,
        :List<PayLaterPayment> payments,
      ) = decodePayLaterStorageJson(
        rawJson,
      );
      _plans
        ..clear()
        ..addAll(plans);
      _invoices
        ..clear()
        ..addAll(invoices);
      _payments
        ..clear()
        ..addAll(payments);
    } on FormatException {
      await preferences.setString(_corruptStorageKey, rawJson);
      _plans.clear();
      _invoices.clear();
      _payments.clear();
      await _persist();
    }
  }

  Future<void> _persist() async {
    final SharedPreferences preferences = await _preferencesLoader();
    await preferences.setString(
      _storageKey,
      encodePayLaterStorageJson(
        plans: _plans,
        invoices: _invoices,
        payments: _payments,
      ),
    );
  }

  @override
  Future<void> replaceAll({
    required List<InstallmentPlan> plans,
    required List<PayLaterInvoice> invoices,
    required List<PayLaterPayment> payments,
  }) async {
    await _ensureLoaded();
    _plans
      ..clear()
      ..addAll(plans);
    _invoices
      ..clear()
      ..addAll(invoices);
    _payments
      ..clear()
      ..addAll(payments);
    await _persist();
  }
}
