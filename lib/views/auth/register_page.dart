import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/register_request.dart';
import '../../utils/form_validators.dart';

/// Screen 2: Student Registration Page
///
/// Features:
/// - Full Name input
/// - Academic ID input (numeric keyboard, 9 or 10 digits)
/// - University Email input
/// - Password input with visibility toggle & password policy
/// - Confirm Password input with visibility toggle
/// - Terms and conditions acceptance checkbox
/// - Form validation via [GlobalKey<FormState>]
/// - Duplicate prevention via [AuthController]
/// - On success, shows a confirmation SnackBar and navigates back to LoginPage
class RegisterPage extends StatefulWidget {
  final AuthController controller;

  const RegisterPage({
    super.key,
    required this.controller,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String? _termsError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    // Validate terms acceptance
    final termsValidation = FormValidators.validateTerms(_agreeToTerms);
    setState(() {
      _termsError = termsValidation;
    });

    if (!_formKey.currentState!.validate() || termsValidation != null) {
      return;
    }

    final request = RegisterRequest(
      fullName: _fullNameController.text.trim(),
      academicId: _academicIdController.text.trim(),
      universityEmail: _emailController.text.trim(),
      password: _passwordController.text,
    );

    await widget.controller.register(request);

    if (!mounted) return;

    if (widget.controller.isSuccess) {
      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.controller.successMessage ?? 'Account created successfully!',
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF15803D), // Success Green
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate back to LoginPage
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const navyPrimary = Color(0xFF1E3A8A);
    const lightBackground = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text(
          'Student Registration',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final isLoading = widget.controller.isLoading;
            final errorMessage = widget.controller.errorMessage;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Title
                        const Text(
                          'Create Academic Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Enter your university credentials to register in the portal',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 20),

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

                        // Full Name Field
                        TextFormField(
                          controller: _fullNameController,
                          validator: FormValidators.validateFullName,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'e.g. Ahmad Al-Mansoor',
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Academic ID Field (numeric keyboard, 9 or 10 digits)
                        TextFormField(
                          controller: _academicIdController,
                          validator: FormValidators.validateAcademicId,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Academic ID',
                            hintText: '9 or 10 digits (e.g. 2024109999)',
                            prefixIcon: const Icon(Icons.pin_outlined),
                            helperText: 'Must contain digits only (9 or 10 digits)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // University Email Field
                        TextFormField(
                          controller: _emailController,
                          validator: FormValidators.validateUniversityEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'University Email',
                            hintText: 'student@university.edu',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          validator: FormValidators.validateRegisterPassword,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'At least 8 chars, 1 uppercase, 1 digit',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF64748B),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            helperText: 'Min 8 characters, at least 1 uppercase and 1 digit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          validator: (value) => FormValidators.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleRegister(),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            prefixIcon: const Icon(Icons.lock_reset_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF64748B),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
                        const SizedBox(height: 16),

                        // Terms and Conditions Checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _agreeToTerms,
                                activeColor: navyPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _agreeToTerms = val ?? false;
                                    if (_agreeToTerms) {
                                      _termsError = null;
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'I accept the University Academic Terms & Honor Code',
                                style: TextStyle(fontSize: 13, color: Color(0xFF334155)),
                              ),
                            ),
                          ],
                        ),
                        if (_termsError != null) ...[
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 34.0),
                            child: Text(
                              _termsError!,
                              style: const TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Register Button
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
                            onPressed: isLoading ? null : _handleRegister,
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
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Return to Login Link
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Already registered? ',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      widget.controller.clearMessages();
                                      Navigator.pop(context);
                                    },
                              child: const Text(
                                'Sign In',
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

