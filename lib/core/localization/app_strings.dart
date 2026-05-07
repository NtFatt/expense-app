import 'package:expense_app/core/localization/app_locale.dart';
import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Lightweight typed localization registry for Phase 9E.
///
/// This mirrors the shape we would later move into ARB files:
/// - supported locales live in [AppLocale]
/// - stable message keys live in [AppStringKey]
/// - translations are grouped by locale in [_values]
///
/// Future migration path:
/// 1. Create `lib/l10n/app_en.arb` and `lib/l10n/app_vi.arb`
/// 2. Reuse the same key names from [AppStringKey]
/// 3. Replace `AppStrings.of(context)` with generated `AppLocalizations`
final class AppStrings {
  const AppStrings(this.locale);

  final AppLocale locale;

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static AppStrings of(BuildContext context) {
    final AppStrings? strings = Localizations.of<AppStrings>(
      context,
      AppStrings,
    );
    assert(strings != null, 'AppStrings was not found in the widget tree.');
    return strings!;
  }

  static const Map<AppLocale, Map<AppStringKey, String>>
  _values = <AppLocale, Map<AppStringKey, String>>{
    AppLocale.vi: <AppStringKey, String>{
      AppStringKey.appName: 'Expense App',
      AppStringKey.navDashboard: 'Tổng quan',
      AppStringKey.navTransactions: 'Giao dịch',
      AppStringKey.navStatistics: 'Thống kê',
      AppStringKey.navReports: 'Báo cáo',
      AppStringKey.navSettings: 'Cài đặt',
      AppStringKey.dashboardTitle: 'Tổng quan',
      AppStringKey.transactionsTitle: 'Giao dịch',
      AppStringKey.statisticsTitle: 'Thống kê',
      AppStringKey.reportsTitle: 'Báo cáo',
      AppStringKey.settingsTitle: 'Cài đặt',
      AppStringKey.dashboardSubtitle: 'Theo dõi thu chi cá nhân của bạn',
      AppStringKey.statisticsSubtitle:
          'Bức tranh tài chính hiện tại từ các giao dịch bạn đã nhập.',
      AppStringKey.reportsSubtitle: 'Xuất và sao lưu dữ liệu chi tiêu cá nhân',
      AppStringKey.settingsSubtitle:
          'Tùy chỉnh ngôn ngữ và giao diện cho trải nghiệm của bạn.',
      AppStringKey.currentBalance: 'Số dư hiện tại',
      AppStringKey.income: 'Thu',
      AppStringKey.expense: 'Chi',
      AppStringKey.balance: 'Số dư',
      AppStringKey.totalIncome: 'Tổng thu',
      AppStringKey.totalExpense: 'Tổng chi',
      AppStringKey.totalTransactions: 'Tổng số giao dịch',
      AppStringKey.transactionCount: 'Số giao dịch',
      AppStringKey.quickSummary: 'Tóm tắt nhanh',
      AppStringKey.quickSummarySubtitle:
          'Theo dõi số lượng giao dịch và tác động tới số dư hiện tại.',
      AppStringKey.recentTransactions: 'Giao dịch gần đây',
      AppStringKey.monthlyTransactions: 'Giao dịch tháng này',
      AppStringKey.spendingByCategory: 'Chi tiêu theo danh mục',
      AppStringKey.spendingByCategorySubtitle:
          'Tỷ trọng từng danh mục trên tổng chi hiện tại.',
      AppStringKey.topCategory: 'Chi nhiều nhất',
      AppStringKey.addTransaction: 'Thêm giao dịch',
      AppStringKey.addNew: 'Thêm mới',
      AppStringKey.editTransaction: 'Sửa giao dịch',
      AppStringKey.updateTransaction: 'Cập nhật giao dịch',
      AppStringKey.saveTransaction: 'Lưu giao dịch',
      AppStringKey.delete: 'Xóa',
      AppStringKey.cancel: 'Hủy',
      AppStringKey.save: 'Lưu',
      AppStringKey.search: 'Tìm kiếm',
      AppStringKey.noData: 'Không có dữ liệu',
      AppStringKey.viewAll: 'Xem tất cả',
      AppStringKey.backToTransactions: 'Quay lại giao dịch',
      AppStringKey.transactionType: 'Loại giao dịch',
      AppStringKey.amount: 'Số tiền',
      AppStringKey.category: 'Danh mục',
      AppStringKey.note: 'Ghi chú',
      AppStringKey.transactionDate: 'Ngày giao dịch',
      AppStringKey.currencyCode: 'VNĐ',
      AppStringKey.all: 'Tất cả',
      AppStringKey.searchTransactions: 'Tìm kiếm giao dịch',
      AppStringKey.searchByCategoryOrNote: 'Tìm theo danh mục, ghi chú...',
      AppStringKey.clearFilters: 'Xóa lọc',
      AppStringKey.amountHint: 'Nhập số tiền giao dịch',
      AppStringKey.amountHelper:
          'Chỉ nhập số dương, hệ thống tự phân loại thu/chi.',
      AppStringKey.amountRequired: 'Vui lòng nhập số tiền',
      AppStringKey.amountGreaterThanZero: 'Số tiền phải lớn hơn 0',
      AppStringKey.noteHint: 'Ví dụ: ăn sáng, mua sách, lương tháng này...',
      AppStringKey.addTransactionDescription:
          'Ghi lại một khoản thu hoặc chi để cập nhật số dư của bạn.',
      AppStringKey.editTransactionDescription:
          'Chỉnh sửa thông tin giao dịch và lưu lại thay đổi.',
      AppStringKey.saveTransactionButton: 'Lưu giao dịch',
      AppStringKey.updateTransactionButton: 'Cập nhật giao dịch',
      AppStringKey.noTransactions: 'Chưa có giao dịch',
      AppStringKey.noTransactionsMessage:
          'Hãy thêm giao dịch đầu tiên để bắt đầu theo dõi chi tiêu.',
      AppStringKey.noTransactionsThisMonth: 'Chưa có giao dịch tháng này',
      AppStringKey.noTransactionsThisMonthMessage:
          'Thêm giao dịch mới hoặc chuyển sang tháng khác để xem dữ liệu.',
      AppStringKey.noMatchingTransactions: 'Không tìm thấy giao dịch phù hợp',
      AppStringKey.noMatchingTransactionsMessage:
          'Thử đổi tháng, loại giao dịch hoặc từ khóa tìm kiếm.',
      AppStringKey.noSpendingData: 'Chưa có dữ liệu chi tiêu',
      AppStringKey.noSpendingDataMessage:
          'Tháng này chưa có khoản chi nào để thống kê.',
      AppStringKey.transactionNotFound: 'Không tìm thấy giao dịch',
      AppStringKey.transactionNotFoundMessage:
          'Giao dịch này có thể đã bị xóa hoặc chưa được tải.',
      AppStringKey.deleteTransactionTitle: 'Xóa giao dịch?',
      AppStringKey.deleteTransactionMessage: 'Thao tác này không thể hoàn tác.',
      AppStringKey.transactionAdded: 'Đã thêm giao dịch',
      AppStringKey.transactionUpdated: 'Đã cập nhật giao dịch',
      AppStringKey.transactionDeleted: 'Đã xóa giao dịch',
      AppStringKey.couldNotLoadTransactions: 'Không thể tải giao dịch.',
      AppStringKey.couldNotLoadStatistics: 'Không thể tải thống kê.',
      AppStringKey.couldNotLoadTransaction: 'Không thể tải giao dịch.',
      AppStringKey.couldNotDeleteTransaction: 'Không thể xóa giao dịch.',
      AppStringKey.couldNotAddTransaction: 'Không thể thêm giao dịch.',
      AppStringKey.couldNotUpdateTransaction: 'Không thể cập nhật giao dịch.',
      AppStringKey.exportCsv: 'Xuất CSV',
      AppStringKey.exportPdf: 'Xuất PDF',
      AppStringKey.backup: 'Sao lưu',
      AppStringKey.exportCsvDescription:
          'Tải danh sách giao dịch dạng bảng để xử lý tiếp.',
      AppStringKey.exportPdfDescription:
          'Tạo báo cáo thu chi theo tháng để chia sẻ hoặc lưu trữ.',
      AppStringKey.backupDescription:
          'Chuẩn bị cho SQLite/Drift persistence ở các phase sau.',
      AppStringKey.exportingCsv: 'Đang xuất...',
      AppStringKey.exportingPdf: 'Đang xuất...',
      AppStringKey.viewRoadmap: 'Xem lộ trình',
      AppStringKey.comingSoon: 'Sắp ra mắt',
      AppStringKey.backupComingSoon: 'Sao lưu dữ liệu đang được phát triển',
      AppStringKey.csvExported: 'Đã xuất CSV',
      AppStringKey.pdfExported: 'Đã xuất PDF',
      AppStringKey.csvExportCancelled: 'Đã hủy xuất CSV.',
      AppStringKey.pdfExportCancelled: 'Đã hủy xuất PDF.',
      AppStringKey.csvExportUnsupported:
          'Xuất CSV chưa hỗ trợ lưu file trên nền tảng này.',
      AppStringKey.pdfExportUnsupported:
          'Xuất PDF chưa hỗ trợ lưu file trên nền tảng này.',
      AppStringKey.couldNotExportCsv: 'Không thể xuất CSV. Vui lòng thử lại.',
      AppStringKey.couldNotExportPdf: 'Không thể xuất PDF. Vui lòng thử lại.',
      AppStringKey.noTransactionsToExport: 'Không có giao dịch để xuất.',
      AppStringKey.transactionsLoadingTryAgain:
          'Dữ liệu giao dịch đang tải, thử lại sau.',
      AppStringKey.couldNotReadTransactions: 'Không thể đọc dữ liệu giao dịch.',
      AppStringKey.payLaterTitle: 'Trả sau & trả góp',
      AppStringKey.payLaterSubtitle:
          'Theo dõi dư nợ, khoản tối thiểu cần trả và các nghĩa vụ sắp đến hạn trong ứng dụng.',
      AppStringKey.payLaterTracker: 'Theo dõi trả sau',
      AppStringKey.payLaterTrackerSubtitle:
          'Quản lý khoản trả góp và hóa đơn trả sau bằng cách ghi nhận thanh toán trong ứng dụng.',
      AppStringKey.openPayLaterTracker: 'Mở trình theo dõi',
      AppStringKey.totalOutstanding: 'Tổng dư nợ',
      AppStringKey.minimumDue: 'Tối thiểu cần trả',
      AppStringKey.dueSoon: 'Sắp đến hạn',
      AppStringKey.overdue: 'Quá hạn',
      AppStringKey.nextDue: 'Kỳ đến hạn tiếp theo',
      AppStringKey.nextDueAmount: 'Số tiền đến hạn',
      AppStringKey.nextDueDate: 'Ngày đến hạn',
      AppStringKey.totalPaidThisMonth: 'Đã ghi nhận tháng này',
      AppStringKey.installmentPlans: 'Khoản trả góp',
      AppStringKey.payLaterInvoices: 'Hóa đơn trả sau',
      AppStringKey.policyNotes: 'Lưu ý chính sách',
      AppStringKey.provider: 'Nhà cung cấp',
      AppStringKey.originalAmount: 'Tổng giá trị',
      AppStringKey.monthlyPayment: 'Khoản trả hàng tháng',
      AppStringKey.minimumPayment: 'Khoản tối thiểu',
      AppStringKey.paid: 'Đã trả',
      AppStringKey.outstanding: 'Còn lại',
      AppStringKey.statementMonth: 'Kỳ sao kê',
      AppStringKey.statementDate: 'Ngày sao kê',
      AppStringKey.dueDate: 'Hạn thanh toán',
      AppStringKey.dueDayOfMonth: 'Ngày đến hạn mỗi tháng',
      AppStringKey.planTitle: 'Tên khoản theo dõi',
      AppStringKey.totalInstallments: 'Tổng số kỳ',
      AppStringKey.paidInstallments: 'Số kỳ đã trả',
      AppStringKey.startDate: 'Ngày bắt đầu',
      AppStringKey.installmentProgress: 'Tiến độ trả góp',
      AppStringKey.remainingInstallments: 'Số kỳ còn lại',
      AppStringKey.addInstallmentPlan: 'Thêm khoản trả góp',
      AppStringKey.editInstallmentPlan: 'Sửa khoản trả góp',
      AppStringKey.addPayLaterInvoice: 'Thêm hóa đơn trả sau',
      AppStringKey.editPayLaterInvoice: 'Sửa hóa đơn trả sau',
      AppStringKey.recordPayment: 'Ghi nhận thanh toán',
      AppStringKey.payMinimum: 'Trả tối thiểu',
      AppStringKey.payCustomAmount: 'Trả số tiền khác',
      AppStringKey.settleFullAmount: 'Tất toán toàn bộ',
      AppStringKey.paymentAmount: 'Số tiền thanh toán',
      AppStringKey.fieldRequired: 'Vui lòng nhập thông tin',
      AppStringKey.invalidNumber: 'Giá trị không hợp lệ',
      AppStringKey.dueDayRange: 'Ngày đến hạn phải từ 1 đến 31',
      AppStringKey.paidInstallmentsRange:
          'Số kỳ đã trả không được lớn hơn tổng số kỳ',
      AppStringKey.paymentExceedsOutstanding:
          'Số tiền thanh toán không được lớn hơn dư nợ còn lại',
      AppStringKey.paymentDisclaimer:
          'Đây chỉ là ghi nhận thanh toán trong ứng dụng, không thực hiện giao dịch thật.',
      AppStringKey.paymentRecorded: 'Đã ghi nhận thanh toán',
      AppStringKey.changesSaved: 'Đã lưu thay đổi',
      AppStringKey.deleteInstallmentPlanPrompt:
          'Khoản trả góp này sẽ bị xóa khỏi trình theo dõi.',
      AppStringKey.deleteInvoicePrompt:
          'Hóa đơn trả sau này sẽ bị xóa khỏi trình theo dõi.',
      AppStringKey.statusActive: 'Đang theo dõi',
      AppStringKey.statusSettled: 'Đã tất toán',
      AppStringKey.statusCancelled: 'Đã hủy',
      AppStringKey.statusUnpaid: 'Chưa thanh toán',
      AppStringKey.statusPartiallyPaid: 'Đã thanh toán một phần',
      AppStringKey.statusPaid: 'Đã thanh toán',
      AppStringKey.noPayLaterItems: 'Chưa có dữ liệu trả sau',
      AppStringKey.noPayLaterItemsMessage:
          'Thêm khoản trả góp hoặc hóa đơn trả sau để bắt đầu theo dõi dư nợ cá nhân.',
      AppStringKey.noInstallmentPlans: 'Chưa có khoản trả góp',
      AppStringKey.noInstallmentPlansMessage:
          'Thêm một khoản trả góp để theo dõi số tiền còn lại và kỳ đến hạn tiếp theo.',
      AppStringKey.noPayLaterInvoices: 'Chưa có hóa đơn trả sau',
      AppStringKey.noPayLaterInvoicesMessage:
          'Thêm hóa đơn trả sau để theo dõi sao kê và khoản tối thiểu cần trả.',
      AppStringKey.noUpcomingDue: 'Chưa có khoản đến hạn sắp tới',
      AppStringKey.couldNotLoadPayLater: 'Không thể tải dữ liệu trả sau.',
      AppStringKey.couldNotSaveInstallmentPlan: 'Không thể lưu khoản trả góp.',
      AppStringKey.couldNotSaveInvoice: 'Không thể lưu hóa đơn trả sau.',
      AppStringKey.couldNotDeleteInstallmentPlan:
          'Không thể xóa khoản trả góp.',
      AppStringKey.couldNotDeleteInvoice: 'Không thể xóa hóa đơn trả sau.',
      AppStringKey.couldNotRecordPayment: 'Không thể ghi nhận thanh toán.',
      AppStringKey.policyNoteMinimumTitle: 'Trả tối thiểu không làm hết dư nợ',
      AppStringKey.policyNoteMinimumDescription:
          'Trả trước tối thiểu chỉ giúp giảm rủi ro quá hạn, không làm hết toàn bộ dư nợ.',
      AppStringKey.policyNoteSettlementTitle:
          'Tất toán là trả toàn bộ số còn lại',
      AppStringKey.policyNoteSettlementDescription:
          'Tất toán nghĩa là thanh toán toàn bộ số tiền còn lại của hóa đơn hoặc khoản trả góp.',
      AppStringKey.policyNoteStatementTitle: 'Sao kê là bản tổng hợp theo kỳ',
      AppStringKey.policyNoteStatementDescription:
          'Sao kê là bản tổng hợp các khoản phát sinh, đã trả và còn phải trả trong kỳ.',
      AppStringKey.policyNoteTrackingOnlyTitle: 'Ứng dụng chỉ hỗ trợ theo dõi',
      AppStringKey.policyNoteTrackingOnlyDescription:
          'Ứng dụng chỉ hỗ trợ theo dõi cá nhân, không thay thế điều khoản chính thức từ nhà cung cấp dịch vụ.',
      AppStringKey.policyNoteVerifyTermsTitle:
          'Kiểm tra điều khoản từ nhà cung cấp',
      AppStringKey.policyNoteVerifyTermsDescription:
          'Hãy kiểm tra hạn thanh toán và phí/phạt trực tiếp trong ứng dụng hoặc hợp đồng của nhà cung cấp.',
      AppStringKey.language: 'Ngôn ngữ',
      AppStringKey.vietnamese: 'Tiếng Việt',
      AppStringKey.english: 'English',
      AppStringKey.appearance: 'Giao diện',
      AppStringKey.lightMode: 'Sáng',
      AppStringKey.darkMode: 'Tối',
      AppStringKey.systemMode: 'Theo hệ thống',
      AppStringKey.preferencesSaved: 'Lựa chọn của bạn đã được lưu',
      AppStringKey.savedLocally: 'Lưu cục bộ',
      AppStringKey.localPreferencesDescription:
          'Tùy chọn được lưu cục bộ bằng shared_preferences.',
      AppStringKey.previousMonth: 'Tháng trước',
      AppStringKey.nextMonth: 'Tháng sau',
      AppStringKey.today: 'Hôm nay',
      AppStringKey.yesterday: 'Hôm qua',
    },
    AppLocale.en: <AppStringKey, String>{
      AppStringKey.appName: 'Expense App',
      AppStringKey.navDashboard: 'Dashboard',
      AppStringKey.navTransactions: 'Transactions',
      AppStringKey.navStatistics: 'Statistics',
      AppStringKey.navReports: 'Reports',
      AppStringKey.navSettings: 'Settings',
      AppStringKey.dashboardTitle: 'Dashboard',
      AppStringKey.transactionsTitle: 'Transactions',
      AppStringKey.statisticsTitle: 'Statistics',
      AppStringKey.reportsTitle: 'Reports',
      AppStringKey.settingsTitle: 'Settings',
      AppStringKey.dashboardSubtitle: 'Track your personal income and expenses',
      AppStringKey.statisticsSubtitle:
          'A snapshot of your current finances from the transactions you entered.',
      AppStringKey.reportsSubtitle:
          'Export and back up your personal expense data',
      AppStringKey.settingsSubtitle:
          'Customize language and appearance for your experience.',
      AppStringKey.currentBalance: 'Current balance',
      AppStringKey.income: 'Income',
      AppStringKey.expense: 'Expense',
      AppStringKey.balance: 'Balance',
      AppStringKey.totalIncome: 'Total income',
      AppStringKey.totalExpense: 'Total expense',
      AppStringKey.totalTransactions: 'Total transactions',
      AppStringKey.transactionCount: 'Transaction count',
      AppStringKey.quickSummary: 'Quick summary',
      AppStringKey.quickSummarySubtitle:
          'Track how many transactions you have and how they affect your balance.',
      AppStringKey.recentTransactions: 'Recent transactions',
      AppStringKey.monthlyTransactions: 'Monthly transactions',
      AppStringKey.spendingByCategory: 'Spending by category',
      AppStringKey.spendingByCategorySubtitle:
          'How each category contributes to your current total spending.',
      AppStringKey.topCategory: 'Top category',
      AppStringKey.addTransaction: 'Add transaction',
      AppStringKey.addNew: 'Add new',
      AppStringKey.editTransaction: 'Edit transaction',
      AppStringKey.updateTransaction: 'Update transaction',
      AppStringKey.saveTransaction: 'Save transaction',
      AppStringKey.delete: 'Delete',
      AppStringKey.cancel: 'Cancel',
      AppStringKey.save: 'Save',
      AppStringKey.search: 'Search',
      AppStringKey.noData: 'No data',
      AppStringKey.viewAll: 'View all',
      AppStringKey.backToTransactions: 'Back to transactions',
      AppStringKey.transactionType: 'Transaction type',
      AppStringKey.amount: 'Amount',
      AppStringKey.category: 'Category',
      AppStringKey.note: 'Note',
      AppStringKey.transactionDate: 'Transaction date',
      AppStringKey.currencyCode: 'VND',
      AppStringKey.all: 'All',
      AppStringKey.searchTransactions: 'Search transactions',
      AppStringKey.searchByCategoryOrNote: 'Search by category or note...',
      AppStringKey.clearFilters: 'Clear filters',
      AppStringKey.amountHint: 'Enter the transaction amount',
      AppStringKey.amountHelper:
          'Only enter positive numbers. The app derives income or expense from the type.',
      AppStringKey.amountRequired: 'Please enter an amount',
      AppStringKey.amountGreaterThanZero: 'Amount must be greater than 0',
      AppStringKey.noteHint: 'Example: breakfast, books, this month salary...',
      AppStringKey.addTransactionDescription:
          'Record income or expense to update your balance.',
      AppStringKey.editTransactionDescription:
          'Edit the transaction details and save your changes.',
      AppStringKey.saveTransactionButton: 'Save transaction',
      AppStringKey.updateTransactionButton: 'Update transaction',
      AppStringKey.noTransactions: 'No transactions yet',
      AppStringKey.noTransactionsMessage:
          'Add your first transaction to start tracking spending.',
      AppStringKey.noTransactionsThisMonth: 'No transactions this month',
      AppStringKey.noTransactionsThisMonthMessage:
          'Add a new transaction or switch to another month to see data.',
      AppStringKey.noMatchingTransactions: 'No matching transactions found',
      AppStringKey.noMatchingTransactionsMessage:
          'Try a different month, transaction type, or search keyword.',
      AppStringKey.noSpendingData: 'No spending data yet',
      AppStringKey.noSpendingDataMessage:
          'There are no expenses to analyze for this month.',
      AppStringKey.transactionNotFound: 'Transaction not found',
      AppStringKey.transactionNotFoundMessage:
          'This transaction may have been deleted or has not loaded yet.',
      AppStringKey.deleteTransactionTitle: 'Delete transaction?',
      AppStringKey.deleteTransactionMessage: 'This action cannot be undone.',
      AppStringKey.transactionAdded: 'Transaction added',
      AppStringKey.transactionUpdated: 'Transaction updated',
      AppStringKey.transactionDeleted: 'Transaction deleted',
      AppStringKey.couldNotLoadTransactions: 'Could not load transactions.',
      AppStringKey.couldNotLoadStatistics: 'Could not load statistics.',
      AppStringKey.couldNotLoadTransaction: 'Could not load transaction.',
      AppStringKey.couldNotDeleteTransaction: 'Could not delete transaction.',
      AppStringKey.couldNotAddTransaction: 'Could not add transaction.',
      AppStringKey.couldNotUpdateTransaction: 'Could not update transaction.',
      AppStringKey.exportCsv: 'Export CSV',
      AppStringKey.exportPdf: 'Export PDF',
      AppStringKey.backup: 'Backup',
      AppStringKey.exportCsvDescription:
          'Download the transaction list as a spreadsheet-friendly file.',
      AppStringKey.exportPdfDescription:
          'Generate a monthly income and expense report for sharing or storage.',
      AppStringKey.backupDescription:
          'Reserved for SQLite/Drift persistence follow-up phases.',
      AppStringKey.exportingCsv: 'Exporting...',
      AppStringKey.exportingPdf: 'Exporting...',
      AppStringKey.viewRoadmap: 'View roadmap',
      AppStringKey.comingSoon: 'Coming soon',
      AppStringKey.backupComingSoon: 'Data backup is in development',
      AppStringKey.csvExported: 'CSV exported',
      AppStringKey.pdfExported: 'PDF exported',
      AppStringKey.csvExportCancelled: 'CSV export cancelled.',
      AppStringKey.pdfExportCancelled: 'PDF export cancelled.',
      AppStringKey.csvExportUnsupported:
          'CSV export is not supported on this platform.',
      AppStringKey.pdfExportUnsupported:
          'PDF export is not supported on this platform.',
      AppStringKey.couldNotExportCsv: 'Could not export CSV. Please try again.',
      AppStringKey.couldNotExportPdf: 'Could not export PDF. Please try again.',
      AppStringKey.noTransactionsToExport:
          'There are no transactions to export.',
      AppStringKey.transactionsLoadingTryAgain:
          'Transaction data is still loading. Please try again.',
      AppStringKey.couldNotReadTransactions: 'Could not read transaction data.',
      AppStringKey.payLaterTitle: 'Pay Later & Installments',
      AppStringKey.payLaterSubtitle:
          'Track outstanding balances, minimum amounts due, and upcoming obligations inside the app.',
      AppStringKey.payLaterTracker: 'Pay Later tracker',
      AppStringKey.payLaterTrackerSubtitle:
          'Track installment plans and pay-later bills by recording payments inside the app.',
      AppStringKey.openPayLaterTracker: 'Open tracker',
      AppStringKey.totalOutstanding: 'Total outstanding',
      AppStringKey.minimumDue: 'Minimum due',
      AppStringKey.dueSoon: 'Due soon',
      AppStringKey.overdue: 'Overdue',
      AppStringKey.nextDue: 'Next due',
      AppStringKey.nextDueAmount: 'Due amount',
      AppStringKey.nextDueDate: 'Due date',
      AppStringKey.totalPaidThisMonth: 'Recorded this month',
      AppStringKey.installmentPlans: 'Installment plans',
      AppStringKey.payLaterInvoices: 'Pay later invoices',
      AppStringKey.policyNotes: 'Policy notes',
      AppStringKey.provider: 'Provider',
      AppStringKey.originalAmount: 'Original amount',
      AppStringKey.monthlyPayment: 'Monthly payment',
      AppStringKey.minimumPayment: 'Minimum payment',
      AppStringKey.paid: 'Paid',
      AppStringKey.outstanding: 'Outstanding',
      AppStringKey.statementMonth: 'Statement month',
      AppStringKey.statementDate: 'Statement date',
      AppStringKey.dueDate: 'Due date',
      AppStringKey.dueDayOfMonth: 'Monthly due day',
      AppStringKey.planTitle: 'Plan title',
      AppStringKey.totalInstallments: 'Total installments',
      AppStringKey.paidInstallments: 'Paid installments',
      AppStringKey.startDate: 'Start date',
      AppStringKey.installmentProgress: 'Installment progress',
      AppStringKey.remainingInstallments: 'Remaining installments',
      AppStringKey.addInstallmentPlan: 'Add installment plan',
      AppStringKey.editInstallmentPlan: 'Edit installment plan',
      AppStringKey.addPayLaterInvoice: 'Add pay later invoice',
      AppStringKey.editPayLaterInvoice: 'Edit pay later invoice',
      AppStringKey.recordPayment: 'Record payment',
      AppStringKey.payMinimum: 'Pay minimum',
      AppStringKey.payCustomAmount: 'Pay custom amount',
      AppStringKey.settleFullAmount: 'Settle full amount',
      AppStringKey.paymentAmount: 'Payment amount',
      AppStringKey.fieldRequired: 'Please enter a value',
      AppStringKey.invalidNumber: 'Invalid number',
      AppStringKey.dueDayRange: 'Due day must be between 1 and 31',
      AppStringKey.paidInstallmentsRange:
          'Paid installments cannot exceed the total installments',
      AppStringKey.paymentExceedsOutstanding:
          'Payment amount cannot exceed the remaining outstanding balance',
      AppStringKey.paymentDisclaimer:
          'This only records a payment inside the app and does not perform a real transaction.',
      AppStringKey.paymentRecorded: 'Payment recorded',
      AppStringKey.changesSaved: 'Changes saved',
      AppStringKey.deleteInstallmentPlanPrompt:
          'This installment plan will be removed from the tracker.',
      AppStringKey.deleteInvoicePrompt:
          'This pay later invoice will be removed from the tracker.',
      AppStringKey.statusActive: 'Tracking',
      AppStringKey.statusSettled: 'Settled',
      AppStringKey.statusCancelled: 'Cancelled',
      AppStringKey.statusUnpaid: 'Unpaid',
      AppStringKey.statusPartiallyPaid: 'Partially paid',
      AppStringKey.statusPaid: 'Paid',
      AppStringKey.noPayLaterItems: 'No pay later items yet',
      AppStringKey.noPayLaterItemsMessage:
          'Add an installment plan or pay later invoice to start tracking personal obligations.',
      AppStringKey.noInstallmentPlans: 'No installment plans yet',
      AppStringKey.noInstallmentPlansMessage:
          'Add an installment plan to track remaining balance and the next due cycle.',
      AppStringKey.noPayLaterInvoices: 'No pay later invoices yet',
      AppStringKey.noPayLaterInvoicesMessage:
          'Add a pay later invoice to track statements and minimum amounts due.',
      AppStringKey.noUpcomingDue: 'No upcoming dues yet',
      AppStringKey.couldNotLoadPayLater: 'Could not load pay later data.',
      AppStringKey.couldNotSaveInstallmentPlan:
          'Could not save installment plan.',
      AppStringKey.couldNotSaveInvoice: 'Could not save pay later invoice.',
      AppStringKey.couldNotDeleteInstallmentPlan:
          'Could not delete installment plan.',
      AppStringKey.couldNotDeleteInvoice: 'Could not delete pay later invoice.',
      AppStringKey.couldNotRecordPayment: 'Could not record payment.',
      AppStringKey.policyNoteMinimumTitle:
          'Minimum payment does not clear the full balance',
      AppStringKey.policyNoteMinimumDescription:
          'Minimum payment helps reduce overdue risk but does not clear the full outstanding balance.',
      AppStringKey.policyNoteSettlementTitle:
          'Settlement means paying the full remaining balance',
      AppStringKey.policyNoteSettlementDescription:
          'Settlement means paying the full remaining balance for the invoice or installment plan.',
      AppStringKey.policyNoteStatementTitle:
          'Statements summarize the current period',
      AppStringKey.policyNoteStatementDescription:
          'A statement summarizes charges, payments, and remaining balance for a period.',
      AppStringKey.policyNoteTrackingOnlyTitle: 'This app is for tracking only',
      AppStringKey.policyNoteTrackingOnlyDescription:
          'This app is for personal tracking only and does not replace official provider terms.',
      AppStringKey.policyNoteVerifyTermsTitle:
          'Verify terms with your provider',
      AppStringKey.policyNoteVerifyTermsDescription:
          'Always verify due dates and fees with your provider.',
      AppStringKey.language: 'Language',
      AppStringKey.vietnamese: 'Vietnamese',
      AppStringKey.english: 'English',
      AppStringKey.appearance: 'Appearance',
      AppStringKey.lightMode: 'Light',
      AppStringKey.darkMode: 'Dark',
      AppStringKey.systemMode: 'System',
      AppStringKey.preferencesSaved: 'Your preference has been saved',
      AppStringKey.savedLocally: 'Saved locally',
      AppStringKey.localPreferencesDescription:
          'Preferences are stored locally with shared_preferences.',
      AppStringKey.previousMonth: 'Previous month',
      AppStringKey.nextMonth: 'Next month',
      AppStringKey.today: 'Today',
      AppStringKey.yesterday: 'Yesterday',
    },
  };

