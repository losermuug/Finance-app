import 'package:flutter/material.dart';

import 'core/app_colors.dart';
import 'features/home/widgets/balance_card.dart';
import 'features/home/widgets/home_header.dart';
import 'features/home/widgets/transaction_history_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          HomeHeader(),
          Positioned(top: 150, left: 20, right: 20, child: BalanceCard()),
          Padding(
            padding: EdgeInsets.only(top: 340),
            child: TransactionHistorySection(),
          ),
        ],
      ),
    );
  }
}
