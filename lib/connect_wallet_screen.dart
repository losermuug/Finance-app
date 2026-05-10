import 'package:flutter/material.dart';

import 'wallet_flow_widgets.dart';

class ConnectWalletScreen extends StatefulWidget {
  final int initialTab;

  const ConnectWalletScreen({super.key, this.initialTab = 1});

  @override
  State<ConnectWalletScreen> createState() => _ConnectWalletScreenState();
}

class _ConnectWalletScreenState extends State<ConnectWalletScreen> {
  late int _selectedTab;
  String _selectedMethod = 'Bank Link';

  final _nameController = TextEditingController(text: 'Davaasuren Nyamjav');
  final _numberController = TextEditingController();
  final _cvcController = TextEditingController();
  final _expiryController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab == 0 ? 0 : 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _cvcController.dispose();
    _expiryController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _continueAccount() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$_selectedMethod сонгогдлоо')));
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty ||
        _numberController.text.trim().isEmpty ||
        _cvcController.text.trim().isEmpty ||
        _expiryController.text.trim().isEmpty ||
        _valueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Картны бүх мэдээллээ бөглөнө үү')),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Карт амжилттай нэмэгдлээ')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: walletTeal,
      bottomNavigationBar: const WalletBottomNavBar(),
      body: Column(
        children: [
          WalletFlowHeader(
            title: _selectedTab == 0 ? 'Түрийвч цэнэглэх' : 'Түрийвчтэй холбох',
          ),
          Expanded(
            child: WalletContentShell(
              scrollable: false,
              padding: const EdgeInsets.fromLTRB(34, 30, 34, 12),
              child: Column(
                crossAxisAlignment: _selectedTab == 0
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  WalletSegmentedTabs(
                    selectedIndex: _selectedTab,
                    onChanged: (index) => setState(() => _selectedTab = index),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          final offsetAnimation =
                              Tween<Offset>(
                                begin: const Offset(0.04, 0),
                                end: Offset.zero,
                              ).animate(animation);
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey(_selectedTab),
                          child: _selectedTab == 0
                              ? _buildCardTab()
                              : _buildAccountTab(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PrimaryOutlineButton(
                    label: _selectedTab == 0 ? 'ИЛГЭЭХ' : 'ДАРААХ',
                    onPressed: _selectedTab == 0 ? _submit : _continueAccount,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTab() {
    return Column(
      children: [
        const SizedBox(height: 30),
        _ConnectOption(
          title: 'Bank Link',
          subtitle: 'Connect your bank\naccount to deposit & fund',
          icon: Icons.account_balance,
          selected: _selectedMethod == 'Bank Link',
          onTap: () => setState(() => _selectedMethod = 'Bank Link'),
        ),
        const SizedBox(height: 16),
        _ConnectOption(
          title: 'Microdeposits',
          subtitle: 'Connect bank in 5-7 days',
          icon: Icons.attach_money,
          selected: _selectedMethod == 'Microdeposits',
          onTap: () => setState(() => _selectedMethod = 'Microdeposits'),
        ),
        const SizedBox(height: 16),
        _ConnectOption(
          title: 'Paypal',
          subtitle: 'Connect you paypal account',
          icon: Icons.paypal,
          selected: _selectedMethod == 'Paypal',
          onTap: () => setState(() => _selectedMethod = 'Paypal'),
        ),
      ],
    );
  }

  Widget _buildCardTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: _CreditCardPreview(
            name: _nameController.text,
            number: _numberController.text,
            expiry: _expiryController.text,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Картны мэдээллээ нэмэх',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Энд холбох карт нь зөвхөн таны нэр дээр\nбайх ёстой.',
          style: TextStyle(
            color: Color(0xFF737373),
            fontSize: 13,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 14),
        _LabeledField(
          label: 'КАРТ ДЭЭРХ НЭР',
          controller: _nameController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _SmallField(
                label: 'КАРТЫН ДУГААР',
                controller: _numberController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _SmallField(
                label: 'CVC',
                controller: _cvcController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _SmallField(
                label: 'ДУУСАХ ХУГАЦАА  YYYY/MM',
                controller: _expiryController,
                keyboardType: TextInputType.datetime,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _SmallField(
                label: 'Value \$',
                controller: _valueController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConnectOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _ConnectOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? walletTeal : const Color(0xFF8C8D8F);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F1F0) : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: selected
                          ? const Color(0xFF227A73)
                          : walletMutedText,
                      fontSize: 13,
                      height: 1.12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: walletTeal, size: 26),
          ],
        ),
      ),
    );
  }
}

class _CreditCardPreview extends StatelessWidget {
  final String name;
  final String number;
  final String expiry;

  const _CreditCardPreview({
    required this.name,
    required this.number,
    required this.expiry,
  });

  String get _displayName {
    final text = name.trim();
    return text.isEmpty ? 'CARD HOLDER' : text.toUpperCase();
  }

  String get _displayNumber {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '6 2 1 9      8 6 1 0      2 8 8 8      8 0 7 5';
    }
    final padded = digits.padRight(16, '•').substring(0, 16);
    return padded
        .replaceAllMapped(RegExp(r'.{4}'), (match) => match.group(0)!)
        .split('')
        .join(' ')
        .replaceAll('        ', '      ');
  }

  String get _displayExpiry {
    final text = expiry.trim();
    return text.isEmpty ? '22/01' : text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 238,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 282,
              height: 170,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF16B6A8), Color(0xFF64E8C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.fromLTRB(24, 14, 22, 0),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VISA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'Mono',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 34,
            child: Container(
              width: 322,
              height: 208,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF178B83), Color(0xFF00B4A9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Stack(
                children: [
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Text(
                      'Mono',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    top: 0,
                    child: Text(
                      'Debit\nCard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 47,
                    child: Container(
                      width: 26,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6DAD4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        size: 17,
                        color: Color(0xFF9B9F98),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(painter: _CardArcPainter()),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 34,
                    child: Text(
                      _displayNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 8,
                    child: Text(
                      _displayName,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 8,
                    child: Text(
                      _displayExpiry,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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

class _CardArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = Colors.white.withValues(alpha: 0.10);
    final center = Offset(size.width * 0.50, size.height + 10);
    for (var radius = 26.0; radius < 152; radius += 17) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const _LabeledField({
    required this.label,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 55,
          width: double.infinity,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDADADA)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: walletTeal, width: 1.2),
              ),
            ),
            style: const TextStyle(
              color: walletTeal,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          top: -9,
          left: 14,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF8E8E8E), fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _SmallField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDADADA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: walletTeal, width: 1.2),
          ),
        ),
        style: const TextStyle(color: walletTeal, fontSize: 12),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
