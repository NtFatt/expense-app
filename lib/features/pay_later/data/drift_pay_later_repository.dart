import 'package:drift/drift.dart';
import 'package:expense_app/core/database/app_database.dart' as database;
import 'package:expense_app/features/pay_later/data/pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';

class DriftPayLaterRepository implements PayLaterRepository {
  DriftPayLaterRepository(this._database);

  static const int _moneyScale = 100;

  final database.AppDatabase _database;

  @override
  Future<List<InstallmentPlan>> getInstallmentPlans() async {
    final List<database.PayLaterInstallmentPlan> rows =
        await (_database.select(_database.payLaterInstallmentPlans)..orderBy([
              (table) => OrderingTerm.asc(table.createdAt),
              (table) => OrderingTerm.asc(table.id),
            ]))
            .get();
    return rows.map(_mapPlanRowToModel).toList();
  }

  @override
  Future<List<PayLaterInvoice>> getInvoices() async {
    final List<database.PayLaterInvoice> rows =
        await (_database.select(_database.payLaterInvoices)..orderBy([
              (table) => OrderingTerm.asc(table.createdAt),
              (table) => OrderingTerm.asc(table.id),
            ]))
            .get();
    return rows.map(_mapInvoiceRowToModel).toList();
  }

  @override
  Future<List<PayLaterPayment>> getPayments() async {
    final List<database.PayLaterPayment> rows =
        await (_database.select(_database.payLaterPayments)..orderBy([
              (table) => OrderingTerm.asc(table.createdAt),
              (table) => OrderingTerm.asc(table.id),
            ]))
            .get();
    return rows.map(_mapPaymentRowToModel).toList();
  }

  @override
  Future<void> addInstallmentPlan(InstallmentPlan plan) async {
    await _database
        .into(_database.payLaterInstallmentPlans)
        .insert(_mapPlanToCompanion(plan));
  }

  @override
  Future<void> updateInstallmentPlan(InstallmentPlan plan) async {
    final int updatedRows = await _updateInstallmentPlanRow(plan);
    if (updatedRows == 0) {
      throw StateError('Installment plan not found: ${plan.id}');
    }
  }

  @override
  Future<void> deleteInstallmentPlan(String id) async {
    await (_database.delete(
      _database.payLaterInstallmentPlans,
    )..where((table) => table.id.equals(id))).go();
  }

  @override
  Future<void> addInvoice(PayLaterInvoice invoice) async {
    await _database
        .into(_database.payLaterInvoices)
        .insert(_mapInvoiceToCompanion(invoice));
  }

  @override
  Future<void> updateInvoice(PayLaterInvoice invoice) async {
    final int updatedRows = await _updateInvoiceRow(invoice);
    if (updatedRows == 0) {
      throw StateError('Pay later invoice not found: ${invoice.id}');
    }
  }

  @override
  Future<void> deleteInvoice(String id) async {
    await (_database.delete(
      _database.payLaterInvoices,
    )..where((table) => table.id.equals(id))).go();
  }

  @override
  Future<void> recordPayment(
    PayLaterPayment payment, {
    InstallmentPlan? updatedPlan,
    PayLaterInvoice? updatedInvoice,
  }) async {
    await _database.transaction(() async {
      if (payment.targetType == PayLaterTargetType.installmentPlan) {
        if (updatedPlan == null ||
            updatedPlan.id != payment.targetId ||
            updatedInvoice != null) {
          throw ArgumentError(
            'An updated installment plan is required for payment ${payment.id}.',
          );
        }

        final int updatedRows = await _updateInstallmentPlanRow(updatedPlan);
        if (updatedRows == 0) {
          throw StateError('Installment plan not found: ${payment.targetId}');
        }
      } else {
        if (updatedInvoice == null ||
            updatedInvoice.id != payment.targetId ||
            updatedPlan != null) {
          throw ArgumentError(
            'An updated invoice is required for payment ${payment.id}.',
          );
        }

        final int updatedRows = await _updateInvoiceRow(updatedInvoice);
        if (updatedRows == 0) {
          throw StateError('Pay later invoice not found: ${payment.targetId}');
        }
      }

      await _database
          .into(_database.payLaterPayments)
          .insert(_mapPaymentToCompanion(payment));
    });
  }

  Future<int> _updateInstallmentPlanRow(InstallmentPlan plan) {
    return (_database.update(_database.payLaterInstallmentPlans)
          ..where((table) => table.id.equals(plan.id)))
        .write(_mapPlanToCompanion(plan));
  }

