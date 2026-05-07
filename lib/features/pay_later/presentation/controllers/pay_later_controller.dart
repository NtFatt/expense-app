import 'dart:math' as math;

import 'package:expense_app/features/pay_later/data/pay_later_repository.dart';
import 'package:expense_app/features/pay_later/data/pay_later_repository_factory.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final payLaterRepositoryProvider = Provider<PayLaterRepository>(
  (Ref ref) => createDefaultPayLaterRepository(),
);

final payLaterControllerProvider =
    AsyncNotifierProvider<PayLaterController, PayLaterState>(
      PayLaterController.new,
    );

class PayLaterController extends AsyncNotifier<PayLaterState> {
  static const double _epsilon = 0.0001;

  @override
  Future<PayLaterState> build() async {
    return _loadState();
  }

  Future<void> addInstallmentPlan(InstallmentPlan plan) async {
    await _runMutation((PayLaterRepository repository) async {
      await repository.addInstallmentPlan(_normalizePlan(plan));
    });
  }

  Future<void> updateInstallmentPlan(InstallmentPlan plan) async {
    await _runMutation((PayLaterRepository repository) async {
      await repository.updateInstallmentPlan(_normalizePlan(plan));
    });
  }

  Future<void> deleteInstallmentPlan(String id) async {
    await _runMutation((PayLaterRepository repository) async {
      await repository.deleteInstallmentPlan(id);
    });
  }

  Future<void> addInvoice(PayLaterInvoice invoice) async {
    await _runMutation((PayLaterRepository repository) async {
      await repository.addInvoice(_normalizeInvoice(invoice));
    });
  }

  Future<void> updateInvoice(PayLaterInvoice invoice) async {
    await _runMutation((PayLaterRepository repository) async {
      await repository.updateInvoice(_normalizeInvoice(invoice));
    });
  }

  Future<void> deleteInvoice(String id) async {
    await _runMutation((PayLaterRepository repository) async {
      await repository.deleteInvoice(id);
    });
  }

  Future<void> recordMinimumPayment({
    required PayLaterTargetType targetType,
    required String targetId,
    String? note,
  }) {
    return _recordPayment(
      targetType: targetType,
      targetId: targetId,
      paymentType: PayLaterPaymentType.minimumPayment,
      customAmount: null,
      note: note,
    );
  }

  Future<void> recordCustomPayment({
    required PayLaterTargetType targetType,
    required String targetId,
    required double amount,
    String? note,
  }) {
    return _recordPayment(
      targetType: targetType,
      targetId: targetId,
      paymentType: PayLaterPaymentType.customPayment,
      customAmount: amount,
      note: note,
    );
  }

  Future<void> settleFullAmount({
    required PayLaterTargetType targetType,
    required String targetId,
    String? note,
  }) {
    return _recordPayment(
      targetType: targetType,
      targetId: targetId,
      paymentType: PayLaterPaymentType.fullSettlement,
      customAmount: null,
      note: note,
    );
  }

  Future<void> _recordPayment({
    required PayLaterTargetType targetType,
    required String targetId,
    required PayLaterPaymentType paymentType,
    required double? customAmount,
    String? note,
  }) async {
    await _runMutation((PayLaterRepository repository) async {
      final List<Object> records = await Future.wait<Object>(<Future<Object>>[
        repository.getInstallmentPlans(),
        repository.getInvoices(),
      ]);

      final List<InstallmentPlan> plans = records[0] as List<InstallmentPlan>;
      final List<PayLaterInvoice> invoices =
          records[1] as List<PayLaterInvoice>;
      final DateTime now = DateTime.now();

      if (targetType == PayLaterTargetType.installmentPlan) {
        final InstallmentPlan plan = plans.firstWhere(
          (InstallmentPlan item) => item.id == targetId,
        );
        final double amount = _resolvePaymentAmountForPlan(
          plan,
          paymentType,
          customAmount,
        );
        final InstallmentPlan updatedPlan = _applyPaymentToPlan(
          plan,
          amount,
          now,
        );
        await repository.recordPayment(
          PayLaterPayment(
            id: _buildId('pay_later_payment'),
            targetId: targetId,
            targetType: targetType,
            amount: amount,
            paymentType: paymentType,
            paidAt: now,
            note: note,
            createdAt: now,
          ),
          updatedPlan: updatedPlan,
        );
      } else {
        final PayLaterInvoice invoice = invoices.firstWhere(
          (PayLaterInvoice item) => item.id == targetId,
        );
        final double amount = _resolvePaymentAmountForInvoice(
          invoice,
          paymentType,
          customAmount,
        );
        final PayLaterInvoice updatedInvoice = _applyPaymentToInvoice(
          invoice,
          amount,
          now,
        );
        await repository.recordPayment(
          PayLaterPayment(
            id: _buildId('pay_later_payment'),
            targetId: targetId,
            targetType: targetType,
            amount: amount,
            paymentType: paymentType,
            paidAt: now,
            note: note,
            createdAt: now,
          ),
          updatedInvoice: updatedInvoice,
        );
      }
    });
  }

