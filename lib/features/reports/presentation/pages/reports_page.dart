import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/backup/data/app_backup_service_provider.dart';
import 'package:expense_app/features/backup/domain/backup_import_preview_result.dart';
import 'package:expense_app/features/backup/domain/backup_restore_mode.dart';
import 'package:expense_app/features/backup/presentation/backup_operation_feedback.dart';
import 'package:expense_app/features/pay_later/data/pay_later_export_service_provider.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_export_request.dart';
import 'package:expense_app/features/pay_later/presentation/controllers/pay_later_controller.dart';
import 'package:expense_app/features/reports/data/report_export_service_provider.dart';
import 'package:expense_app/features/reports/domain/report_export_request.dart';
import 'package:expense_app/features/reports/presentation/report_export_feedback.dart';
import 'package:expense_app/features/reports/presentation/widgets/report_action_card.dart';
import 'package:expense_app/features/settings/presentation/controllers/app_preferences_controller.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_filter_controller.dart';
import 'package:expense_app/shared/widgets/app_bottom_navigation.dart';
import 'package:expense_app/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  bool _isExportingCsv = false;
  bool _isExportingPdf = false;
  bool _isExportingPayLaterCsv = false;
  bool _isExportingPayLaterPdf = false;
  bool _isExportingBackup = false;
  bool _isImportingBackup = false;

  void _showSnackBar(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onExportCsv() async {
    if (_isExportingCsv) return;

    final AsyncValue<TransactionState> state = ref.read(
      transactionControllerProvider,
    );
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final AppStrings strings = context.strings;

    await state.when(
      data: (TransactionState data) async {
        if (data.isEmpty) {
          _showSnackBar(
            messenger,
            strings.t(AppStringKey.noTransactionsToExport),
          );
          return;
        }

        setState(() => _isExportingCsv = true);
        try {
          final DateTime selectedMonth = ref
              .read(transactionFilterControllerProvider)
              .selectedMonth;

          final ReportExportRequest request = ReportExportRequest(
            transactions: data.transactions,
            selectedMonth: selectedMonth,
            generatedAt: DateTime.now(),
          );

          final service = ref.read(reportExportServiceProvider);
          final result = await service.exportTransactionsCsv(request);
          if (!mounted) {
            return;
          }

          _showSnackBar(messenger, buildReportExportFeedback(strings, result));
        } catch (e) {
          if (!mounted) {
            return;
          }

          _showSnackBar(messenger, strings.t(AppStringKey.couldNotExportCsv));
        } finally {
          if (mounted) {
            setState(() => _isExportingCsv = false);
          }
        }
      },
      loading: () {
        _showSnackBar(
          messenger,
          strings.t(AppStringKey.transactionsLoadingTryAgain),
        );
      },
      error: (Object error, StackTrace stack) {
        _showSnackBar(
          messenger,
          strings.t(AppStringKey.couldNotReadTransactions),
        );
      },
    );
  }

  Future<void> _onExportPdf() async {
    if (_isExportingPdf) return;

    final AsyncValue<TransactionState> state = ref.read(
      transactionControllerProvider,
    );
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final AppStrings strings = context.strings;

    await state.when(
      data: (TransactionState data) async {
        setState(() => _isExportingPdf = true);
        try {
          final DateTime selectedMonth = ref
              .read(transactionFilterControllerProvider)
              .selectedMonth;

          final ReportExportRequest request = ReportExportRequest(
            transactions: data.transactions,
            selectedMonth: selectedMonth,
            generatedAt: DateTime.now(),
          );

          final service = ref.read(reportExportServiceProvider);
          final result = await service.exportMonthlyPdf(request);
          if (!mounted) {
            return;
          }

          _showSnackBar(messenger, buildReportExportFeedback(strings, result));
        } catch (e) {
          if (!mounted) {
            return;
          }

          _showSnackBar(messenger, strings.t(AppStringKey.couldNotExportPdf));
        } finally {
          if (mounted) {
            setState(() => _isExportingPdf = false);
          }
        }
      },
      loading: () {
        _showSnackBar(
          messenger,
          strings.t(AppStringKey.transactionsLoadingTryAgain),
        );
      },
      error: (Object error, StackTrace stack) {
        _showSnackBar(
          messenger,
          strings.t(AppStringKey.couldNotReadTransactions),
        );
      },
    );
  }

  Future<void> _onExportPayLaterCsv() async {
    if (_isExportingPayLaterCsv) {
      return;
    }

    final AsyncValue<PayLaterState> state = ref.read(
      payLaterControllerProvider,
    );
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final AppStrings strings = context.strings;

    await state.when(
      data: (PayLaterState data) async {
        setState(() => _isExportingPayLaterCsv = true);
        try {
          final PayLaterExportRequest request = PayLaterExportRequest(
            plans: data.plans,
            invoices: data.invoices,
            payments: data.payments,
            generatedAt: DateTime.now(),
          );

          final service = ref.read(payLaterExportServiceProvider);
          final result = await service.exportPayLaterCsv(request);
          if (!mounted) {
            return;
          }

          _showSnackBar(messenger, buildReportExportFeedback(strings, result));
        } catch (e) {
          if (!mounted) {
            return;
          }

          _showSnackBar(messenger, strings.t(AppStringKey.couldNotExportCsv));
        } finally {
          if (mounted) {
            setState(() => _isExportingPayLaterCsv = false);
          }
        }
      },
      loading: () {
        _showSnackBar(messenger, strings.t(AppStringKey.couldNotLoadPayLater));
      },
      error: (Object error, StackTrace stackTrace) {
        _showSnackBar(messenger, strings.t(AppStringKey.couldNotLoadPayLater));
      },
    );
  }

  Future<void> _onExportPayLaterPdf() async {
    if (_isExportingPayLaterPdf) {
      return;
    }

    final AsyncValue<PayLaterState> state = ref.read(
      payLaterControllerProvider,
    );
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final AppStrings strings = context.strings;

    await state.when(
      data: (PayLaterState data) async {
        setState(() => _isExportingPayLaterPdf = true);
        try {
          final PayLaterExportRequest request = PayLaterExportRequest(
            plans: data.plans,
            invoices: data.invoices,
            payments: data.payments,
            generatedAt: DateTime.now(),
          );

          final service = ref.read(payLaterExportServiceProvider);
          final result = await service.exportPayLaterPdf(request);
          if (!mounted) {
            return;
          }

          _showSnackBar(messenger, buildReportExportFeedback(strings, result));
        } catch (e) {
          if (!mounted) {
            return;
          }

          _showSnackBar(messenger, strings.t(AppStringKey.couldNotExportPdf));
        } finally {
          if (mounted) {
            setState(() => _isExportingPayLaterPdf = false);
          }
        }
      },
      loading: () {
        _showSnackBar(messenger, strings.t(AppStringKey.couldNotLoadPayLater));
      },
      error: (Object error, StackTrace stackTrace) {
        _showSnackBar(messenger, strings.t(AppStringKey.couldNotLoadPayLater));
      },
    );
  }

  Future<void> _onExportBackup() async {
    if (_isExportingBackup) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final AppStrings strings = context.strings;

    setState(() => _isExportingBackup = true);
    try {
      final service = ref.read(appBackupServiceProvider);
      final result = await service.exportBackup(includePreferences: true);
      if (!mounted) {
        return;
      }

      _showSnackBar(messenger, buildBackupOperationFeedback(strings, result));
    } finally {
      if (mounted) {
        setState(() => _isExportingBackup = false);
      }
    }
  }

  Future<void> _onImportBackup() async {
    if (_isImportingBackup) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final AppStrings strings = context.strings;

    setState(() => _isImportingBackup = true);
    try {
      final service = ref.read(appBackupServiceProvider);
      final BackupImportPreviewResult preview = await service
          .prepareRestoreFromPickedFile();
      if (!mounted) {
        return;
      }

      if (!preview.isReady || preview.backup == null) {
        _showSnackBar(
          messenger,
          buildBackupImportPreviewFeedback(strings, preview),
        );
        return;
      }

      final bool? confirmed = await _showRestoreConfirmationDialog(preview);
      if (!mounted) {
        return;
      }
      if (confirmed != true) {
        _showSnackBar(messenger, strings.t(AppStringKey.backupImportCancelled));
        return;
      }

      final result = await service.restoreBackup(
        preview.backup!,
        mode: BackupRestoreMode.replaceAll,
        restorePreferences: true,
      );
      if (!mounted) {
        return;
      }

      if (result.isRestored) {
        ref.invalidate(transactionControllerProvider);
        ref.invalidate(payLaterControllerProvider);
        ref.invalidate(appPreferencesControllerProvider);
      }

      _showSnackBar(messenger, buildBackupOperationFeedback(strings, result));
    } finally {
      if (mounted) {
        setState(() => _isImportingBackup = false);
      }
    }
  }

  Future<bool?> _showRestoreConfirmationDialog(
    BackupImportPreviewResult preview,
  ) {
    final backup = preview.backup!;
    final AppStrings strings = context.strings;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(strings.t(AppStringKey.replaceLocalDataTitle)),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(strings.t(AppStringKey.replaceLocalDataMessage)),
                  const SizedBox(height: 16),
                  Text(
                    '${strings.t(AppStringKey.backupFileName)}: ${preview.fileName ?? '-'}',
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${strings.t(AppStringKey.backupExportedAt)}: ${context.strings.shortDate(backup.exportedAt)}',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${strings.t(AppStringKey.backupSummaryTransactions)}: ${backup.data.transactions.length}',
                  ),
                  Text(
                    '${strings.t(AppStringKey.backupSummaryPlans)}: ${backup.data.payLater.plans.length}',
                  ),
                  Text(
                    '${strings.t(AppStringKey.backupSummaryInvoices)}: ${backup.data.payLater.invoices.length}',
                  ),
                  Text(
                    '${strings.t(AppStringKey.backupSummaryPayments)}: ${backup.data.payLater.payments.length}',
                  ),
                  Text(
                    '${strings.t(AppStringKey.backupContainsPreferences)}: ${backup.data.hasPreferences ? context.strings.t(AppStringKey.yes) : context.strings.t(AppStringKey.no)}',
                  ),
                  const SizedBox(height: 12),
                  Text(strings.t(AppStringKey.restoreReplaceAll)),
                  const SizedBox(height: 6),
                  Text(
                    strings.t(AppStringKey.mergeRestoreDeferred),
                    style: Theme.of(dialogContext).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(strings.t(AppStringKey.cancel)),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(strings.t(AppStringKey.confirmRestore)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AppScaffold(
      title: context.strings.t(AppStringKey.reportsTitle),
      bottomNavigationBar: const AppBottomNavigation(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings.t(AppStringKey.reportsSubtitle),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          ReportActionCard(
            icon: Icons.table_chart_rounded,
            title: context.strings.t(AppStringKey.exportCsv),
            description: context.strings.t(AppStringKey.exportCsvDescription),
            buttonLabel: _isExportingCsv
                ? context.strings.t(AppStringKey.exportingCsv)
                : context.strings.t(AppStringKey.exportCsv),
            buttonIcon: Icons.download_rounded,
            onPressed: _isExportingCsv ? null : _onExportCsv,
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.picture_as_pdf_rounded,
            title: context.strings.t(AppStringKey.exportPdf),
            description: context.strings.t(AppStringKey.exportPdfDescription),
            buttonLabel: _isExportingPdf
                ? context.strings.t(AppStringKey.exportingPdf)
                : context.strings.t(AppStringKey.exportPdf),
            buttonIcon: Icons.picture_as_pdf_rounded,
            onPressed: _isExportingPdf ? null : _onExportPdf,
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.credit_score_rounded,
            title: context.strings.t(AppStringKey.exportPayLaterCsv),
            description: context.strings.t(
              AppStringKey.exportPayLaterCsvDescription,
            ),
            buttonLabel: _isExportingPayLaterCsv
                ? context.strings.t(AppStringKey.exportingPayLaterCsv)
                : context.strings.t(AppStringKey.exportPayLaterCsv),
            buttonIcon: Icons.download_rounded,
            secondaryButtonLabel: _isExportingPayLaterPdf
                ? context.strings.t(AppStringKey.exportingPayLaterPdf)
                : context.strings.t(AppStringKey.exportPayLaterPdf),
            secondaryButtonIcon: Icons.picture_as_pdf_rounded,
            onPressed: _isExportingPayLaterCsv ? null : _onExportPayLaterCsv,
            onSecondaryPressed: _isExportingPayLaterPdf
                ? null
                : _onExportPayLaterPdf,
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.backup_table_rounded,
            title: context.strings.t(AppStringKey.backup),
            description: context.strings.t(AppStringKey.backupDescription),
            buttonLabel: _isExportingBackup
                ? context.strings.t(AppStringKey.exportingBackup)
                : context.strings.t(AppStringKey.exportBackupJson),
            buttonIcon: Icons.download_rounded,
            secondaryButtonLabel: _isImportingBackup
                ? context.strings.t(AppStringKey.importingBackup)
                : context.strings.t(AppStringKey.importBackupJson),
            secondaryButtonIcon: Icons.upload_file_rounded,
            onPressed: _isExportingBackup ? null : _onExportBackup,
            onSecondaryPressed: _isImportingBackup ? null : _onImportBackup,
          ),
          const SizedBox(height: 12),
          Text(
            context.strings.t(AppStringKey.backupHelpMessage),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
