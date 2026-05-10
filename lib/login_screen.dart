import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'main_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F5),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF3A9E94),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -60,
                  left: -60,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4DB6AC).withOpacity(0.4),
                    ),
                  ),
                ),
                Positioned(
                  top: -80,
                  left: 20,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                ),
                Center(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text(
                        'Тавтай морилно уу !',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Illustration
          Container(
            width: double.infinity,
            height: 180,
            color: Colors.white,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Image.asset(
                  'public/undraw_done_checking_re_6vyx 1.png',
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Form
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Enter your email address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Enter your password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscure: _obscurePassword,
                        onToggle: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const MainNavScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A9E94),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                            shadowColor: const Color(
                              0xFF3A9E94,
                            ).withOpacity(0.4),
                          ),
                          child: const Text(
                            'Нэвтрэх',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Бүртгүүлэх',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Бүртгүүлэх',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF3A9E94),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCard({
    required bool hasCheckmark,
    required bool isHighlighted,
  }) {
    return Container(
      width: 70,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isHighlighted)
                  Container(
                    height: 10,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C8FD4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )
                else
                  Container(height: 6, width: 50, color: Colors.grey.shade300),
                const SizedBox(height: 4),
                Container(height: 4, width: 50, color: Colors.grey.shade200),
                const SizedBox(height: 3),
                Container(height: 4, width: 40, color: Colors.grey.shade200),
                const SizedBox(height: 3),
                Container(height: 4, width: 45, color: Colors.grey.shade200),
              ],
            ),
          ),
          if (hasCheckmark)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3A9E94),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscure : false,
        style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