  Future<void> _runMutation(
    Future<void> Function(PayLaterRepository repository) mutation,
  ) async {
    state = const AsyncLoading<PayLaterState>();
    final PayLaterRepository repository = ref.read(payLaterRepositoryProvider);

    try {
      await mutation(repository);
      state = AsyncData<PayLaterState>(await _loadState());
    } catch (error, stackTrace) {
      state = AsyncError<PayLaterState>(error, stackTrace);
      rethrow;
    }
  }

  Future<PayLaterState> _loadState() async {
    final PayLaterRepository repository = ref.read(payLaterRepositoryProvider);
    final List<Object> records = await Future.wait<Object>(<Future<Object>>[
      repository.getInstallmentPlans(),
      repository.getInvoices(),
      repository.getPayments(),
    ]);

    final List<InstallmentPlan> plans = records[0] as List<InstallmentPlan>;
    final List<PayLaterInvoice> invoices = records[1] as List<PayLaterInvoice>;
    final List<PayLaterPayment> payments = records[2] as List<PayLaterPayment>;

    return PayLaterState(
      plans: List<InstallmentPlan>.unmodifiable(plans),
      invoices: List<PayLaterInvoice>.unmodifiable(invoices),
      payments: List<PayLaterPayment>.unmodifiable(payments),
      summary: const PayLaterSummaryBuilder().build(
        plans: plans,
        invoices: invoices,
        payments: payments,
        now: DateTime.now(),
      ),
    );
  }

  InstallmentPlan _normalizePlan(InstallmentPlan plan) {
    final double safeOriginalAmount = math.max(0, plan.originalAmount);
    final double safeMonthlyPayment = math.max(0, plan.monthlyPaymentAmount);
    final double safeMinimumPayment = math.max(0, plan.minimumPaymentAmount);
    final int safeTotalInstallments = math.max(0, plan.totalInstallments);
    double safePaidAmount = plan.paidAmount.clamp(0, safeOriginalAmount);
    int safePaidInstallments = math.max(0, plan.paidInstallments);

    if (safeMonthlyPayment > 0 && safeTotalInstallments > 0) {
      final int derivedPaidInstallments = math.min(
        safeTotalInstallments,
        (safePaidAmount / safeMonthlyPayment).floor(),
      );
      safePaidInstallments = math.max(
        math.min(safePaidInstallments, safeTotalInstallments),
        derivedPaidInstallments,
      );
    } else if (safeTotalInstallments > 0) {
      safePaidInstallments = math.min(
        safePaidInstallments,
        safeTotalInstallments,
      );
    } else {
      safePaidInstallments = 0;
    }

    if (safeOriginalAmount <= _epsilon ||
        safePaidAmount >= safeOriginalAmount - _epsilon) {
      safePaidAmount = safeOriginalAmount;
      if (safeTotalInstallments > 0) {
        safePaidInstallments = safeTotalInstallments;
      }
    }

    final InstallmentStatus normalizedStatus =
        plan.status == InstallmentStatus.cancelled
        ? InstallmentStatus.cancelled
        : (safePaidAmount >= safeOriginalAmount - _epsilon
              ? InstallmentStatus.settled
              : InstallmentStatus.active);

    return plan.copyWith(
      originalAmount: safeOriginalAmount,
      monthlyPaymentAmount: safeMonthlyPayment,
      minimumPaymentAmount: safeMinimumPayment,
      paidAmount: safePaidAmount,
      totalInstallments: safeTotalInstallments,
      paidInstallments: safePaidInstallments,
      dueDayOfMonth: plan.dueDayOfMonth.clamp(1, 31),
      status: normalizedStatus,
    );
  }

  PayLaterInvoice _normalizeInvoice(PayLaterInvoice invoice) {
    final double safeTotalAmount = math.max(0, invoice.totalAmount);
    final double safeMinimumPayment = math.max(0, invoice.minimumPaymentAmount);
    final double safePaidAmount = invoice.paidAmount.clamp(0, safeTotalAmount);

    final PayLaterInvoiceStatus normalizedStatus =
        safePaidAmount >= safeTotalAmount - _epsilon
        ? PayLaterInvoiceStatus.paid
        : safePaidAmount > 0
        ? PayLaterInvoiceStatus.partiallyPaid
        : PayLaterInvoiceStatus.unpaid;

    return invoice.copyWith(
      totalAmount: safeTotalAmount,
      minimumPaymentAmount: safeMinimumPayment,
      paidAmount: safePaidAmount,
      status: normalizedStatus,
    );
  }

