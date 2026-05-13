final class UnsupportedSchemaVersionException implements FormatException {
  const UnsupportedSchemaVersionException({
    required this.subject,
    required this.supportedVersion,
    required this.actualVersion,
  });

  final String subject;
  final int supportedVersion;
  final int actualVersion;

  @override
  String get message =>
      'Unsupported $subject schema version: $actualVersion. '
      'Supported version: $supportedVersion.';

  @override
  int? get offset => null;

  @override
  String? get source => null;

  @override
  String toString() => 'FormatException: $message';
}
