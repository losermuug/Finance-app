import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class TransactionListItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final String? amount;
  final bool isIncome;
  final Widget? trailing;

  const TransactionListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.amount,
    this.isIncome = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          trailing ?? _AmountText(amount: amount ?? '', isIncome: isIncome),
        ],
      ),
    );
  }
}

class _AmountText extends StatelessWidget {
  final String amount;
  final bool isIncome;

  const _AmountText({required this.amount, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Text(
      amount,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isIncome ? AppColors.teal : AppColors.danger,
      ),
    );
  }
}
