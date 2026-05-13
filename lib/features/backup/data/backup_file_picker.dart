import 'package:file_selector/file_selector.dart';

enum BackupFilePickStatus { selected, cancelled, unsupported, failed }

final class BackupFilePickResult {
  const BackupFilePickResult({
    required this.status,
    required this.message,
    this.fileName,
    this.bytes,
  });

  final BackupFilePickStatus status;
  final String message;
  final String? fileName;
  final List<int>? bytes;

  bool get hasBytes => bytes != null;
}

abstract interface class BackupFilePicker {
  Future<BackupFilePickResult> pickJsonFile();
}

final class FileSelectorBackupFilePicker implements BackupFilePicker {
  const FileSelectorBackupFilePicker();

  static const XTypeGroup _jsonTypeGroup = XTypeGroup(
    label: 'JSON',
    extensions: <String>['json'],
  );

  @override
  Future<BackupFilePickResult> pickJsonFile() async {
    try {
      final XFile? file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[_jsonTypeGroup],
      );
      if (file == null) {
        return const BackupFilePickResult(
          status: BackupFilePickStatus.cancelled,
          message: 'Backup import cancelled.',
        );
      }

      return BackupFilePickResult(
        status: BackupFilePickStatus.selected,
        message: 'Backup file selected.',
        fileName: file.name,
        bytes: await file.readAsBytes(),
      );
    } on UnsupportedError {
      return const BackupFilePickResult(
        status: BackupFilePickStatus.unsupported,
        message: 'Backup import is not supported on this platform.',
      );
    } catch (error) {
      return BackupFilePickResult(
        status: BackupFilePickStatus.failed,
        message: 'Could not read backup file. $error',
      );
    }
  }
}
