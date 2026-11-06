import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/password_reset_request.dart';
import '../models/register_request.dart';

/// Abstract repository defining the contract for authentication operations.
abstract class AuthRepository {
  /// Authenticates a student using their academic ID or email and password.
  Future<AuthResponse> login(LoginRequest request);

  /// Registers a new student in the system.
  Future<AuthResponse> register(RegisterRequest request);

  /// Generates and sends a 6-digit OTP verification code to the student's identifier.
  Future<AuthResponse> sendPasswordResetCode(String identifier);

  /// Resets a student's password using the verified OTP code.
  Future<AuthResponse> resetPassword(PasswordResetRequest request);
}

