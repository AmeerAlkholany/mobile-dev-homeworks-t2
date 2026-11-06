/// Request payload for student registration.
class RegisterRequest {
  final String fullName;
  final String academicId;
  final String universityEmail;
  final String password;

  const RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.universityEmail,
    required this.password,
  });

  @override
  String toString() {
    return 'RegisterRequest(fullName: $fullName, academicId: $academicId, universityEmail: $universityEmail)';
  }
}

