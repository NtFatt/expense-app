import 'package:expense_app/core/utils/currency_formatter.dart';
import 'package:expense_app/features/transactions/domain/transaction_model.dart';
import 'package:flutter/material.dart';

class FilteredTransactionsSummary extends StatelessWidget {
  const FilteredTransactionsSummary({
    super.key,
    required this.transactions,
  });

  final List<TransactionModel> transactions;

  int get _totalIncome {
    return transactions
        .where((TransactionModel t) => t.isIncome)
        .fold<int>(0, (int total, TransactionModel t) => total + t.amount);
  }

  int get _totalExpense {
    return transactions
        .where((TransactionModel t) => t.isExpense)
        .fold<int>(0, (int total, TransactionModel t) => total + t.amount);
  }

  int get _balance => _totalIncome - _totalExpense;

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
              _SummaryCell(
                title: 'Tổng số giao dịch',
                value: transactions.length.toString(),
                icon: Icons.receipt_long_rounded,
                accentColor: const Color(0xFF2563EB),
              ),
              _SummaryCell(
                title: 'Số dư',
                value: formatCurrency(_balance, withSign: false),
                icon: Icons.account_balance_wallet_rounded,
                accentColor: const Color(0xFF7C3AED),
              ),
              _SummaryCell(
                title: 'Tổng thu',
                value: formatCurrency(_totalIncome, withSign: false),
                icon: Icons.south_west_rounded,
                accentColor: const Color(0xFF16A34A),
              ),
              _SummaryCell(
                title: 'Tổng chi',
                value: formatCurrency(_totalExpense, withSign: false),
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

class _SummaryCell extends StatelessWidget {
  const _SummaryCell({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
