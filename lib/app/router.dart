import 'package:expense_app/features/reports/presentation/pages/reports_page.dart';
import 'package:expense_app/features/statistics/presentation/pages/statistics_page.dart';
import 'package:expense_app/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:expense_app/features/transactions/presentation/pages/dashboard_page.dart';
import 'package:expense_app/features/transactions/presentation/pages/edit_transaction_page.dart';
import 'package:expense_app/features/transactions/presentation/pages/transactions_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => const TransactionsPage(),
    ),
    GoRoute(
      path: '/transactions/new',
      builder: (context, state) => const AddTransactionPage(),
    ),
    GoRoute(
      path: '/transactions/:id/edit',
      builder: (context, state) =>
          EditTransactionPage(transactionId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => const StatisticsPage(),
    ),
    GoRoute(path: '/reports', builder: (context, state) => const ReportsPage()),
  ],
);
