import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/pay_later/presentation/controllers/pay_later_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PayLaterDashboardEntryCard extends ConsumerWidget {
  const PayLaterDashboardEntryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AsyncValue<PayLaterState> state = ref.watch(
      payLaterControllerProvider,
    );

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
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.credit_score_rounded,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.strings.t(AppStringKey.payLaterTracker),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.strings.t(AppStringKey.payLaterTrackerSubtitle),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          state.when(
            loading: () => const LinearProgressIndicator(minHeight: 6),
            error: (Object error, StackTrace stackTrace) => Text(
              context.strings.t(AppStringKey.couldNotLoadPayLater),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            data: (PayLaterState data) {
              if (data.isEmpty) {
                return Text(
                  context.strings.t(AppStringKey.noPayLaterItemsMessage),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                );
              }

              return Wrap(
                spacing: 16,
                runSpacing: 10,
                children: <Widget>[
                  _MetricPill(
                    label: context.strings.t(AppStringKey.totalOutstanding),
                    value: formatCurrency(
                      data.summary.totalOutstanding,
                      withSign: false,
                    ),
                  ),
                  _MetricPill(
                    label: context.strings.t(AppStringKey.minimumDue),
                    value: formatCurrency(
                      data.summary.totalMinimumDue,
                      withSign: false,
                    ),
                  ),
                  _MetricPill(
                    label: context.strings.t(AppStringKey.overdue),
                    value: data.summary.overdueCount.toString(),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            key: const Key('open_pay_later_tracker_button'),
            onPressed: () => context.push('/pay-later'),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(context.strings.t(AppStringKey.openPayLaterTracker)),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
