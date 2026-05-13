import 'dart:convert';

import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/features/backup/data/app_backup_codec.dart';
import 'package:expense_app/features/backup/data/app_backup_service.dart';
import 'package:expense_app/features/backup/data/backup_file_picker.dart';
import 'package:expense_app/features/backup/domain/app_backup.dart';
import 'package:expense_app/features/backup/domain/backup_restore_mode.dart';
import 'package:expense_app/features/pay_later/data/in_memory_pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_summary_builder.dart';
import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/settings/data/app_preferences_repository.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:expense_app/features/transactions/data/in_memory_transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_data/backup_fixture.dart';

void main() {
  group('AppBackupService', () {
    test(
      'buildBackup includes transactions, pay later, and preferences',
      () async {
        final InMemoryTransactionRepository transactionRepository =
            InMemoryTransactionRepository(
              initialTransactions: buildBackupFixture().data.transactions,
            );
        final InMemoryPayLaterRepository payLaterRepository =
            InMemoryPayLaterRepository();
        final AppBackup sourceBackup = buildBackupFixture();
        await payLaterRepository.replaceAll(
          plans: sourceBackup.data.payLater.plans,
          invoices: sourceBackup.data.payLater.invoices,
          payments: sourceBackup.data.payLater.payments,
        );
        final FakeAppPreferencesRepository preferencesRepository =
            FakeAppPreferencesRepository(
              const AppPreferences(
                locale: AppLocale.en,
                theme: AppThemePreference.dark,
              ),
            );
        final AppBackupService service = AppBackupService(
          transactionRepository: transactionRepository,
          payLaterRepository: payLaterRepository,
          appPreferencesRepository: preferencesRepository,
          fileWriter: RecordingReportFileWriter(),
          filePicker: const FakeBackupFilePicker.cancelled(),
          now: () => DateTime(2026, 5, 8, 14, 30),
        );

        final AppBackup backup = await service.buildBackup();

        expect(backup.data.transactions, hasLength(1));
        expect(backup.data.payLater.plans, hasLength(1));
        expect(backup.data.payLater.invoices, hasLength(1));
        expect(backup.data.payLater.payments, hasLength(1));
        expect(backup.data.preferences?.theme, AppThemePreference.dark);
      },
    );

    test('exportBackup writes JSON into backups directory', () async {
      final RecordingReportFileWriter writer = RecordingReportFileWriter();
      final AppBackup sourceBackup = buildBackupFixture();
      final InMemoryPayLaterRepository payLaterRepository =
          InMemoryPayLaterRepository();
      await payLaterRepository.replaceAll(
        plans: sourceBackup.data.payLater.plans,
        invoices: sourceBackup.data.payLater.invoices,
        payments: sourceBackup.data.payLater.payments,
      );
      final AppBackupService service = AppBackupService(
        transactionRepository: InMemoryTransactionRepository(
          initialTransactions: sourceBackup.data.transactions,
        ),
        payLaterRepository: payLaterRepository,
        appPreferencesRepository: FakeAppPreferencesRepository(
          sourceBackup.data.preferences!,
        ),
        fileWriter: writer,
        filePicker: const FakeBackupFilePicker.cancelled(),
        now: () => DateTime(2026, 5, 8, 14, 30),
      );

      final result = await service.exportBackup();

      expect(result.isSaved, isTrue);
      expect(writer.lastFileName, 'expense_backup_20260508_1430.json');
      expect(writer.lastAndroidDirectoryName, 'backups');
      expect(writer.lastBytes, isNotNull);

      final AppBackup decoded = decodeAppBackupJson(
        utf8.decode(writer.lastBytes!),
      );
      expect(decoded.data.transactions.single.category, 'Ăn uống');
      expect(decoded.data.payLater.payments.single.note, 'Đóng tối thiểu');
    });

    test('prepareRestoreFromPickedFile returns ready backup preview', () async {
      final AppBackup backup = buildBackupFixture();
      final AppBackupService service = AppBackupService(
        transactionRepository: InMemoryTransactionRepository(),
        payLaterRepository: InMemoryPayLaterRepository(),
        appPreferencesRepository: FakeAppPreferencesRepository(
          AppPreferences.defaults,
        ),
        fileWriter: RecordingReportFileWriter(),
        filePicker: FakeBackupFilePicker.selected(
          fileName: 'expense_backup.json',
          bytes: utf8.encode(encodeAppBackupJson(backup)),
        ),
      );

      final preview = await service.prepareRestoreFromPickedFile();

      expect(preview.isReady, isTrue);
      expect(preview.fileName, 'expense_backup.json');
      expect(preview.backup?.data.transactions.single.id, 'backup_tx_1');
    });

    test(
      'restoreBackup replaceAll clears old data and keeps payment effects',
      () async {
        final InMemoryTransactionRepository transactionRepository =
            InMemoryTransactionRepository();
        final InMemoryPayLaterRepository payLaterRepository =
            InMemoryPayLaterRepository();
        final FakeAppPreferencesRepository preferencesRepository =
            FakeAppPreferencesRepository(AppPreferences.defaults);

        await payLaterRepository.addInvoice(
          buildBackupFixture().data.payLater.invoices.single,
        );
        final AppBackupService service = AppBackupService(
          transactionRepository: transactionRepository,
          payLaterRepository: payLaterRepository,
          appPreferencesRepository: preferencesRepository,
          fileWriter: RecordingReportFileWriter(),
          filePicker: const FakeBackupFilePicker.cancelled(),
        );

        final result = await service.restoreBackup(
          buildBackupFixture(),
          mode: BackupRestoreMode.replaceAll,
          restorePreferences: true,
        );

        expect(result.isRestored, isTrue);
        expect(await transactionRepository.getTransactions(), hasLength(1));
        expect(await payLaterRepository.getInstallmentPlans(), hasLength(1));
        expect(await payLaterRepository.getInvoices(), hasLength(1));
        expect(await payLaterRepository.getPayments(), hasLength(1));
        expect(preferencesRepository.saved.locale, AppLocale.en);

        final summary = const PayLaterSummaryBuilder().build(
          plans: await payLaterRepository.getInstallmentPlans(),
          invoices: await payLaterRepository.getInvoices(),
          payments: await payLaterRepository.getPayments(),
          now: DateTime(2026, 5, 8, 12, 0),
        );
        expect(summary.totalPaidThisMonth, 80);
        expect(summary.totalOutstanding, closeTo(1020, 0.001));
      },
    );
  });
}