  Future<int> _updateInvoiceRow(PayLaterInvoice invoice) {
    return (_database.update(_database.payLaterInvoices)
          ..where((table) => table.id.equals(invoice.id)))
        .write(_mapInvoiceToCompanion(invoice));
  }

  InstallmentPlan _mapPlanRowToModel(database.PayLaterInstallmentPlan row) {
    return InstallmentPlan(
      id: row.id,
      title: row.title,
      providerName: row.providerName,
      originalAmount: _decodeMoney(row.originalAmount),
      monthlyPaymentAmount: _decodeMoney(row.monthlyPaymentAmount),
      minimumPaymentAmount: _decodeMoney(row.minimumPaymentAmount),
      paidAmount: _decodeMoney(row.paidAmount),
      totalInstallments: row.totalInstallments,
      paidInstallments: row.paidInstallments,
      startDate: row.startDate,
      dueDayOfMonth: row.dueDayOfMonth,
      status: InstallmentStatusCodec.fromName(row.status),
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  PayLaterInvoice _mapInvoiceRowToModel(database.PayLaterInvoice row) {
    return PayLaterInvoice(
      id: row.id,
      providerName: row.providerName,
      statementMonth: row.statementMonth,
      statementDate: row.statementDate,
      dueDate: row.dueDate,
      totalAmount: _decodeMoney(row.totalAmount),
      minimumPaymentAmount: _decodeMoney(row.minimumPaymentAmount),
      paidAmount: _decodeMoney(row.paidAmount),
      status: PayLaterInvoiceStatusCodec.fromName(row.status),
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  PayLaterPayment _mapPaymentRowToModel(database.PayLaterPayment row) {
    return PayLaterPayment(
      id: row.id,
      targetId: row.targetId,
      targetType: PayLaterTargetTypeCodec.fromName(row.targetType),
      amount: _decodeMoney(row.amount),
      paymentType: PayLaterPaymentTypeCodec.fromName(row.paymentType),
      paidAt: row.paidAt,
      note: row.note,
      createdAt: row.createdAt,
    );
  }

  database.PayLaterInstallmentPlansCompanion _mapPlanToCompanion(
    InstallmentPlan plan,
  ) {
    return database.PayLaterInstallmentPlansCompanion.insert(
      id: plan.id,
      title: plan.title,
      providerName: plan.providerName,
      originalAmount: _encodeMoney(plan.originalAmount),
      monthlyPaymentAmount: _encodeMoney(plan.monthlyPaymentAmount),
      minimumPaymentAmount: _encodeMoney(plan.minimumPaymentAmount),
      paidAmount: _encodeMoney(plan.paidAmount),
      totalInstallments: plan.totalInstallments,
      paidInstallments: plan.paidInstallments,
      startDate: plan.startDate,
      dueDayOfMonth: plan.dueDayOfMonth,
      status: plan.status.name,
      note: Value<String?>(plan.note),
      createdAt: plan.createdAt,
      updatedAt: plan.updatedAt,
    );
  }

  database.PayLaterInvoicesCompanion _mapInvoiceToCompanion(
    PayLaterInvoice invoice,
  ) {
    return database.PayLaterInvoicesCompanion.insert(
      id: invoice.id,
      providerName: invoice.providerName,
      statementMonth: invoice.statementMonth,
      statementDate: invoice.statementDate,
      dueDate: invoice.dueDate,
      totalAmount: _encodeMoney(invoice.totalAmount),
      minimumPaymentAmount: _encodeMoney(invoice.minimumPaymentAmount),
      paidAmount: _encodeMoney(invoice.paidAmount),
      status: invoice.status.name,
      note: Value<String?>(invoice.note),
      createdAt: invoice.createdAt,
      updatedAt: invoice.updatedAt,
    );
  }

  database.PayLaterPaymentsCompanion _mapPaymentToCompanion(
    PayLaterPayment payment,
  ) {
    return database.PayLaterPaymentsCompanion.insert(
      id: payment.id,
      targetId: payment.targetId,
      targetType: payment.targetType.name,
      amount: _encodeMoney(payment.amount),
      paymentType: payment.paymentType.name,
      paidAt: payment.paidAt,
      note: Value<String?>(payment.note),
      createdAt: payment.createdAt,
    );
  }

  int _encodeMoney(double amount) {
    return (amount * _moneyScale).round();
  }

  double _decodeMoney(int storedAmount) {
    return double.parse((storedAmount / _moneyScale).toStringAsFixed(2));
  }
}
