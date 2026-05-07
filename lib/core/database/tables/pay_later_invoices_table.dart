import 'package:drift/drift.dart';

class PayLaterInvoices extends Table {
  @override
  String get tableName => 'pay_later_invoices';

  TextColumn get id => text()();

  TextColumn get providerName => text()();

  DateTimeColumn get statementMonth => dateTime()();

  DateTimeColumn get statementDate => dateTime()();

  DateTimeColumn get dueDate => dateTime()();

  IntColumn get totalAmount => integer()();

  IntColumn get minimumPaymentAmount => integer()();

  IntColumn get paidAmount => integer()();

  TextColumn get status => text()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
