import 'dart:convert';

import 'package:expense_app/features/backup/data/app_backup_codec.dart';
import 'package:expense_app/features/backup/data/backup_file_picker.dart';
import 'package:expense_app/features/backup/domain/app_backup.dart';
import 'package:expense_app/features/backup/domain/backup_import_preview_result.dart';
import 'package:expense_app/features/backup/domain/backup_operation_result.dart';
import 'package:expense_app/features/backup/domain/backup_restore_mode.dart';
import 'package:expense_app/features/pay_later/data/pay_later_repository.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:expense_app/features/reports/data/report_file_write_result.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/reports/data/report_file_namer.dart';
import 'package:expense_app/features/settings/data/app_preferences_repository.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/transactions/data/transaction_repository.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';

class AppBackupService {
  const AppBackupService({
    required TransactionRepository transactionRepository,
    required PayLaterRepository payLaterRepository,
    required AppPreferencesRepository appPreferencesRepository,
    required ReportFileWriter fileWriter,
    required BackupFilePicker filePicker,
    DateTime Function()? now,
  }) : _transactionRepository = transactionRepository,
       _payLaterRepository = payLaterRepository,
       _appPreferencesRepository = appPreferencesRepository,
       _fileWriter = fileWriter,
       _filePicker = filePicker,
       _now = now ?? DateTime.now;

  final TransactionRepository _transactionRepository;
  final PayLaterRepository _payLaterRepository;
  final AppPreferencesRepository _appPreferencesRepository;
  final ReportFileWriter _fileWriter;
  final BackupFilePicker _filePicker;
  final DateTime Function() _now;

  Future<AppBackup> buildBackup({bool includePreferences = true}) async {
    final List<Object> records = await Future.wait<Object>(<Future<Object>>[
      _transactionRepository.getTransactions(),
      _payLaterRepository.getInstallmentPlans(),
      _payLaterRepository.getInvoices(),
      _payLaterRepository.getPayments(),
      if (includePreferences) _appPreferencesRepository.loadPreferences(),
    ]);
    final List transactions = records[0] as List;
    final List plans = records[1] as List;
    final List invoices = records[2] as List;
    final List payments = records[3] as List;

    return AppBackup(
      schemaVersion: appBackupSchemaVersion,
      app: appBackupAppId,
      exportedAt: _now(),
      data: AppBackupData(
        transactions: List<TransactionModel>.unmodifiable(
          transactions.cast<TransactionModel>(),
        ),
        payLater: AppBackupPayLaterData(
          plans: List<InstallmentPlan>.unmodifiable(
            plans.cast<InstallmentPlan>(),
          ),
          invoices: List<PayLaterInvoice>.unmodifiable(
            invoices.cast<PayLaterInvoice>(),
          ),
          payments: List<PayLaterPayment>.unmodifiable(
            payments.cast<PayLaterPayment>(),
          ),
        ),
        preferences: includePreferences ? records[4] as AppPreferences : null,
      ),
    );
  }

  Future<BackupOperationResult> exportBackup({
    bool includePreferences = true,
  }) async {
    final AppBackup backup = await buildBackup(
      includePreferences: includePreferences,
    );
    final String fileName = ReportFileNamer.backupJsonName(backup.exportedAt);
    final List<int> bytes = utf8.encode(encodeAppBackupJson(backup));

    try {
      final ReportFileWriteResult writeResult = await _fileWriter.writeBytes(
        fileName: fileName,
        bytes: bytes,
        androidDirectoryName: 'backups',
      );
      return switch (writeResult.status) {
        ReportFileWriteStatus.saved => BackupOperationResult(
          status: BackupOperationStatus.saved,
          message: 'Backup exported.',
          fileName: fileName,
          filePath: writeResult.filePath,
        ),
        ReportFileWriteStatus.cancelled => BackupOperationResult(
          status: BackupOperationStatus.cancelled,
          message: 'Backup export cancelled.',
          fileName: fileName,
        ),
        ReportFileWriteStatus.unsupported => BackupOperationResult(
          status: BackupOperationStatus.unsupported,
          message: 'Backup export is not supported on this platform.',
          fileName: fileName,
        ),
      };
    } catch (error) {
      return BackupOperationResult(
        status: BackupOperationStatus.failed,
        message: 'Could not export backup. $error',
        fileName: fileName,
      );
    }
  }

  Future<BackupImportPreviewResult> prepareRestoreFromPickedFile() async {
    final BackupFilePickResult fileResult = await _filePicker.pickJsonFile();
    switch (fileResult.status) {
      case BackupFilePickStatus.cancelled:
        return BackupImportPreviewResult(
          status: BackupImportPreviewStatus.cancelled,
          message: fileResult.message,
        );
      case BackupFilePickStatus.unsupported:
        return BackupImportPreviewResult(
          status: BackupImportPreviewStatus.unsupported,
          message: fileResult.message,
        );
      case BackupFilePickStatus.failed:
        return BackupImportPreviewResult(
          status: BackupImportPreviewStatus.failed,
          message: fileResult.message,
        );
      case BackupFilePickStatus.selected:
        break;
    }

    try {
      final String rawJson = utf8.decode(fileResult.bytes!);
      final AppBackup backup = decodeAppBackupJson(rawJson);
      return BackupImportPreviewResult(
        status: BackupImportPreviewStatus.ready,
        message: 'Backup ready to restore.',
        fileName: fileResult.fileName,
        backup: backup,
      );
    } on FormatException catch (error) {
      return BackupImportPreviewResult(
        status: BackupImportPreviewStatus.failed,
        message: error.message,
        fileName: fileResult.fileName,
      );
    } catch (error) {
      return BackupImportPreviewResult(
        status: BackupImportPreviewStatus.failed,
        message: 'Could not decode backup. $error',
        fileName: fileResult.fileName,
      );
    }
  }

  Future<BackupOperationResult> restoreBackup(
    AppBackup backup, {
    BackupRestoreMode mode = BackupRestoreMode.replaceAll,
    bool restorePreferences = true,
  }) async {
    if (mode != BackupRestoreMode.replaceAll) {
      return const BackupOperationResult(
        status: BackupOperationStatus.unsupported,
        message: 'Only replace-all restore mode is supported.',
      );
    }

    try {
      await _transactionRepository.replaceAll(backup.data.transactions);
      await _payLaterRepository.replaceAll(
        plans: backup.data.payLater.plans,
        invoices: backup.data.payLater.invoices,
        payments: backup.data.payLater.payments,
      );
      if (restorePreferences && backup.data.preferences != null) {
        await _appPreferencesRepository.savePreferences(
          backup.data.preferences!,
        );
      }

      return const BackupOperationResult(
        status: BackupOperationStatus.restored,
        message: 'Backup restored.',
      );
    } catch (error) {
      return BackupOperationResult(
        status: BackupOperationStatus.failed,
        message: 'Could not restore backup. $error',
      );
    }
  }
}
