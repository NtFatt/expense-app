import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings.dart';
import 'package:expense_app/features/backup/domain/backup_import_preview_result.dart';
import 'package:expense_app/features/backup/domain/backup_operation_result.dart';

String buildBackupOperationFeedback(
  AppStrings strings,
  BackupOperationResult result,
) {
  switch (result.status) {
    case BackupOperationStatus.saved:
      final String target = result.filePath ?? result.fileName ?? '';
      return '${strings.t(AppStringKey.backupExported)}: $target';
    case BackupOperationStatus.restored:
      return strings.t(AppStringKey.backupImported);
    case BackupOperationStatus.cancelled:
      return strings.t(AppStringKey.backupExportCancelled);
    case BackupOperationStatus.unsupported:
      return strings.t(AppStringKey.backupExportUnsupported);
    case BackupOperationStatus.failed:
      final String fallback = result.fileName == null
          ? strings.t(AppStringKey.couldNotImportBackup)
          : strings.t(AppStringKey.couldNotExportBackup);
      return result.message.isEmpty ? fallback : '$fallback ${result.message}';
  }
}

String buildBackupImportPreviewFeedback(
  AppStrings strings,
  BackupImportPreviewResult result,
) {
  switch (result.status) {
    case BackupImportPreviewStatus.ready:
      return result.message;
    case BackupImportPreviewStatus.cancelled:
      return strings.t(AppStringKey.backupImportCancelled);
    case BackupImportPreviewStatus.unsupported:
      return strings.t(AppStringKey.backupImportUnsupported);
    case BackupImportPreviewStatus.failed:
      final String fallback = strings.t(AppStringKey.couldNotImportBackup);
      return result.message.isEmpty ? fallback : '$fallback ${result.message}';
  }
}
