import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:expense_app/shared/widgets/metric_card.dart';
import 'package:flutter/material.dart';

class TransactionSummaryPanel extends StatelessWidget {
  const TransactionSummaryPanel({super.key, required this.state});

  final TransactionState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tóm tắt nhanh',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Theo dõi số lượng giao dịch và tác động tới số dư hiện tại.',
            style: TextStyle(color: Color(0xFF64748B), height: 1.4),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              MetricCard(
                title: 'Tổng số giao dịch',
                value: state.totalTransactions.toString(),
                icon: Icons.receipt_long_rounded,
                accentColor: const Color(0xFF2563EB),
              ),
              MetricCard(
                title: 'Số dư',
                value: formatCurrency(state.balance, withSign: false),
                icon: Icons.account_balance_wallet_rounded,
                accentColor: const Color(0xFF7C3AED),
              ),
              MetricCard(
                title: 'Tổng thu',
                value: formatCurrency(state.totalIncome, withSign: false),
                icon: Icons.south_west_rounded,
                accentColor: const Color(0xFF16A34A),
              ),
              MetricCard(
                title: 'Tổng chi',
                value: formatCurrency(state.totalExpense, withSign: false),
                icon: Icons.north_east_rounded,
                accentColor: const Color(0xFFEA580C),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
