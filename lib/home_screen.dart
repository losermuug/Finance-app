import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Green header background
          Container(
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              color: Color(0xFF3A9E94),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Өглөөний мэнд?',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Н.Даваа',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
          ),
          // Balance card overlapping header
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2D7A72),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Нийт үлдэгдэл',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white.withOpacity(0.85),
                            size: 18,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$ 2,548.00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(Icons.arrow_downward, color: Colors.white, size: 16),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Орлого', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
                                const SizedBox(height: 2),
                                const Text('\$ 1,840.00', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(Icons.arrow_upward, color: Colors.white, size: 16),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Зарлага', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
                                const SizedBox(height: 2),
                                const Text('\$ 284.00', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Transaction history below the card
          Padding(
            padding: const EdgeInsets.only(top: 340),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Гүйлгээний Түүх',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        'Бүгдийг харах',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildTransactionItem(
                          icon: _buildUpworkIcon(),
                          title: 'Upwork',
                          subtitle: 'Өнөөдөр',
                          amount: '+ \$ 850.00',
                          isIncome: true,
                        ),
                        _buildTransactionItem(
                          icon: _buildAvatarIcon(),
                          title: 'Шилжүүлэг',
                          subtitle: 'Өчигдөр',
                          amount: '- \$ 85.00',
                          isIncome: false,
                        ),
                        _buildTransactionItem(
                          icon: _buildPaypalIcon(),
                          title: 'Paypal',
                          subtitle: 'Jan 30, 2022',
                          amount: '+ \$ 1,406.00',
                          isIncome: true,
                        ),
                        _buildTransactionItem(
                          icon: _buildYoutubeIcon(),
                          title: 'Youtube',
                          subtitle: 'Jan 16, 2022',
                          amount: '- \$ 11.99',
                          isIncome: false,
                        ),
                      ],
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

  Widget _buildTransactionItem({
    required Widget icon,
    required String title,
    required String subtitle,
    required String amount,
    required bool isIncome,
  }) {
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
                    color: Color(0xFF333333),
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
          Text(
            amount,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isIncome ? const Color(0xFF3A9E94) : const Color(0xFFFF6B6B),
            ),
          ),
        ],
      ),
    );
  }

  // Custom brand icons
  Widget _buildUpworkIcon() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF6FDA44),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Text(
          'Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarIcon() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Icon(Icons.person, color: Color(0xFF888888), size: 24),
      ),
    );
  }

  Widget _buildPaypalIcon() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF003087),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildYoutubeIcon() {
    return Container(
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
  }
}
