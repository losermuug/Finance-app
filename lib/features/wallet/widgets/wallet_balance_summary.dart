import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../data/repositories/finance_repository.dart';

class WalletBalanceSummary extends StatelessWidget {
  const WalletBalanceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: FinanceRepository.instance.watchCompletedBalanceCents(),
      builder: (context, snapshot) {
        final balanceCents = snapshot.data ?? 0;

        return Column(
          children: [
            Text(
              'Нийт үлдэгдэл',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '\$ ${(balanceCents / 100).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
          ],
        );
      },
    );
  }
}
