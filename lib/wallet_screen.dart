import 'package:flutter/material.dart';

import 'add_expense_screen.dart';
import 'connect_wallet_screen.dart';
import 'core/app_colors.dart';
import 'features/wallet/widgets/wallet_action_button.dart';
import 'features/wallet/widgets/wallet_balance_summary.dart';
import 'features/wallet/widgets/wallet_header.dart';
import 'features/wallet/widgets/wallet_transaction_lists.dart';
import 'features/wallet/widgets/wallet_transaction_tabs.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAddExpense() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
  }

  void _openWalletTopUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ConnectWalletScreen(initialTab: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.teal,
      body: Column(
        children: [
          const WalletHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const WalletBalanceSummary(),
                    const SizedBox(height: 28),
                    _WalletActions(
                      onAdd: _openWalletTopUp,
                      onPay: _openAddExpense,
                    ),
                    const SizedBox(height: 28),
                    WalletTransactionTabs(controller: _tabController),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          const WalletTransactionList(),
                          const WalletPendingList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletActions extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onPay;

  const _WalletActions({required this.onAdd, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WalletActionButton(icon: Icons.add, label: 'Нэмэх', onTap: onAdd),
        const SizedBox(width: 40),
        WalletActionButton(
          icon: Icons.qr_code_scanner,
          label: 'Төлбөр',
          onTap: onPay,
        ),
      ],
    );
  }
}
