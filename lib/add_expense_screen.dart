import 'package:flutter/material.dart';

import 'wallet_flow_widgets.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _merchant = 'Netflix';
  String _amountDigits = '4800';
  DateTime _date = DateTime(2022, 2, 22);
  String? _paymentMethod;

  String get _amountText {
    final cents = int.tryParse(_amountDigits) ?? 0;
    return '\$ ${(cents / 100).toStringAsFixed(2)}';
  }

  String get _dateText {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[_date.weekday - 1]}, ${_date.day} ${months[_date.month - 1]} ${_date.year}';
  }

  void _tapDigit(String digit) {
    setState(() {
      if (_amountDigits == '0') {
        _amountDigits = digit;
      } else if (_amountDigits.length < 9) {
        _amountDigits += digit;
      }
    });
  }

  void _backspace() {
    setState(() {
      _amountDigits = _amountDigits.length <= 1
          ? '0'
          : _amountDigits.substring(0, _amountDigits.length - 1);
    });
  }

  Future<void> _pickMerchant() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Netflix', 'Spotify', 'Youtube', 'Paypal']
              .map(
                (name) => ListTile(
                  leading: _MerchantLogo(name: name),
                  title: Text(name),
                  trailing: _merchant == name
                      ? const Icon(Icons.check, color: walletTeal)
                      : null,
                  onTap: () => Navigator.of(context).pop(name),
                ),
              )
              .toList(),
        ),
      ),
    );

    if (selected != null) {
      setState(() => _merchant = selected);
    }
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selected != null) {
      setState(() => _date = selected);
    }
  }

  Future<void> _pickPaymentMethod() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Wallet', 'Visa • 8075', 'Paypal']
              .map(
                (name) => ListTile(
                  leading: const Icon(Icons.wallet, color: walletTeal),
                  title: Text(name),
                  trailing: _paymentMethod == name
                      ? const Icon(Icons.check, color: walletTeal)
                      : null,
                  onTap: () => Navigator.of(context).pop(name),
                ),
              )
              .toList(),
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() => _paymentMethod = selected);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$selected төлбөрийн хэрэгсэл сонгогдлоо')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: walletTeal,
      body: Column(
        children: [
          const WalletFlowHeader(
            title: 'Төлбөр нэмэх',
            showNotification: false,
            showMore: true,
          ),
          Expanded(
            child: Stack(
              children: [
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
                Positioned.fill(
                  bottom: 292,
                  child: WalletContentShell(
                    padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('ГҮЙЛГЭЭНИЙ НЭР'),
                        const SizedBox(height: 10),
                        _MerchantSelector(
                          merchant: _merchant,
                          onTap: _pickMerchant,
                        ),
                        const SizedBox(height: 24),
                        const _FieldLabel('ҮНИЙН ДҮН'),
                        const SizedBox(height: 10),
                        _AmountField(amount: _amountText),
                        const SizedBox(height: 24),
                        const _FieldLabel('ОГНОО'),
                        const SizedBox(height: 10),
                        _DateField(date: _dateText, onTap: _pickDate),
                        const SizedBox(height: 24),
                        const _FieldLabel('ТӨЛБӨР'),
                        const SizedBox(height: 10),
                        _DashedAddPayment(
                          label: _paymentMethod ?? 'Төлбөр нэмэх',
                          onTap: _pickPaymentMethod,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _NumberKeyboard(
                    onDigit: _tapDigit,
                    onBackspace: _backspace,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF777777),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _MerchantSelector extends StatelessWidget {
  final String merchant;
  final VoidCallback onTap;

  const _MerchantSelector({required this.merchant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDCDCDC)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            _MerchantLogo(name: merchant),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                merchant,
                style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8C8C8C)),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final String amount;

  const _AmountField({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: walletTeal, width: 1.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        amount,
        style: const TextStyle(
          color: walletTeal,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String date;
  final VoidCallback onTap;

  const _DateField({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDCDCDC)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date,
                style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF7E7E7E),
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedAddPayment extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DashedAddPayment({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle, color: Color(0xFF6F7072), size: 21),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF777777),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD8D8D8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const dash = 6.0;
    const gap = 5.0;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6)),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NumberKeyboard extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const _NumberKeyboard({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 292,
      color: const Color(0xFFD7DAE0),
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 12),
      child: Column(
        children: [
          Row(
            children: [
              _KeyCell(label: '1', onTap: () => onDigit('1')),
              _KeyCell(label: '2', letters: 'A B C', onTap: () => onDigit('2')),
              _KeyCell(label: '3', letters: 'D E F', onTap: () => onDigit('3')),
            ],
          ),
          Row(
            children: [
              _KeyCell(label: '4', letters: 'G H I', onTap: () => onDigit('4')),
              _KeyCell(label: '5', letters: 'J K L', onTap: () => onDigit('5')),
              _KeyCell(label: '6', letters: 'M N O', onTap: () => onDigit('6')),
            ],
          ),
          Row(
            children: [
              _KeyCell(
                label: '7',
                letters: 'P Q R S',
                onTap: () => onDigit('7'),
              ),
              _KeyCell(label: '8', letters: 'T U V', onTap: () => onDigit('8')),
              _KeyCell(
                label: '9',
                letters: 'W X Y Z',
                onTap: () => onDigit('9'),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Text('+*#', style: TextStyle(fontSize: 22)),
                  ),
                ),
                _KeyCell(label: '0', compact: true, onTap: () => onDigit('0')),
                Expanded(
                  child: GestureDetector(
                    onTap: onBackspace,
                    child: const Center(
                      child: Icon(Icons.backspace_outlined, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 134,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyCell extends StatelessWidget {
  final String label;
  final String? letters;
  final bool compact;
  final VoidCallback onTap;

  const _KeyCell({
    required this.label,
    required this.onTap,
    this.letters,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final key = GestureDetector(
      onTap: onTap,
      child: Container(
        height: compact ? 46 : 46,
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                height: 0.95,
              ),
            ),
            if (letters != null)
              Text(
                letters!,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
          ],
        ),
      ),
    );

    if (compact) {
      return Expanded(child: key);
    }
    return Expanded(child: key);
  }
}

class _MerchantLogo extends StatelessWidget {
  final String name;

  const _MerchantLogo({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();
    final isNetflix = name == 'Netflix';
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isNetflix ? Colors.black : walletTeal.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: isNetflix ? const Color(0xFFE50914) : walletTeal,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
