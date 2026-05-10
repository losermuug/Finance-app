import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'wallet_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const _PlaceholderScreen(title: 'Статистик'),
    const WalletScreen(),
    const _PlaceholderScreen(title: 'Профайл'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home, 0),
                _navItem(Icons.bar_chart, 1),
                _navItem(Icons.wallet, 2),
                _navItem(Icons.person_outline, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3A9E94).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF3A9E94) : Colors.grey[400],
          size: 26,
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
      ),
    );
  }
}
