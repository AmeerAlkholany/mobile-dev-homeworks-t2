import 'user_model.dart';

/// Standard response model for all authentication operations.
class AuthResponse {
  final bool success;
  final String message;
  final UserModel? user;

  const AuthResponse({
    required this.success,
    required this.message,
    this.user,
  });

  /// Factory constructor for successful authentication operations.
  factory AuthResponse.success({
    required String message,
    UserModel? user,
  }) {
    return AuthResponse(
      success: true,
      message: message,
      user: user,
    );
  }

  /// Factory constructor for failed authentication operations.
  factory AuthResponse.failure({
    required String message,
  }) {
    return AuthResponse(
      success: false,
      message: message,
      user: null,
    );
  }

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message, user: $user)';
  }
}