  double _resolvePaymentAmountForPlan(
    InstallmentPlan plan,
    PayLaterPaymentType paymentType,
    double? customAmount,
  ) {
    return switch (paymentType) {
      PayLaterPaymentType.minimumPayment => _validatedPaymentAmount(
        plan.minimumAmountDue,
        plan.outstandingAmount,
      ),
      PayLaterPaymentType.customPayment => _validatedPaymentAmount(
        customAmount ?? 0,
        plan.outstandingAmount,
      ),
      PayLaterPaymentType.fullSettlement => plan.outstandingAmount,
    };
  }

  double _resolvePaymentAmountForInvoice(
    PayLaterInvoice invoice,
    PayLaterPaymentType paymentType,
    double? customAmount,
  ) {
    return switch (paymentType) {
      PayLaterPaymentType.minimumPayment => _validatedPaymentAmount(
        invoice.minimumAmountDue,
        invoice.outstandingAmount,
      ),
      PayLaterPaymentType.customPayment => _validatedPaymentAmount(
        customAmount ?? 0,
        invoice.outstandingAmount,
      ),
      PayLaterPaymentType.fullSettlement => invoice.outstandingAmount,
    };
  }

  double _validatedPaymentAmount(double amount, double outstandingAmount) {
    if (outstandingAmount <= _epsilon) {
      throw ArgumentError('Outstanding amount is already zero.');
    }

    if (amount <= _epsilon) {
      throw ArgumentError('Payment amount must be greater than zero.');
    }

    if (amount > outstandingAmount + _epsilon) {
      throw ArgumentError('Payment amount cannot exceed outstanding amount.');
    }

    return amount;
  }

  InstallmentPlan _applyPaymentToPlan(
    InstallmentPlan plan,
    double amount,
    DateTime now,
  ) {
    final double nextPaidAmount = math.min(
      plan.originalAmount,
      plan.paidAmount + amount,
    );

    int nextPaidInstallments = plan.paidInstallments;
    if (plan.monthlyPaymentAmount > 0) {
      nextPaidInstallments = math.max(
        nextPaidInstallments,
        math.min(
          plan.totalInstallments,
          (nextPaidAmount / plan.monthlyPaymentAmount).floor(),
        ),
      );
    }

    if (nextPaidAmount >= plan.originalAmount - _epsilon) {
      nextPaidInstallments = plan.totalInstallments;
    }

    return _normalizePlan(
      plan.copyWith(
        paidAmount: nextPaidAmount,
        paidInstallments: nextPaidInstallments,
        status: nextPaidAmount >= plan.originalAmount - _epsilon
            ? InstallmentStatus.settled
            : InstallmentStatus.active,
        updatedAt: now,
      ),
    );
  }

  PayLaterInvoice _applyPaymentToInvoice(
    PayLaterInvoice invoice,
    double amount,
    DateTime now,
  ) {
    final double nextPaidAmount = math.min(
      invoice.totalAmount,
      invoice.paidAmount + amount,
    );

    return _normalizeInvoice(
      invoice.copyWith(
        paidAmount: nextPaidAmount,
        status: nextPaidAmount >= invoice.totalAmount - _epsilon
            ? PayLaterInvoiceStatus.paid
            : PayLaterInvoiceStatus.partiallyPaid,
        updatedAt: now,
      ),
    );
  }

  String _buildId(String prefix) {
    return '${prefix}_${DateTime.now().microsecondsSinceEpoch}';
  }
}

class PayLaterState {
  const PayLaterState({
    required this.plans,
    required this.invoices,
    required this.payments,
    required this.summary,
  });

  final List<InstallmentPlan> plans;
  final List<PayLaterInvoice> invoices;
  final List<PayLaterPayment> payments;
  final PayLaterSummary summary;

  bool get isEmpty => plans.isEmpty && invoices.isEmpty;

  InstallmentPlan? planById(String id) {
    for (final InstallmentPlan plan in plans) {
      if (plan.id == id) {
        return plan;
      }
    }

    return null;
  }

  PayLaterInvoice? invoiceById(String id) {
    for (final PayLaterInvoice invoice in invoices) {
      if (invoice.id == id) {
        return invoice;
      }
    }

    return null;
  }
}
