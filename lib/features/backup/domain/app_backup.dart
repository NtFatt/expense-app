import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';

const int appBackupSchemaVersion = 1;
const String appBackupAppId = 'expense_app';

final class AppBackup {
  const AppBackup({
    required this.schemaVersion,
    required this.app,
    required this.exportedAt,
    required this.data,
  });

  final int schemaVersion;
  final String app;
  final DateTime exportedAt;
  final AppBackupData data;
}

final class AppBackupData {
  const AppBackupData({
    required this.transactions,
    required this.payLater,
    this.preferences,
  });

  final List<TransactionModel> transactions;
  final AppBackupPayLaterData payLater;
  final AppPreferences? preferences;

  bool get hasPreferences => preferences != null;
}

final class AppBackupPayLaterData {
  const AppBackupPayLaterData({
    required this.plans,
    required this.invoices,
    required this.payments,
  });

  final List<InstallmentPlan> plans;
  final List<PayLaterInvoice> invoices;
  final List<PayLaterPayment> payments;

  bool get isEmpty => plans.isEmpty && invoices.isEmpty && payments.isEmpty;
}