class RecordingReportFileWriter implements ReportFileWriter {
  ReportFileWriteResult result;

  RecordingReportFileWriter({
    this.result = const ReportFileWriteResult.saved('/tmp/backup.json'),
  });

  String? lastFileName;
  String? lastAndroidDirectoryName;
  List<int>? lastBytes;

  @override
  Future<ReportFileWriteResult> writeBytes({
    required String fileName,
    required List<int> bytes,
    String androidDirectoryName = 'reports',
  }) async {
    lastFileName = fileName;
    lastAndroidDirectoryName = androidDirectoryName;
    lastBytes = bytes;
    return result;
  }
}

class FakeAppPreferencesRepository implements AppPreferencesRepository {
  FakeAppPreferencesRepository(this.saved);

  AppPreferences saved;

  @override
  Future<AppPreferences> loadPreferences() async => saved;

  @override
  Future<void> savePreferences(AppPreferences preferences) async {
    saved = preferences;
  }
}

class FakeBackupFilePicker implements BackupFilePicker {
  const FakeBackupFilePicker._(this._result);

  const FakeBackupFilePicker.cancelled()
    : this._(
        const BackupFilePickResult(
          status: BackupFilePickStatus.cancelled,
          message: 'cancelled',
        ),
      );

  FakeBackupFilePicker.selected({
    required String fileName,
    required List<int> bytes,
  }) : this._(
         BackupFilePickResult(
           status: BackupFilePickStatus.selected,
           message: 'selected',
           fileName: fileName,
           bytes: bytes,
         ),
       );

  final BackupFilePickResult _result;

  @override
  Future<BackupFilePickResult> pickJsonFile() async => _result;
}
