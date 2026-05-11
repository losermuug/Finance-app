import 'package:flutter/material.dart';
import 'package:lab/core/app_colors.dart';

import '../../../data/models/finance_transaction.dart';
import '../../../shared/widgets/transaction_stream_list.dart';
import '../../../bill_flow_screens.dart';

class WalletTransactionList extends StatelessWidget {
  const WalletTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionStreamList(
      padding: EdgeInsets.symmetric(horizontal: 20),
      limit: 30,
    );
  }
}

class WalletPendingList extends StatelessWidget {
  const WalletPendingList({super.key});

  @override
  Widget build(BuildContext context) {
    return TransactionStreamList(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      status: FinanceTransactionStatus.pending,
      limit: 30,
      trailingBuilder: (context, transaction) =>
          _OpenBillButton(transaction: transaction),
    );
  }
}

class _OpenBillButton extends StatelessWidget {
  final FinanceTransaction transaction;

  const _OpenBillButton({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BillDetailsScreen(transaction: transaction),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.teal.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
        ),
        child: const Text(
          'Төлөх',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
