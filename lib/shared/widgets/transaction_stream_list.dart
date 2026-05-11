import 'package:flutter/material.dart';

import '../../data/models/finance_transaction.dart';
import '../../data/repositories/finance_repository.dart';
import 'brand_icon.dart';
import 'transaction_list_item.dart';

class TransactionStreamList extends StatelessWidget {
  final EdgeInsets padding;
  final int limit;
  final String status;
  final Widget Function(BuildContext, FinanceTransaction)? trailingBuilder;

  const TransactionStreamList({
    super.key,
    this.padding = EdgeInsets.zero,
    this.limit = 20,
    this.status = FinanceTransactionStatus.completed,
    this.trailingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FinanceTransaction>>(
      stream: FinanceRepository.instance.watchTransactions(
        limit: limit,
        status: status,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _TransactionError(error: snapshot.error);
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data!;
        if (transactions.isEmpty) {
          return const Center(child: Text('Одоогоор гүйлгээ алга'));
        }

        return ListView.builder(
          padding: padding,
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return TransactionListItem(
              icon: BrandIcon(type: brandIconTypeFromKey(transaction.iconKey)),
              title: transaction.title,
              subtitle: transaction.subtitle,
              amount: transaction.amountText,
              isIncome: transaction.isIncome,
              trailing: trailingBuilder?.call(context, transaction),
            );
          },
        );
      },
    );
  }
}

class _TransactionError extends StatelessWidget {
  final Object? error;

  const _TransactionError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Firestore алдаа:\n$error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
      ),
    );
  }
}
