import 'package:drift/drift.dart';

class PayLaterInstallmentPlans extends Table {
  @override
  String get tableName => 'pay_later_installment_plans';

  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get providerName => text()();

  IntColumn get originalAmount => integer()();

  IntColumn get monthlyPaymentAmount => integer()();

  IntColumn get minimumPaymentAmount => integer()();

  IntColumn get paidAmount => integer()();

  IntColumn get totalInstallments => integer()();

  IntColumn get paidInstallments => integer()();

  DateTimeColumn get startDate => dateTime()();

  IntColumn get dueDayOfMonth => integer()();

  TextColumn get status => text()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
