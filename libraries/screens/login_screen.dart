import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/login_form.dart';
import '../widgets/nature_scene_background.dart';

/// Full-screen Responsive Login Screen for Gen-Z Wellness / Stress-Management App.
class LoginScreen extends StatefulWidget {
  final Future<void> Function()? onLoginSuccess;
  final VoidCallback? onSignIn, onSignUp, onForgotPassword, onGoogle, onApple;
  final TextEditingController? emailController, passwordController;
  final ValueChanged<bool>? onRememberMeChanged;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.onSignIn,
    this.onSignUp,
    this.onForgotPassword,
    this.onGoogle,
    this.onApple,
    this.emailController,
    this.passwordController,
    this.onRememberMeChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailCtrl, _passCtrl;
  late final bool _ownsEmail, _ownsPass;

  @override
  void initState() {
    super.initState();
    _ownsEmail = widget.emailController == null;
    _ownsPass = widget.passwordController == null;
    _emailCtrl = widget.emailController ?? TextEditingController();
    _passCtrl = widget.passwordController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsEmail) _emailCtrl.dispose();
    if (_ownsPass) _passCtrl.dispose();
    super.dispose();
  }

  Future<bool> _handleLogin(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (widget.onLoginSuccess != null) {
      await widget.onLoginSuccess!();
    } else if (widget.onSignIn != null) {
      widget.onSignIn!();
    } else {
      Get.snackbar(
        'Welcome Back',
        'Successfully signed in to your wellness sanctuary.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF151717),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
    return true;
  }

  void _showForgotPassword(BuildContext context) {
    if (widget.onForgotPassword != null) return widget.onForgotPassword!();
    final ctrl = TextEditingController(text: _emailCtrl.text);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.spa_rounded, color: Color(0xFF2D79F3), size: 24),
            SizedBox(width: 8),
            Text('Reset Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF151717))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Take a breath. Enter your email and we will send you a reset link (UI Demo).',
                style: TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.4)),
            const SizedBox(height: 16),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFECEDEC), width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.alternate_email, size: 18, color: Color(0xFF151717)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      decoration: const InputDecoration(hintText: 'name@example.com', border: InputBorder.none, isCollapsed: true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel', style: TextStyle(color: Color(0xFF777777)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF151717),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Get.showSnackbar(const GetSnackBar(message: 'Password reset link sent (Demo Mode).', duration: Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM));
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }

  void _showSignUp(BuildContext context) {
    if (widget.onSignUp != null) return widget.onSignUp!();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.self_improvement_rounded, color: Color(0xFF2D79F3), size: 24),
            SizedBox(width: 8),
            Text('Join Stress App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF151717))),
          ],
        ),
        content: const Text(
          'Account registration is currently in preview mode. You can sign in using any dummy credentials to explore the app.',
          style: TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF151717),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showSocial(String provider, VoidCallback? callback) {
    if (callback != null) return callback();
    Get.showSnackbar(
      GetSnackBar(
        message: '$provider sign-in is ready for UI preview.',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF11184F);
    return Scaffold(
      body: NatureSceneBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32 > 0 ? constraints.maxHeight - 32 : constraints.maxHeight,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () => Get.back(),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: navy, width: 1.8),
                                boxShadow: const [
                                  BoxShadow(color: navy, offset: Offset(0, 3)),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: navy),
                                  SizedBox(width: 6),
                                  Text('Tests', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: navy)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white, width: 1.5),
                            boxShadow: [
                              BoxShadow(color: navy.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: const Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: navy,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        UiverseLoginForm(
                          emailController: _emailCtrl,
                          passwordController: _passCtrl,
                          onLogin: _handleLogin,
                          onForgotPassword: () => _showForgotPassword(context),
                          onSignUp: () => _showSignUp(context),
                          onGoogle: () => _showSocial('Google', widget.onGoogle),
                          onApple: () => _showSocial('Apple', widget.onApple),
                          onRememberMeChanged: widget.onRememberMeChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