  static const List<String> _englishMonthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String t(AppStringKey key) {
    return _values[locale]?[key] ?? _values[AppLocale.en]?[key] ?? key.name;
  }

  String monthYear(DateTime month) {
    return switch (locale) {
      AppLocale.vi => 'Tháng ${month.month} ${month.year}',
      AppLocale.en => '${_englishMonthNames[month.month - 1]} ${month.year}',
    };
  }

  String shortDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();

    return switch (locale) {
      AppLocale.vi => '$day/$month/$year',
      AppLocale.en => '$month/$day/$year',
    };
  }

  String relativeDate(DateTime date, {DateTime? now}) {
    final DateTime current = now ?? DateTime.now();
    final DateTime currentDay = DateTime(
      current.year,
      current.month,
      current.day,
    );
    final DateTime targetDay = DateTime(date.year, date.month, date.day);
    final int differenceInDays = currentDay.difference(targetDay).inDays;

    if (differenceInDays == 0) {
      return t(AppStringKey.today);
    }

    if (differenceInDays == 1) {
      return t(AppStringKey.yesterday);
    }

    return shortDate(date);
  }

  String trackingTransactions(int count) {
    return switch (locale) {
      AppLocale.vi => 'Đang theo dõi $count giao dịch',
      AppLocale.en => 'Tracking $count transactions',
    };
  }

  String activeFilterCount(int count) {
    return switch (locale) {
      AppLocale.vi => '$count bộ lọc',
      AppLocale.en => '$count filters',
    };
  }

  String topCategorySummary({required String amount, required int percent}) {
    return switch (locale) {
      AppLocale.vi => '$amount • $percent% tổng chi',
      AppLocale.en => '$amount • $percent% of total expense',
    };
  }
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocale.values.any(
      (AppLocale item) => item.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppStrings> load(Locale locale) {
    return SynchronousFuture<AppStrings>(
      AppStrings(AppLocale.fromLocale(locale)),
    );
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) {
    return false;
  }
}
