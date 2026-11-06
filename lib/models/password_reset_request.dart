/// Request payload for resetting password with verification OTP.
class PasswordResetRequest {
  final String identifier; // Academic ID or University Email
  final String verificationCode;
  final String newPassword;

  const PasswordResetRequest({
    required this.identifier,
    required this.verificationCode,
    required this.newPassword,
  });

  @override
  String toString() {
    return 'PasswordResetRequest(identifier: $identifier, verificationCode: $verificationCode)';
  }
}

