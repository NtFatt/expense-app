import 'dart:math' as math;

import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/policy_note.dart';
import 'package:expense_app/features/pay_later/presentation/controllers/pay_later_controller.dart';
import 'package:expense_app/features/pay_later/presentation/widgets/installment_plan_form_dialog.dart';
import 'package:expense_app/features/pay_later/presentation/widgets/pay_later_status_badge.dart';
import 'package:expense_app/features/pay_later/presentation/widgets/pay_later_summary_metric_card.dart';
import 'package:expense_app/features/pay_later/presentation/widgets/pay_later_invoice_form_dialog.dart';
import 'package:expense_app/features/pay_later/presentation/widgets/payment_action_dialog.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:expense_app/shared/widgets/empty_state.dart';
import 'package:expense_app/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PayLaterPage extends ConsumerWidget {
  const PayLaterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PayLaterState> state = ref.watch(
      payLaterControllerProvider,
    );

    return AppScaffold(
      title: context.strings.t(AppStringKey.payLaterTitle),
      actions: <Widget>[
        IconButton(
          tooltip: context.strings.t(AppStringKey.navDashboard),
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.home_outlined),
        ),
      ],
      child: state.when(
        loading: () => const SizedBox(
          height: 320,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (Object error, StackTrace stackTrace) {
          return SizedBox(
            height: 320,
            child: Center(
              child: Text(
                '${context.strings.t(AppStringKey.couldNotLoadPayLater)}\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        data: (PayLaterState data) => _PayLaterContent(state: data),
      ),
    );
  }
}

class _PayLaterContent extends ConsumerWidget {
  const _PayLaterContent({required this.state});

  final PayLaterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final DateTime now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.strings.t(AppStringKey.payLaterSubtitle),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            FilledButton.icon(
              key: const Key('add_installment_plan_button'),
              onPressed: () => _openInstallmentPlanDialog(context, ref),
              icon: const Icon(Icons.add_card_rounded),
              label: Text(context.strings.t(AppStringKey.addInstallmentPlan)),
            ),
            OutlinedButton.icon(
              key: const Key('add_pay_later_invoice_button'),
              onPressed: () => _openInvoiceDialog(context, ref),
              icon: const Icon(Icons.receipt_long_rounded),
              label: Text(context.strings.t(AppStringKey.addPayLaterInvoice)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth >= 720
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                SizedBox(
                  width: width,
                  child: PayLaterSummaryMetricCard(
                    key: const Key('pay_later_total_outstanding_card'),
                    title: context.strings.t(AppStringKey.totalOutstanding),
                    value: formatCurrency(
                      state.summary.totalOutstanding,
                      withSign: false,
                    ),
                    icon: Icons.account_balance_wallet_outlined,
                    baseColor: const Color(0xFF2563EB),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: PayLaterSummaryMetricCard(
                    title: context.strings.t(AppStringKey.minimumDue),
                    value: formatCurrency(
                      state.summary.totalMinimumDue,
                      withSign: false,
                    ),
                    icon: Icons.payments_outlined,
                    baseColor: const Color(0xFFD97706),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: PayLaterSummaryMetricCard(
                    title: context.strings.t(AppStringKey.dueSoon),
                    value: state.summary.dueSoonCount.toString(),
                    icon: Icons.schedule_rounded,
                    baseColor: const Color(0xFFD97706),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: PayLaterSummaryMetricCard(
                    title: context.strings.t(AppStringKey.overdue),
                    value: state.summary.overdueCount.toString(),
                    icon: Icons.warning_amber_rounded,
                    baseColor: const Color(0xFFDC2626),
                    supportingText:
                        '${context.strings.t(AppStringKey.totalPaidThisMonth)}: ${formatCurrency(state.summary.totalPaidThisMonth, withSign: false)}',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _UpcomingDueCard(state: state),
        const SizedBox(height: 24),
        if (state.isEmpty) ...<Widget>[
          EmptyState(
            key: const Key('pay_later_empty_state'),
            title: context.strings.t(AppStringKey.noPayLaterItems),
            message: context.strings.t(AppStringKey.noPayLaterItemsMessage),
            icon: Icons.credit_score_rounded,
          ),
          const SizedBox(height: 24),
        ],
        SectionHeader(
          title: context.strings.t(AppStringKey.installmentPlans),
          actionLabel: context.strings.t(AppStringKey.addInstallmentPlan),
          onActionPressed: () => _openInstallmentPlanDialog(context, ref),
        ),
        const SizedBox(height: 10),
        if (state.plans.isEmpty)
          EmptyState(
            title: context.strings.t(AppStringKey.noInstallmentPlans),
            message: context.strings.t(AppStringKey.noInstallmentPlansMessage),
            icon: Icons.view_agenda_outlined,
            actionLabel: context.strings.t(AppStringKey.addInstallmentPlan),
            onActionPressed: () => _openInstallmentPlanDialog(context, ref),
          )
        else
          for (final InstallmentPlan plan in state.plans)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InstallmentPlanCard(
                plan: plan,
                now: now,
                onPayPressed: () => _recordPaymentForPlan(context, ref, plan),
                onEditPressed: () => _openInstallmentPlanDialog(
                  context,
                  ref,
                  initialValue: plan,
                ),
                onDeletePressed: () =>
                    _deleteInstallmentPlan(context, ref, plan),
              ),
            ),
        const SizedBox(height: 24),
        SectionHeader(
          title: context.strings.t(AppStringKey.payLaterInvoices),
          actionLabel: context.strings.t(AppStringKey.addPayLaterInvoice),
          onActionPressed: () => _openInvoiceDialog(context, ref),
        ),
        const SizedBox(height: 10),
        if (state.invoices.isEmpty)
          EmptyState(
            title: context.strings.t(AppStringKey.noPayLaterInvoices),
            message: context.strings.t(AppStringKey.noPayLaterInvoicesMessage),
            icon: Icons.description_outlined,
            actionLabel: context.strings.t(AppStringKey.addPayLaterInvoice),
            onActionPressed: () => _openInvoiceDialog(context, ref),
          )
        else
          for (final PayLaterInvoice invoice in state.invoices)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PayLaterInvoiceCard(
                invoice: invoice,
                now: now,
                onPayPressed: () =>
                    _recordPaymentForInvoice(context, ref, invoice),
                onEditPressed: () =>
                    _openInvoiceDialog(context, ref, initialValue: invoice),
                onDeletePressed: () => _deleteInvoice(context, ref, invoice),
              ),
            ),
        const SizedBox(height: 24),
        SectionHeader(title: context.strings.t(AppStringKey.policyNotes)),
        const SizedBox(height: 10),
        _PolicyNotesCard(notes: _buildPolicyNotes(context)),
      ],
    );
  }

  Future<void> _openInstallmentPlanDialog(
    BuildContext context,
    WidgetRef ref, {
    InstallmentPlan? initialValue,
  }) async {
    final InstallmentPlanFormResult? result =
        await showInstallmentPlanFormDialog(
          context: context,
          initialValue: initialValue,
        );
    if (result == null) {
      return;
    }

    final DateTime now = DateTime.now();
    final double paidAmount = math.min(
      result.originalAmount,
      result.monthlyPaymentAmount * result.paidInstallments,
    );

    final InstallmentPlan plan = (initialValue ?? _newInstallmentPlan(now))
        .copyWith(
          title: result.title,
          providerName: result.providerName,
          originalAmount: result.originalAmount,
          monthlyPaymentAmount: result.monthlyPaymentAmount,
          minimumPaymentAmount: result.minimumPaymentAmount,
          paidAmount: paidAmount,
          totalInstallments: result.totalInstallments,
          paidInstallments: result.paidInstallments,
          startDate: result.startDate,
          dueDayOfMonth: result.dueDayOfMonth,
          note: result.note,
          status: paidAmount >= result.originalAmount
              ? InstallmentStatus.settled
              : InstallmentStatus.active,
          updatedAt: now,
        );

    try {
      final PayLaterController controller = ref.read(
        payLaterControllerProvider.notifier,
      );
      if (initialValue == null) {
        await controller.addInstallmentPlan(plan);
      } else {
        await controller.updateInstallmentPlan(plan);
      }

      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.t(AppStringKey.changesSaved))),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.strings.t(AppStringKey.couldNotSaveInstallmentPlan)} $error',
          ),
        ),
      );
    }
  }

  Future<void> _openInvoiceDialog(
    BuildContext context,
    WidgetRef ref, {
    PayLaterInvoice? initialValue,
  }) async {
    final PayLaterInvoiceFormResult? result =
        await showPayLaterInvoiceFormDialog(
          context: context,
          initialValue: initialValue,
        );
    if (result == null) {
      return;
    }

    final DateTime now = DateTime.now();
    final PayLaterInvoice invoice = (initialValue ?? _newInvoice(now)).copyWith(
      providerName: result.providerName,
      statementMonth: result.statementMonth,
      statementDate: result.statementDate,
      dueDate: result.dueDate,
      totalAmount: result.totalAmount,
      minimumPaymentAmount: result.minimumPaymentAmount,
      note: result.note,
      updatedAt: now,
    );

    try {
      final PayLaterController controller = ref.read(
        payLaterControllerProvider.notifier,
      );
      if (initialValue == null) {
        await controller.addInvoice(invoice);
      } else {
        await controller.updateInvoice(invoice);
      }

      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.t(AppStringKey.changesSaved))),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.strings.t(AppStringKey.couldNotSaveInvoice)} $error',
          ),
        ),
      );
    }
  }

  Future<void> _recordPaymentForPlan(
    BuildContext context,
    WidgetRef ref,
    InstallmentPlan plan,
  ) async {
    final PaymentActionResult? result = await showPaymentActionDialog(
      context: context,
      title: plan.title,
      outstandingAmount: plan.outstandingAmount,
      minimumAmount: plan.minimumAmountDue,
    );
    if (result == null) {
      return;
    }

    try {
      final PayLaterController controller = ref.read(
        payLaterControllerProvider.notifier,
      );
      await _submitPaymentAction(
        controller: controller,
        result: result,
        targetType: PayLaterTargetType.installmentPlan,
        targetId: plan.id,
      );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.strings.t(AppStringKey.paymentRecorded)),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.strings.t(AppStringKey.couldNotRecordPayment)} $error',
          ),
        ),
      );
    }
  }

  Future<void> _recordPaymentForInvoice(
    BuildContext context,
    WidgetRef ref,
    PayLaterInvoice invoice,
  ) async {
    final PaymentActionResult? result = await showPaymentActionDialog(
      context: context,
      title: invoice.providerName,
      outstandingAmount: invoice.outstandingAmount,
      minimumAmount: invoice.minimumAmountDue,
    );
    if (result == null) {
      return;
    }

    try {
      final PayLaterController controller = ref.read(
        payLaterControllerProvider.notifier,
      );
      await _submitPaymentAction(
        controller: controller,
        result: result,
        targetType: PayLaterTargetType.invoice,
        targetId: invoice.id,
      );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.strings.t(AppStringKey.paymentRecorded)),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.strings.t(AppStringKey.couldNotRecordPayment)} $error',
          ),
        ),
      );
    }
  }

  Future<void> _submitPaymentAction({
    required PayLaterController controller,
    required PaymentActionResult result,
    required PayLaterTargetType targetType,
    required String targetId,
  }) {
    return switch (result.type) {
      PayLaterPaymentType.minimumPayment => controller.recordMinimumPayment(
        targetType: targetType,
        targetId: targetId,
      ),
      PayLaterPaymentType.customPayment => controller.recordCustomPayment(
        targetType: targetType,
        targetId: targetId,
        amount: result.amount ?? 0,
      ),
      PayLaterPaymentType.fullSettlement => controller.settleFullAmount(
        targetType: targetType,
        targetId: targetId,
      ),
    };
  }

  Future<void> _deleteInstallmentPlan(
    BuildContext context,
    WidgetRef ref,
    InstallmentPlan plan,
  ) async {
    final bool? confirmed = await _showDeleteDialog(
      context,
      message: context.strings.t(AppStringKey.deleteInstallmentPlanPrompt),
    );
    if (confirmed != true) {
      return;
    }

    try {
      await ref
          .read(payLaterControllerProvider.notifier)
          .deleteInstallmentPlan(plan.id);
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.strings.t(AppStringKey.couldNotDeleteInstallmentPlan)} $error',
          ),
        ),
      );
    }
  }

  Future<void> _deleteInvoice(
    BuildContext context,
    WidgetRef ref,
    PayLaterInvoice invoice,
  ) async {
    final bool? confirmed = await _showDeleteDialog(
      context,
      message: context.strings.t(AppStringKey.deleteInvoicePrompt),
    );
    if (confirmed != true) {
      return;
    }

    try {
      await ref
          .read(payLaterControllerProvider.notifier)
          .deleteInvoice(invoice.id);
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.strings.t(AppStringKey.couldNotDeleteInvoice)} $error',
          ),
        ),
      );
    }
  }

  Future<bool?> _showDeleteDialog(
    BuildContext context, {
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.strings.t(AppStringKey.delete)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.strings.t(AppStringKey.cancel)),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.strings.t(AppStringKey.delete)),
            ),
          ],
        );
      },
    );
  }

  InstallmentPlan _newInstallmentPlan(DateTime now) {
    return InstallmentPlan(
      id: 'installment_plan_${now.microsecondsSinceEpoch}',
      title: '',
      providerName: '',
      originalAmount: 0,
      monthlyPaymentAmount: 0,
      minimumPaymentAmount: 0,
      paidAmount: 0,
      totalInstallments: 1,
      paidInstallments: 0,
      startDate: now,
      dueDayOfMonth: now.day.clamp(1, 31),
      status: InstallmentStatus.active,
      createdAt: now,
      updatedAt: now,
    );
  }

  PayLaterInvoice _newInvoice(DateTime now) {
    return PayLaterInvoice(
      id: 'pay_later_invoice_${now.microsecondsSinceEpoch}',
      providerName: '',
      statementMonth: DateTime(now.year, now.month),
      statementDate: now,
      dueDate: now,
      totalAmount: 0,
      minimumPaymentAmount: 0,
      paidAmount: 0,
      status: PayLaterInvoiceStatus.unpaid,
      createdAt: now,
      updatedAt: now,
    );
  }

  List<PolicyNote> _buildPolicyNotes(BuildContext context) {
    return <PolicyNote>[
      PolicyNote(
        id: 'minimum_payment',
        title: context.strings.t(AppStringKey.policyNoteMinimumTitle),
        description: context.strings.t(
          AppStringKey.policyNoteMinimumDescription,
        ),
        severity: PolicySeverity.warning,
        category: 'payment',
      ),
      PolicyNote(
        id: 'settlement',
        title: context.strings.t(AppStringKey.policyNoteSettlementTitle),
        description: context.strings.t(
          AppStringKey.policyNoteSettlementDescription,
        ),
        severity: PolicySeverity.info,
        category: 'settlement',
      ),
      PolicyNote(
        id: 'statement',
        title: context.strings.t(AppStringKey.policyNoteStatementTitle),
        description: context.strings.t(
          AppStringKey.policyNoteStatementDescription,
        ),
        severity: PolicySeverity.info,
        category: 'statement',
      ),
      PolicyNote(
        id: 'tracking_only',
        title: context.strings.t(AppStringKey.policyNoteTrackingOnlyTitle),
        description: context.strings.t(
          AppStringKey.policyNoteTrackingOnlyDescription,
        ),
        severity: PolicySeverity.warning,
        category: 'scope',
      ),
      PolicyNote(
        id: 'verify_terms',
        title: context.strings.t(AppStringKey.policyNoteVerifyTermsTitle),
        description: context.strings.t(
          AppStringKey.policyNoteVerifyTermsDescription,
        ),
        severity: PolicySeverity.critical,
        category: 'provider_terms',
      ),
    ];
  }
}

