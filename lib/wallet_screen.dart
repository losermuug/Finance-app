import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A9E94),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Нийт үлдэгдэл',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$ 2,548.00',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildActions(),
                    const SizedBox(height: 28),
                    _buildTabs(),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [_txList(), _pendingList()],
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

  Widget _buildHeader(BuildContext ctx) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF3A9E94),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Text(
                'Түрийвч',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B6B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionBtn(Icons.add, 'Нэмэх'),
        const SizedBox(width: 40),
        _actionBtn(Icons.qr_code_scanner, 'Төлбөр'),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    const c = Color(0xFF3A9E94);
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: c.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.withOpacity(0.3)),
          ),
          child: Center(child: Icon(icon, color: c, size: 26)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: const Color(0xFF333333),
        unselectedLabelColor: Colors.grey[500],
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Гүйлгээнүүд'),
          Tab(text: 'Хүлээгдэж буй гүйлгээ'),
        ],
      ),
    );
  }

  Widget _txList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _txItem(_upwork(), 'Upwork', 'Today', '+ \$ 850.00', true),
        _txItem(_avatar(), 'Transfer', 'Yesterday', '- \$ 85.00', false),
        _txItem(_paypal(), 'Paypal', 'Jan 30, 2022', '+ \$ 1,406.00', true),
        _txItem(_youtube(), 'Youtube', 'Jan 16, 2022', '- \$ 11.99', false),
      ],
    );
  }

  Widget _pendingList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _pendItem(_youtube(), 'Youtube', 'Feb 28, 2022'),
        _pendItem(_elec(), 'Electricity', 'Mar 28, 2022'),
        _pendItem(_house(), 'House Rent', 'Mar 31, 2022'),
        _pendItem(_spotify(), 'Spotify', 'Feb 28, 2022'),
      ],
    );
  }

  Widget _txItem(Widget icon, String t, String s, String a, bool inc) {
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
                  t,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Text(
            a,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: inc ? const Color(0xFF3A9E94) : const Color(0xFFFF6B6B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pendItem(Widget icon, String t, String s) {
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
                  t,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF3A9E94).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF3A9E94).withOpacity(0.3),
              ),
            ),
            child: const Text(
              'Төлөх',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF3A9E94),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(Color bg, Widget child) => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Center(child: child),
  );
  Widget _upwork() => _icon(
    const Color(0xFF6FDA44),
    const Text(
      'Up',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
  Widget _avatar() => _icon(
    const Color(0xFFE8E8E8),
    const Icon(Icons.person, color: Color(0xFF888888), size: 24),
  );
  Widget _paypal() => _icon(
    const Color(0xFF003087),
    const Text(
      'P',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  );
  Widget _youtube() => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: const Center(
      child: Icon(Icons.play_circle_fill, color: Color(0xFFFF0000), size: 26),
    ),
  );
  Widget _elec() => _icon(
    const Color(0xFFFFF3E0),
    const Icon(Icons.bolt, color: Color(0xFFFF9800), size: 26),
  );
  Widget _house() => _icon(
    const Color(0xFFE3F2FD),
    const Icon(Icons.home, color: Color(0xFF1976D2), size: 24),
  );
  Widget _spotify() => _icon(
    const Color(0xFF1DB954),
    const Icon(Icons.music_note, color: Colors.white, size: 24),
  );
}
