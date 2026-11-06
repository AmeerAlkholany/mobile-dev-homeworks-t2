import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/login_request.dart';
import '../../utils/form_validators.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

/// Screen 1: Student Login Page
///
/// Features:
/// - Identifier input (Academic ID or University Email)
/// - Password input with visibility toggle
/// - Remember Me checkbox
/// - Forgot Password navigation link
/// - Login button with loading indicator
/// - Form validation via [GlobalKey<FormState>]
/// - Reactive state management via [ListenableBuilder]
class LoginPage extends StatefulWidget {
  final AuthController controller;

  const LoginPage({
    super.key,
    required this.controller,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color navyPrimary = Color(0xFF1E3A8A);
  static const Color lightBackground = Color(0xFFF8FAFC);

  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = LoginRequest(
      identifier: _identifierController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    await widget.controller.login(request);

    if (!mounted) return;

    if (widget.controller.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.controller.successMessage ?? 'Login successful!',
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF15803D), // Success Green
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _fillDemoCredentials(String id, String pass) {
    setState(() {
      _identifierController.text = id;
      _passwordController.text = pass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final isLoading = widget.controller.isLoading;
            final currentUser = widget.controller.currentUser;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: currentUser != null
                      ? _buildAuthenticatedCard(context, currentUser)
                      : _buildLoginForm(context, isLoading),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Displayed when the student is authenticated to demonstrate full round-trip session state.
  Widget _buildAuthenticatedCard(BuildContext context, dynamic user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 40,
                color: Color(0xFF15803D),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Authentication Successful',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: navyPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome, ${user.fullName}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildProfileRow('Academic ID', user.academicId),
                  const Divider(height: 16),
                  _buildProfileRow('University Email', user.email),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: navyPrimary,
                  side: const BorderSide(color: navyPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  widget.controller.logout();
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'Sign Out / Back to Login',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, bool isLoading) {
    final errorMessage = widget.controller.errorMessage;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Academic Logo & Header
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0x1A1E3A8A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 40,
                color: navyPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Student Portal',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sign in to access your university courses and academic records',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),

          // Academic Demo Helper Banner
          _buildDemoHelperCard(),
          const SizedBox(height: 18),

          // Error Feedback Banner
          if (errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFDC2626),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB91C1C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Identifier Field
          TextFormField(
            controller: _identifierController,
            validator: FormValidators.validateLoginIdentifier,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Academic ID or University Email',
              hintText: 'e.g. 2024101234 or student@university.edu',
              prefixIcon: const Icon(Icons.badge_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: _passwordController,
            validator: FormValidators.validateLoginPassword,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: const Color(0xFF64748B),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Remember Me & Forgot Password Row
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: navyPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _rememberMe = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        widget.controller.clearMessages();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordPage(
                              controller: widget.controller,
                            ),
                          ),
                        );
                      },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: navyPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Login Button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: navyPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
              ),
              onPressed: isLoading ? null : _handleLogin,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Register Navigation Link
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        widget.controller.clearMessages();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterPage(
                              controller: widget.controller,
                            ),
                          ),
                        );
                      },
                child: const Text(
                  'Register Here',
                  style: TextStyle(
                    color: navyPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Informational card providing demo credentials to evaluators.
  Widget _buildDemoHelperCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF1D4ED8)),
              SizedBox(width: 6),
              Text(
                'Academic Demo Credentials',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'ID: 2024101234  |  Pass: Password123',
            style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A)),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _fillDemoCredentials('2024101234', 'Password123'),
            child: const Text(
              'Tap to auto-fill demo credentials',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF2563EB),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
