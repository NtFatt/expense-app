enum BackupOperationStatus { saved, restored, cancelled, unsupported, failed }

final class BackupOperationResult {
  const BackupOperationResult({
    required this.status,
    required this.message,
    this.fileName,
    this.filePath,
  });

  final BackupOperationStatus status;
  final String message;
  final String? fileName;
  final String? filePath;

  bool get isSaved => status == BackupOperationStatus.saved;
  bool get isRestored => status == BackupOperationStatus.restored;
  bool get isCancelled => status == BackupOperationStatus.cancelled;
  bool get isUnsupported => status == BackupOperationStatus.unsupported;
  bool get isFailure => status == BackupOperationStatus.failed;
}
