import 'package:drift/drift.dart';

class Transactions extends Table {
  TextColumn get id => text()();

  TextColumn get type => text()();

  IntColumn get amount => integer()();

  TextColumn get category => text()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get transactionDate => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
