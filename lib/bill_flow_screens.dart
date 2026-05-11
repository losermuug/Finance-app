import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'data/models/finance_transaction.dart';
import 'data/repositories/finance_repository.dart';
import 'wallet_flow_widgets.dart';

enum BillPaymentMethod { card, wallet }

extension BillPaymentMethodLabel on BillPaymentMethod {
  String get label => switch (this) {
    BillPaymentMethod.card => 'Дебит карт',
    BillPaymentMethod.wallet => 'Түрийвч',
  };

  IconData get icon => switch (this) {
    BillPaymentMethod.card => Icons.credit_card,
    BillPaymentMethod.wallet => Icons.paypal,
  };
}

class BillDetailsScreen extends StatefulWidget {
  final FinanceTransaction transaction;

  const BillDetailsScreen({super.key, required this.transaction});

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  BillPaymentMethod _method = BillPaymentMethod.card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: walletTeal,
      bottomNavigationBar: const WalletBottomNavBar(),
      body: Column(
        children: [
          const WalletFlowHeader(
            title: 'Bill Details',
            showNotification: false,
            showMore: true,
          ),
          Expanded(
            child: WalletContentShell(
              scrollable: false,
              padding: const EdgeInsets.fromLTRB(28, 30, 28, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _BillHeader(transaction: widget.transaction),
                          const SizedBox(height: 38),
                          _BillSummary(transaction: widget.transaction),
                          const SizedBox(height: 36),
                          const Text(
                            'Төлбөрийн хэрэгслээ сонго',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _PaymentMethodTile(
                            method: BillPaymentMethod.card,
                            selected: _method == BillPaymentMethod.card,
                            onTap: () => setState(
                              () => _method = BillPaymentMethod.card,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _PaymentMethodTile(
                            method: BillPaymentMethod.wallet,
                            selected: _method == BillPaymentMethod.wallet,
                            onTap: () => setState(
                              () => _method = BillPaymentMethod.wallet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryFilledButton(
                    label: 'Төлөх',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BillPaymentScreen(
                          method: _method,
                          transaction: widget.transaction,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BillPaymentScreen extends StatefulWidget {
  final BillPaymentMethod method;
  final FinanceTransaction transaction;

  const BillPaymentScreen({
    super.key,
    required this.method,
    required this.transaction,
  });

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  bool _isSubmitting = false;

  Future<void> _confirmPayment() async {
    setState(() => _isSubmitting = true);
    try {
      final qrPayload = _buildQrPayload(widget.transaction, widget.method);
      await FinanceRepository.instance.completePendingTransaction(
        widget.transaction,
        paymentMethod: widget.method.label,
        qrPayload: qrPayload,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BillPaymentSuccessScreen(
            method: widget.method,
            transaction: widget.transaction,
            qrPayload: qrPayload,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Төлбөр хадгалахад алдаа гарлаа: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: walletTeal,
      bottomNavigationBar: const WalletBottomNavBar(),
      body: Column(
        children: [
          const WalletFlowHeader(
            title: 'Bill Payment',
            showNotification: false,
            showMore: true,
          ),
          Expanded(
            child: WalletContentShell(
              scrollable: false,
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _BillIcon(transaction: widget.transaction, size: 80),
                          const SizedBox(height: 20),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                height: 1.45,
                              ),
                              children: [
                                const TextSpan(text: 'You will pay '),
                                TextSpan(
                                  text: widget.transaction.title,
                                  style: TextStyle(
                                    color: walletTeal,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '\nfor one month with ${widget.method.label}',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 54),
                          _BillSummary(transaction: widget.transaction),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryFilledButton(
                    label: _isSubmitting
                        ? 'БАТАЛГААЖУУЛЖ БАЙНА...'
                        : 'Баталгаажуулах',
                    onPressed: _isSubmitting ? null : _confirmPayment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BillPaymentSuccessScreen extends StatelessWidget {
  final BillPaymentMethod method;
  final FinanceTransaction transaction;
  final String qrPayload;

  const BillPaymentSuccessScreen({
    super.key,
    required this.method,
    required this.transaction,
    required this.qrPayload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: walletTeal,
      bottomNavigationBar: const WalletBottomNavBar(),
      body: Column(
        children: [
          const WalletFlowHeader(
            title: 'Bill Payment',
            showNotification: false,
            showMore: true,
          ),
          Expanded(
            child: WalletContentShell(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 16),
              child: Column(
                children: [
                  const Text(
                    'Амжилттай Төлөгдлөө',
                    style: TextStyle(
                      color: walletTeal,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: walletTeal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Гүйлгээний дэлгэрэнгүй',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_up),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _ReceiptRow('Төлбөрийн хэрэгсэл', method.label),
                  const _ReceiptRow(
                    'Төлөв',
                    'Хийгдсэн',
                    valueColor: walletTeal,
                  ),
                  _ReceiptRow('Цаг', _timeText(DateTime.now())),
                  _ReceiptRow('Огноо', transaction.subtitle),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Гүйлгээний дугаар',
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        _shortId(transaction.id),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.copy, color: walletTeal, size: 17),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _BillSummary(transaction: transaction, compact: true),
                  const SizedBox(height: 18),
                  QrImageView(
                    data: qrPayload,
                    version: QrVersions.auto,
                    size: 92,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 28),
                  PrimaryOutlineButton(
                    label: 'Share Receipt',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Receipt share бэлэн')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillHeader extends StatelessWidget {
  final FinanceTransaction transaction;

  const _BillHeader({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _BillIcon(transaction: transaction, size: 80),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              transaction.subtitle,
              style: const TextStyle(color: Color(0xFF777777), fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class _BillIcon extends StatelessWidget {
  final FinanceTransaction transaction;
  final double size;

  const _BillIcon({required this.transaction, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: size * 0.42,
          height: size * 0.30,
          decoration: BoxDecoration(
            color: transaction.iconKey == 'youtube'
                ? const Color(0xFFE52D27)
                : walletTeal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            transaction.iconKey == 'youtube' ? Icons.play_arrow : Icons.receipt,
            color: Colors.white,
            size: size * 0.22,
          ),
        ),
      ),
    );
  }
}

class _BillSummary extends StatelessWidget {
  final FinanceTransaction transaction;
  final bool compact;

  const _BillSummary({required this.transaction, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow('Үнэ', transaction.amountText.replaceFirst('-', '')),
        const SizedBox(height: 12),
        _SummaryRow('Хураамж', '\$ 0.00'),
        const SizedBox(height: 18),
        const Divider(height: 1),
        const SizedBox(height: 18),
        _SummaryRow(
          'Нийт',
          transaction.amountText.replaceFirst('-', ''),
          bold: true,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? const Color(0xFF666666) : const Color(0xFF777777),
            fontSize: 16,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final BillPaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F1F0) : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                method.icon,
                color: selected ? walletTeal : const Color(0xFF8B8C8E),
                size: 32,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                method.label,
                style: TextStyle(
                  color: selected ? walletTeal : const Color(0xFF8B8C8E),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? walletTeal : const Color(0xFF777777),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ReceiptRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF777777), fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

String _buildQrPayload(
  FinanceTransaction transaction,
  BillPaymentMethod method,
) {
  return jsonEncode({
    'transactionId': transaction.id,
    'title': transaction.title,
    'amountCents': transaction.amountCents.abs(),
    'paymentMethod': method.label,
    'paidAt': DateTime.now().toIso8601String(),
  });
}

String _shortId(String id) {
  if (id.length <= 12) return id;
  return '${id.substring(0, 12)}..';
}

String _timeText(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
