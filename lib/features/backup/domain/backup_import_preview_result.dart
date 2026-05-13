import 'package:expense_app/features/backup/domain/app_backup.dart';

enum BackupImportPreviewStatus { ready, cancelled, unsupported, failed }

final class BackupImportPreviewResult {
  const BackupImportPreviewResult({
    required this.status,
    required this.message,
    this.fileName,
    this.backup,
  });

  final BackupImportPreviewStatus status;
  final String message;
  final String? fileName;
  final AppBackup? backup;

  bool get isReady => status == BackupImportPreviewStatus.ready;
  bool get isCancelled => status == BackupImportPreviewStatus.cancelled;
  bool get isUnsupported => status == BackupImportPreviewStatus.unsupported;
  bool get isFailure => status == BackupImportPreviewStatus.failed;
}
