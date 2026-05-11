import 'package:flutter/material.dart';

const walletTeal = Color(0xFF3A9E94);
const walletDarkText = Color(0xFF2B2B2B);
const walletMutedText = Color(0xFF8A8A8A);

class WalletFlowHeader extends StatelessWidget {
  final String title;
  final bool showNotification;
  final bool showMore;

  const WalletFlowHeader({
    super.key,
    required this.title,
    this.showNotification = true,
    this.showMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      width: double.infinity,
      decoration: const BoxDecoration(color: walletTeal),
      child: Stack(
        children: [
          Positioned(
            left: -52,
            top: -18,
            child: _HeaderRing(size: 220, opacity: 0.08),
          ),
          Positioned(
            left: 58,
            top: -10,
            child: _HeaderRing(size: 112, opacity: 0.08),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: showMore
                        ? const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 28,
                          )
                        : showNotification
                        ? const _NotificationButton()
                        : const SizedBox.shrink(),
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

class WalletContentShell extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool scrollable;

  const WalletContentShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(32, 30, 32, 0),
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: scrollable ? SingleChildScrollView(child: content) : content,
    );
  }
}

class WalletSegmentedTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const WalletSegmentedTabs({
    super.key,
    required this.selectedIndex,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 7,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(children: [_tab('Картууд', 0), _tab('Аккаунт', 1)]),
        ],
      ),
    );
  }

  Widget _tab(String text, int index) {
    final selected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: selected ? null : () => onChanged?.call(index),
        child: Container(
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF666666)
                  : const Color(0xFF777777),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

class WalletBottomNavBar extends StatelessWidget {
  const WalletBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _BottomIcon(Icons.home_outlined),
              _BottomIcon(Icons.bar_chart_rounded),
              _BottomIcon(Icons.wallet, active: true),
              _BottomIcon(Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryOutlineButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: walletTeal,
          side: const BorderSide(color: walletTeal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class PrimaryFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryFilledButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: walletTeal,
          foregroundColor: Colors.white,
          elevation: 10,
          shadowColor: walletTeal.withValues(alpha: 0.26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 26,
            ),
          ),
          Positioned(
            top: 10,
            right: 11,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFF9D60),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  const _BottomIcon(this.icon, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: active ? walletTeal : const Color(0xFFA7A8AA),
      size: 31,
    );
  }
}

class _HeaderRing extends StatelessWidget {
  final double size;
  final double opacity;

  const _HeaderRing({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: opacity),
          width: 10,
        ),
      ),
    );
  }
}
