import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:flutter/material.dart';

class PayLaterStatusBadge extends StatelessWidget {
  const PayLaterStatusBadge({
    super.key,
    required this.label,
    required this.baseColor,
  });

  factory PayLaterStatusBadge.forInstallment({
    Key? key,
    required BuildContext context,
    required InstallmentPlan plan,
    required DateTime now,
  }) {
    final InstallmentStatus status = plan.effectiveStatus(now);
    return PayLaterStatusBadge(
      key: key,
      label: switch (status) {
        InstallmentStatus.active => context.strings.t(
          AppStringKey.statusActive,
        ),
        InstallmentStatus.dueSoon => context.strings.t(AppStringKey.dueSoon),
        InstallmentStatus.overdue => context.strings.t(AppStringKey.overdue),
        InstallmentStatus.settled => context.strings.t(
          AppStringKey.statusSettled,
        ),
        InstallmentStatus.cancelled => context.strings.t(
          AppStringKey.statusCancelled,
        ),
      },
      baseColor: switch (status) {
        InstallmentStatus.active => const Color(0xFF2563EB),
        InstallmentStatus.dueSoon => const Color(0xFFD97706),
        InstallmentStatus.overdue => const Color(0xFFDC2626),
        InstallmentStatus.settled => const Color(0xFF16A34A),
        InstallmentStatus.cancelled => const Color(0xFF64748B),
      },
    );
  }

  factory PayLaterStatusBadge.forInvoice({
    Key? key,
    required BuildContext context,
    required PayLaterInvoice invoice,
    required DateTime now,
  }) {
    final PayLaterInvoiceStatus status = invoice.effectiveStatus(now);
    return PayLaterStatusBadge(
      key: key,
      label: switch (status) {
        PayLaterInvoiceStatus.unpaid => context.strings.t(
          AppStringKey.statusUnpaid,
        ),
        PayLaterInvoiceStatus.partiallyPaid => context.strings.t(
          AppStringKey.statusPartiallyPaid,
        ),
        PayLaterInvoiceStatus.paid => context.strings.t(
          AppStringKey.statusPaid,
        ),
        PayLaterInvoiceStatus.overdue => context.strings.t(
          AppStringKey.overdue,
        ),
      },
      baseColor: switch (status) {
        PayLaterInvoiceStatus.unpaid => const Color(0xFF64748B),
        PayLaterInvoiceStatus.partiallyPaid => const Color(0xFFD97706),
        PayLaterInvoiceStatus.paid => const Color(0xFF16A34A),
        PayLaterInvoiceStatus.overdue => const Color(0xFFDC2626),
      },
    );
  }

  final String label;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: isDark ? 0.24 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: baseColor.withValues(alpha: isDark ? 0.45 : 0.24),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: baseColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
