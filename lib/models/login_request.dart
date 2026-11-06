/// Request payload for student login.
class LoginRequest {
  final String identifier; // Academic ID or University Email
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.identifier,
    required this.password,
    this.rememberMe = false,
  });

  @override
  String toString() {
    return 'LoginRequest(identifier: $identifier, rememberMe: $rememberMe)';
  }
}

