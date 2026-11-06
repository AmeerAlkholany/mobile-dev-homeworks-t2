import 'dart:async';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/password_reset_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Private record or helper class to maintain user credentials in memory.
class _StoredUser {
  final UserModel user;
  String password;

  _StoredUser({
    required this.user,
    required this.password,
  });
}

/// Concrete implementation of [AuthRepository] with simulated in-memory storage
/// and simulated network latency.
class AuthRepositoryImpl implements AuthRepository {
  /// Default fixed development OTP for testing.
  static const String developmentOtp = '123456';

  /// In-memory storage for registered students and credentials.
  final List<_StoredUser> _users = [];

  /// In-memory store for pending OTP verification codes mapped by normalized identifier.
  final Map<String, String> _pendingOtps = {};

  /// Simulated network latency duration.
  final Duration simulatedDelay;

  AuthRepositoryImpl({
    this.simulatedDelay = const Duration(milliseconds: 900),
  }) {
    _seedDefaultData();
  }

  /// Seeds default test accounts for academic evaluation and manual testing.
  void _seedDefaultData() {
    _users.add(
      _StoredUser(
        user: const UserModel(
          id: 'std_001',
          fullName: 'Ahmad Al-Mansoor',
          academicId: '2024101234',
          email: 'student@university.edu',
        ),
        password: 'Password123',
      ),
    );

    _users.add(
      _StoredUser(
        user: const UserModel(
          id: 'std_002',
          fullName: 'Sara Al-Ghamdi',
          academicId: '2024105678',
          email: 'sara@university.edu',
        ),
        password: 'Password123',
      ),
    );
  }

  String _normalize(String input) => input.trim().toLowerCase();

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    await Future.delayed(simulatedDelay);

    final normalizedIdentifier = _normalize(request.identifier);
    final trimmedPassword = request.password;

    // Search user by academicId or email
    final match = _users.cast<_StoredUser?>().firstWhere(
      (entry) {
        if (entry == null) return false;
        final academicMatch = entry.user.academicId.trim() == request.identifier.trim();
        final emailMatch = _normalize(entry.user.email) == normalizedIdentifier;
        return academicMatch || emailMatch;
      },
      orElse: () => null,
    );

    if (match == null) {
      return AuthResponse.failure(
        message: 'No student account found with this Academic ID or Email.',
      );
    }

    if (match.password != trimmedPassword) {
      return AuthResponse.failure(
        message: 'Invalid password. Please check your credentials.',
      );
    }

    return AuthResponse.success(
      message: 'Welcome back, ${match.user.fullName}!',
      user: match.user,
    );
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    await Future.delayed(simulatedDelay);

    final trimmedAcademicId = request.academicId.trim();
    final normalizedEmail = _normalize(request.universityEmail);

    // Validate duplicate Academic ID
    final duplicateId = _users.any(
      (entry) => entry.user.academicId.trim() == trimmedAcademicId,
    );
    if (duplicateId) {
      return AuthResponse.failure(
        message: 'Academic ID "$trimmedAcademicId" is already registered.',
      );
    }

    // Validate duplicate Email
    final duplicateEmail = _users.any(
      (entry) => _normalize(entry.user.email) == normalizedEmail,
    );
    if (duplicateEmail) {
      return AuthResponse.failure(
        message: 'University email "${request.universityEmail.trim()}" is already registered.',
      );
    }

    // Create and save new student
    final newUser = UserModel(
      id: 'std_${DateTime.now().millisecondsSinceEpoch}',
      fullName: request.fullName.trim(),
      academicId: trimmedAcademicId,
      email: request.universityEmail.trim(),
    );

    _users.add(
      _StoredUser(
        user: newUser,
        password: request.password,
      ),
    );

    return AuthResponse.success(
      message: 'Registration successful! You can now log in with your credentials.',
      user: newUser,
    );
  }

  @override
  Future<AuthResponse> sendPasswordResetCode(String identifier) async {
    await Future.delayed(simulatedDelay);

    final normalizedIdentifier = _normalize(identifier);

    // Check if student exists
    final exists = _users.any((entry) {
      final academicMatch = entry.user.academicId.trim() == identifier.trim();
      final emailMatch = _normalize(entry.user.email) == normalizedIdentifier;
      return academicMatch || emailMatch;
    });

    if (!exists) {
      return AuthResponse.failure(
        message: 'No registered student account was found with the provided identifier.',
      );
    }

    // Save development OTP for this identifier
    _pendingOtps[normalizedIdentifier] = developmentOtp;

    return AuthResponse.success(
      message: 'A 6-digit verification code has been sent. (Dev OTP: $developmentOtp)',
    );
  }

  @override
  Future<AuthResponse> resetPassword(PasswordResetRequest request) async {
    await Future.delayed(simulatedDelay);

    final normalizedIdentifier = _normalize(request.identifier);

    // Find user
    final match = _users.cast<_StoredUser?>().firstWhere(
      (entry) {
        if (entry == null) return false;
        final academicMatch = entry.user.academicId.trim() == request.identifier.trim();
        final emailMatch = _normalize(entry.user.email) == normalizedIdentifier;
        return academicMatch || emailMatch;
      },
      orElse: () => null,
    );

    if (match == null) {
      return AuthResponse.failure(
        message: 'Student account not found.',
      );
    }

    // Verify OTP
    final expectedOtp = _pendingOtps[normalizedIdentifier] ?? developmentOtp;
    if (request.verificationCode.trim() != expectedOtp &&
        request.verificationCode.trim() != developmentOtp) {
      return AuthResponse.failure(
        message: 'Invalid verification code. Please check and try again.',
      );
    }

    // Update password
    match.password = request.newPassword;
    _pendingOtps.remove(normalizedIdentifier);

    return AuthResponse.success(
      message: 'Password has been successfully updated. You can now log in.',
      user: match.user,
    );
  }
}

