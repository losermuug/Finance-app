import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../data/models/finance_transaction.dart';
import '../../../data/repositories/finance_repository.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FinanceTransaction>>(
      stream: FinanceRepository.instance.watchTransactions(
        limit: 100,
        status: FinanceTransactionStatus.completed,
      ),
      builder: (context, snapshot) {
        final transactions = snapshot.data ?? const <FinanceTransaction>[];
        final income = transactions
            .where((transaction) => transaction.amountCents > 0)
            .fold<int>(0, (sum, transaction) => sum + transaction.amountCents);
        final expense = transactions
            .where((transaction) => transaction.amountCents < 0)
            .fold<int>(
              0,
              (sum, transaction) => sum + transaction.amountCents.abs(),
            );
        final balance = income - expense;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.tealDark,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BalanceHeader(),
              const SizedBox(height: 8),
              Text(
                '\$ ${(balance / 100).toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _BalanceMetric(
                      icon: Icons.arrow_downward,
                      label: 'Орлого',
                      amount: '\$ ${(income / 100).toStringAsFixed(2)}',
                    ),
                  ),
                  Expanded(
                    child: _BalanceMetric(
                      icon: Icons.arrow_upward,
                      label: 'Зарлага',
                      amount: '\$ ${(expense / 100).toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  const _BalanceHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Нийт үлдэгдэл',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white.withValues(alpha: 0.85),
              size: 18,
            ),
          ],
        ),
        Icon(Icons.more_horiz, color: Colors.white.withValues(alpha: 0.85)),
      ],
    );
  }
}

class _BalanceMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;

  const _BalanceMetric({
    required this.icon,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 16)),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
