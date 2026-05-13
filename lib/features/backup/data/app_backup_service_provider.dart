import 'package:expense_app/features/backup/data/app_backup_service.dart';
import 'package:expense_app/features/backup/data/backup_file_picker.dart';
import 'package:expense_app/features/pay_later/presentation/controllers/pay_later_controller.dart';
import 'package:expense_app/features/reports/data/report_file_writer.dart';
import 'package:expense_app/features/settings/presentation/controllers/app_preferences_controller.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backupFilePickerProvider = Provider<BackupFilePicker>(
  (Ref ref) => const FileSelectorBackupFilePicker(),
);

final appBackupServiceProvider = Provider<AppBackupService>((Ref ref) {
  return AppBackupService(
    transactionRepository: ref.read(transactionRepositoryProvider),
    payLaterRepository: ref.read(payLaterRepositoryProvider),
    appPreferencesRepository: ref.read(appPreferencesRepositoryProvider),
    fileWriter: createReportFileWriter(),
    filePicker: ref.read(backupFilePickerProvider),
  );
});
