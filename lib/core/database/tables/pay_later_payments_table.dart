import 'package:drift/drift.dart';

class PayLaterPayments extends Table {
  @override
  String get tableName => 'pay_later_payments';

  TextColumn get id => text()();

  TextColumn get targetId => text()();

  TextColumn get targetType => text()();

  IntColumn get amount => integer()();

  TextColumn get paymentType => text()();

  DateTimeColumn get paidAt => dateTime()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
