import 'package:flutter/material.dart';

/// Reusable Login Form based on the Uiverse.io CSS design by micaelgomestavares.
class UiverseLoginForm extends StatefulWidget {
  final Future<bool> Function(String email, String password)? onLogin;
  final VoidCallback? onSignUp, onForgotPassword, onGoogle, onApple;
  final TextEditingController? emailController, passwordController;
  final ValueChanged<bool>? onRememberMeChanged;
  final bool initialRememberMe;

  const UiverseLoginForm({
    super.key,
    this.onLogin,
    this.onSignUp,
    this.onForgotPassword,
    this.onGoogle,
    this.onApple,
    this.emailController,
    this.passwordController,
    this.onRememberMeChanged,
    this.initialRememberMe = false,
  });

  @override
  State<UiverseLoginForm> createState() => _UiverseLoginFormState();
}

class _UiverseLoginFormState extends State<UiverseLoginForm> {
  static const _labelColor = Color(0xFF151717);
  static const _focusColor = Color(0xFF2D79F3);
  static const _borderIdle = Color(0xFFECEDEC);
  static const _socialBorder = Color(0xFFEDEDEF);
  static const _errorColor = Color(0xFFD93025);

  late final TextEditingController _emailCtrl, _passwordCtrl;
  late final FocusNode _emailFocus, _passwordFocus;
  late final bool _ownsEmail, _ownsPass;

  bool _rememberMe = false, _obscurePass = true, _isLoading = false;
  String? _emailErr, _passwordErr;

  @override
  void initState() {
    super.initState();
    _rememberMe = widget.initialRememberMe;
    _ownsEmail = widget.emailController == null;
    _ownsPass = widget.passwordController == null;
    _emailCtrl = widget.emailController ?? TextEditingController();
    _passwordCtrl = widget.passwordController ?? TextEditingController();
    _emailFocus = FocusNode()..addListener(() => setState(() {}));
    _passwordFocus = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    if (_ownsEmail) _emailCtrl.dispose();
    if (_ownsPass) _passwordCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _emailCtrl.text.trim(), pass = _passwordCtrl.text;
    String? eErr = email.isEmpty
        ? 'Please enter your email'
        : (!email.contains('@') || !email.contains('.') ? 'Please enter a valid email address' : null);
    String? pErr = pass.isEmpty
        ? 'Please enter your password'
        : (pass.length < 6 ? 'Password must be at least 6 characters' : null);

    setState(() {
      _emailErr = eErr;
      _passwordErr = pErr;
    });
    return eErr == null && pErr == null;
  }

  Future<void> _submit() async {
    if (_isLoading || !_validate()) return;
    setState(() => _isLoading = true);
    try {
      if (widget.onLogin != null) {
        await widget.onLogin!(_emailCtrl.text.trim(), _passwordCtrl.text);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildField({
    required String label,
    required Key inputKey,
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String hintText,
    required TextInputAction action,
    required ValueChanged<String> onSubmitted,
    bool isPassword = false,
    String? errorText,
  }) {
    final hasErr = errorText != null;
    final border = hasErr ? _errorColor : (focusNode.hasFocus ? _focusColor : _borderIdle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _labelColor, fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: _labelColor),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  key: inputKey,
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: isPassword && _obscurePass,
                  keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
                  textInputAction: action,
                  autofillHints: isPassword ? const [AutofillHints.password] : const [AutofillHints.email],
                  onChanged: (_) {
                    if (hasErr) setState(() => isPassword ? _passwordErr = null : _emailErr = null);
                  },
                  style: const TextStyle(fontSize: 15, color: _labelColor),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(fontSize: 15, color: Color(0xFF9AA0A6)),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  onSubmitted: onSubmitted,
                ),
              ),
              if (isPassword)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  icon: Icon(
                    _obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20,
                    color: const Color(0xFF6B6F76),
                  ),
                ),
            ],
          ),
        ),
        if (hasErr) ...[
          const SizedBox(height: 6),
          Text(errorText, style: const TextStyle(fontSize: 12, color: _errorColor, fontWeight: FontWeight.w500)),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: AutofillGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField(
                  label: 'Email',
                  inputKey: const Key('login_email_input'),
                  controller: _emailCtrl,
                  focusNode: _emailFocus,
                  icon: Icons.alternate_email_rounded,
                  hintText: 'Enter your Email',
                  action: TextInputAction.next,
                  errorText: _emailErr,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: 14),
                _buildField(
                  label: 'Password',
                  inputKey: const Key('login_password_input'),
                  controller: _passwordCtrl,
                  focusNode: _passwordFocus,
                  icon: Icons.lock_outline_rounded,
                  hintText: 'Enter your Password',
                  action: TextInputAction.done,
                  isPassword: true,
                  errorText: _passwordErr,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: _focusColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onChanged: (v) {
                          setState(() => _rememberMe = v ?? false);
                          widget.onRememberMeChanged?.call(_rememberMe);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _rememberMe = !_rememberMe);
                          widget.onRememberMeChanged?.call(_rememberMe);
                        },
                        child: const Text('Remember me', style: TextStyle(fontSize: 14, color: Colors.black)),
                      ),
                    ),
                    GestureDetector(
                      key: const Key('forgot_password_btn'),
                      onTap: widget.onForgotPassword,
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _focusColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: ElevatedButton(
                    key: const Key('sign_in_submit_btn'),
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _labelColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                          )
                        : const Text('Sign In', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: Colors.black, fontSize: 14)),
                    GestureDetector(
                      key: const Key('sign_up_btn'),
                      onTap: widget.onSignUp,
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _focusColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Or With', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _socialBtn(
                        key: const Key('social_google_btn'),
                        label: 'Google',
                        icon: const _GoogleMark(),
                        onTap: widget.onGoogle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _socialBtn(
                        key: const Key('social_apple_btn'),
                        label: 'Apple',
                        icon: const Icon(Icons.apple, size: 22, color: Colors.black),
                        onTap: widget.onApple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialBtn({required Key key, required String label, required Widget icon, VoidCallback? onTap}) {
    return OutlinedButton(
      key: key,
      onPressed: onTap,
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        side: WidgetStateProperty.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.hovered) ? _focusColor : _socialBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();
  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(18, 18), painter: _GoogleLogoPainter());
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final stroke = Paint()..style = PaintingStyle.stroke..strokeWidth = w * 0.18..strokeCap = StrokeCap.round;
    final b = Rect.fromLTWH(w * 0.08, h * 0.08, w * 0.84, h * 0.84);
    stroke.color = const Color(0xFF4285F4);
    canvas.drawArc(b, -0.25, 1.6, false, stroke);
    stroke.color = const Color(0xFF34A853);
    canvas.drawArc(b, 1.4, 1.1, false, stroke);
    stroke.color = const Color(0xFFFBBC05);
    canvas.drawArc(b, 2.6, 0.9, false, stroke);
    stroke.color = const Color(0xFFEA4335);
    canvas.drawArc(b, 3.6, 1.1, false, stroke);
    canvas.drawRect(Rect.fromLTWH(w * 0.48, h * 0.46, w * 0.44, h * 0.16), Paint()..color = const Color(0xFF4285F4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
