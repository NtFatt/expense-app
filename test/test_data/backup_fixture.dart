import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/features/backup/domain/app_backup.dart';
import 'package:expense_app/features/pay_later/domain/installment_plan.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_enums.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_invoice.dart';
import 'package:expense_app/features/pay_later/domain/pay_later_payment.dart';
import 'package:expense_app/features/settings/domain/app_preferences.dart';
import 'package:expense_app/features/settings/domain/app_theme_preference.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';

AppBackup buildBackupFixture() {
  final DateTime now = DateTime(2026, 5, 8, 10, 0);
  return AppBackup(
    schemaVersion: appBackupSchemaVersion,
    app: appBackupAppId,
    exportedAt: now,
    data: AppBackupData(
      transactions: <TransactionModel>[
        TransactionModel(
          id: 'backup_tx_1',
          type: TransactionType.expense,
          amount: 54000,
          category: 'Ăn uống',
          note: 'Bữa trưa văn phòng',
          transactionDate: now,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      payLater: AppBackupPayLaterData(
        plans: <InstallmentPlan>[
          InstallmentPlan(
            id: 'backup_plan_1',
            title: 'Trả góp điện thoại',
            providerName: 'Cửa hàng Điện Máy',
            originalAmount: 600,
            monthlyPaymentAmount: 100,
            minimumPaymentAmount: 80,
            paidAmount: 80,
            totalInstallments: 6,
            paidInstallments: 0,
            startDate: DateTime(2026, 5, 1),
            dueDayOfMonth: 15,
            status: InstallmentStatus.active,
            note: 'Kỳ đầu tiên',
            createdAt: now,
            updatedAt: now,
          ),
        ],
        invoices: <PayLaterInvoice>[
          PayLaterInvoice(
            id: 'backup_invoice_1',
            providerName: 'Thẻ tín dụng Nội địa',
            statementMonth: DateTime(2026, 5),
            statementDate: DateTime(2026, 5, 2),
            dueDate: DateTime(2026, 5, 15),
            totalAmount: 500,
            minimumPaymentAmount: 150,
            paidAmount: 0,
            status: PayLaterInvoiceStatus.unpaid,
            note: 'Hóa đơn tháng Năm',
            createdAt: now,
            updatedAt: now,
          ),
        ],
        payments: <PayLaterPayment>[
          PayLaterPayment(
            id: 'backup_payment_1',
            targetId: 'backup_plan_1',
            targetType: PayLaterTargetType.installmentPlan,
            amount: 80,
            paymentType: PayLaterPaymentType.customPayment,
            paidAt: now,
            note: 'Đóng tối thiểu',
            createdAt: now,
          ),
        ],
      ),
      preferences: const AppPreferences(
        locale: AppLocale.en,
        theme: AppThemePreference.dark,
      ),
    ),
  );
}
