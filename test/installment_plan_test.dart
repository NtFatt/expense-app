import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InstallmentPlan', () {
    test('remainingInstallments and progressPercent are calculated safely', () {
      final InstallmentPlan plan = _buildPlan(
        totalInstallments: 12,
        paidInstallments: 3,
        originalAmount: 1200,
        monthlyPaymentAmount: 100,
        paidAmount: 300,
      );

      expect(plan.remainingInstallments, 9);
      expect(plan.progressPercent, closeTo(0.25, 0.0001));
    });

    test('isFullyPaid returns true when outstanding reaches zero', () {
      final InstallmentPlan plan = _buildPlan(
        totalInstallments: 12,
        paidInstallments: 12,
        originalAmount: 1200,
        monthlyPaymentAmount: 100,
        paidAmount: 1200,
      );

      expect(plan.isFullyPaid, isTrue);
      expect(plan.outstandingAmount, 0);
    });

    test('isOverdue returns true when next due date is in the past', () {
      final InstallmentPlan plan = _buildPlan(
        startDate: DateTime(2026, 5, 1),
        dueDayOfMonth: 10,
      );

      expect(plan.isOverdue(DateTime(2026, 5, 12)), isTrue);
      expect(
        plan.effectiveStatus(DateTime(2026, 5, 12)),
        InstallmentStatus.overdue,
      );
    });

    test('isDueSoon returns true when due date is within three days', () {
      final InstallmentPlan plan = _buildPlan(
        startDate: DateTime(2026, 5, 1),
        dueDayOfMonth: 10,
      );

      expect(plan.isDueSoon(DateTime(2026, 5, 8)), isTrue);
      expect(
        plan.effectiveStatus(DateTime(2026, 5, 8)),
        InstallmentStatus.dueSoon,
      );
    });

    test('progressPercent does not divide by zero', () {
      final InstallmentPlan plan = _buildPlan(
        totalInstallments: 0,
        paidInstallments: 0,
        originalAmount: 0,
        monthlyPaymentAmount: 0,
        paidAmount: 0,
      );

      expect(plan.progressPercent, 1);
      expect(plan.remainingInstallments, 0);
    });
  });
}

InstallmentPlan _buildPlan({
  DateTime? startDate,
  int dueDayOfMonth = 15,
  int totalInstallments = 6,
  int paidInstallments = 0,
  double originalAmount = 600,
  double monthlyPaymentAmount = 100,
  double paidAmount = 0,
}) {
  final DateTime now = DateTime(2026, 5, 6);
  return InstallmentPlan(
    id: 'plan_1',
    title: 'Laptop installment',
    providerName: 'Provider A',
    originalAmount: originalAmount,
    monthlyPaymentAmount: monthlyPaymentAmount,
    minimumPaymentAmount: 80,
    paidAmount: paidAmount,
    totalInstallments: totalInstallments,
    paidInstallments: paidInstallments,
    startDate: startDate ?? DateTime(2026, 5, 1),
    dueDayOfMonth: dueDayOfMonth,
    status: InstallmentStatus.active,
    createdAt: now,
    updatedAt: now,
  );
}
