import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:expense_app/features/reports/data/report_export_service_provider.dart';
import 'package:expense_app/features/reports/domain/report_export_format.dart';
import 'package:expense_app/features/reports/domain/report_export_request.dart';
import 'package:expense_app/features/reports/presentation/widgets/report_action_card.dart';
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

  void _showSnackBar(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  String _messageForExportResult(
    AppStrings strings,
    ReportExportFormat format,
    String rawMessage,
    String? filePath,
  ) {
    if (filePath != null) {
      return format == ReportExportFormat.csv
          ? strings.t(AppStringKey.csvExported)
          : strings.t(AppStringKey.pdfExported);
    }

    if (rawMessage.contains('Đã hủy') || rawMessage.contains('cancel')) {
      return format == ReportExportFormat.csv
          ? strings.t(AppStringKey.csvExportCancelled)
          : strings.t(AppStringKey.pdfExportCancelled);
    }

    if (rawMessage.contains('chưa hỗ trợ') || rawMessage.contains('support')) {
      return format == ReportExportFormat.csv
          ? strings.t(AppStringKey.csvExportUnsupported)
          : strings.t(AppStringKey.pdfExportUnsupported);
    }

    return format == ReportExportFormat.csv
        ? strings.t(AppStringKey.couldNotExportCsv)
        : strings.t(AppStringKey.couldNotExportPdf);
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

          _showSnackBar(
            messenger,
            _messageForExportResult(
              strings,
              result.format,
              result.message,
              result.filePath,
            ),
          );
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

          _showSnackBar(
            messenger,
            _messageForExportResult(
              strings,
              result.format,
              result.message,
              result.filePath,
            ),
          );
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
            onPressed: _isExportingCsv ? () {} : _onExportCsv,
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.picture_as_pdf_rounded,
            title: context.strings.t(AppStringKey.exportPdf),
            description: context.strings.t(AppStringKey.exportPdfDescription),
            buttonLabel: _isExportingPdf
                ? context.strings.t(AppStringKey.exportingPdf)
                : context.strings.t(AppStringKey.exportPdf),
            onPressed: _isExportingPdf ? () {} : _onExportPdf,
          ),
          const SizedBox(height: 16),
          ReportActionCard(
            icon: Icons.backup_table_rounded,
            title: context.strings.t(AppStringKey.backup),
            description: context.strings.t(AppStringKey.backupDescription),
            buttonLabel: context.strings.t(AppStringKey.viewRoadmap),
            onPressed: () => _showSnackBar(
              ScaffoldMessenger.of(context),
              context.strings.t(AppStringKey.backupComingSoon),
            ),
          ),
        ],
      ),
    );
  }
}