class _UpcomingDueCard extends StatelessWidget {
  const _UpcomingDueCard({required this.state});

  final PayLaterState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.strings.t(AppStringKey.nextDue),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (!state.summary.hasUpcomingDue)
            Text(
              context.strings.t(AppStringKey.noUpcomingDue),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else
            Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.event_note_rounded,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        formatCurrency(
                          state.summary.nextDueAmount,
                          withSign: false,
                        ),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${context.strings.t(AppStringKey.nextDueDate)}: ${context.strings.shortDate(state.summary.nextDueDate!)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InstallmentPlanCard extends StatelessWidget {
  const _InstallmentPlanCard({
    required this.plan,
    required this.now,
    required this.onPayPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final InstallmentPlan plan;
  final DateTime now;
  final VoidCallback onPayPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final InstallmentStatus status = plan.effectiveStatus(now);
    final bool canRecordPayment =
        status != InstallmentStatus.settled &&
        status != InstallmentStatus.cancelled;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      plan.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.providerName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              PayLaterStatusBadge.forInstallment(
                context: context,
                plan: plan,
                now: now,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(
            label: context.strings.t(AppStringKey.originalAmount),
            value: formatCurrency(plan.originalAmount, withSign: false),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.monthlyPayment),
            value: formatCurrency(plan.monthlyPaymentAmount, withSign: false),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.minimumPayment),
            value: formatCurrency(plan.minimumAmountDue, withSign: false),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.outstanding),
            value: formatCurrency(plan.outstandingAmount, withSign: false),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.nextDueDate),
            value: context.strings.shortDate(plan.nextDueDate),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.remainingInstallments),
            value: plan.remainingInstallments.toString(),
          ),
          const SizedBox(height: 14),
          Text(
            '${context.strings.t(AppStringKey.installmentProgress)} • ${plan.paidInstallments}/${plan.totalInstallments}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: plan.progressPercent,
              minHeight: 10,
            ),
          ),
          if (plan.note != null && plan.note!.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            Text(
              plan.note!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (canRecordPayment)
                OutlinedButton.icon(
                  onPressed: onPayPressed,
                  icon: const Icon(Icons.payments_outlined),
                  label: Text(context.strings.t(AppStringKey.recordPayment)),
                ),
              OutlinedButton.icon(
                onPressed: onEditPressed,
                icon: const Icon(Icons.edit_outlined),
                label: Text(
                  context.strings.t(AppStringKey.editInstallmentPlan),
                ),
              ),
              TextButton.icon(
                onPressed: onDeletePressed,
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(context.strings.t(AppStringKey.delete)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayLaterInvoiceCard extends StatelessWidget {
  const _PayLaterInvoiceCard({
    required this.invoice,
    required this.now,
    required this.onPayPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final PayLaterInvoice invoice;
  final DateTime now;
  final VoidCallback onPayPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool canRecordPayment =
        invoice.effectiveStatus(now) != PayLaterInvoiceStatus.paid;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      invoice.providerName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.strings.monthYear(invoice.statementMonth),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              PayLaterStatusBadge.forInvoice(
                context: context,
                invoice: invoice,
                now: now,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(
            label: context.strings.t(AppStringKey.originalAmount),
            value: formatCurrency(invoice.totalAmount, withSign: false),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.minimumPayment),
            value: formatCurrency(invoice.minimumAmountDue, withSign: false),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.paid),
            value: formatCurrency(invoice.paidAmount, withSign: false),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.outstanding),
            value: formatCurrency(invoice.outstandingAmount, withSign: false),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.statementDate),
            value: context.strings.shortDate(invoice.statementDate),
          ),
          _InfoRow(
            label: context.strings.t(AppStringKey.dueDate),
            value: context.strings.shortDate(invoice.dueDate),
          ),
          if (invoice.note != null &&
              invoice.note!.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            Text(
              invoice.note!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (canRecordPayment)
                OutlinedButton.icon(
                  onPressed: onPayPressed,
                  icon: const Icon(Icons.payments_outlined),
                  label: Text(context.strings.t(AppStringKey.recordPayment)),
                ),
              OutlinedButton.icon(
                onPressed: onEditPressed,
                icon: const Icon(Icons.edit_outlined),
                label: Text(
                  context.strings.t(AppStringKey.editPayLaterInvoice),
                ),
              ),
              TextButton.icon(
                onPressed: onDeletePressed,
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(context.strings.t(AppStringKey.delete)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicyNotesCard extends StatelessWidget {
  const _PolicyNotesCard({required this.notes});

  final List<PolicyNote> notes;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: notes
            .map(
              (PolicyNote note) => Padding(
                padding: EdgeInsets.only(bottom: note == notes.last ? 0 : 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _PolicySeverityIcon(severity: note.severity),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            note.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PolicySeverityIcon extends StatelessWidget {
  const _PolicySeverityIcon({required this.severity});

  final PolicySeverity severity;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (severity) {
      PolicySeverity.info => const Color(0xFF2563EB),
      PolicySeverity.warning => const Color(0xFFD97706),
      PolicySeverity.critical => const Color(0xFFDC2626),
    };

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(switch (severity) {
        PolicySeverity.info => Icons.info_outline_rounded,
        PolicySeverity.warning => Icons.warning_amber_rounded,
        PolicySeverity.critical => Icons.priority_high_rounded,
      }, color: color),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
