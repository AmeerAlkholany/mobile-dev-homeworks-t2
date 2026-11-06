/// Represents an authenticated student user in the academic portal.
class UserModel {
  final String id;
  final String fullName;
  final String academicId;
  final String email;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.academicId,
    required this.email,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? academicId,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      academicId: academicId ?? this.academicId,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, academicId: $academicId, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.fullName == fullName &&
        other.academicId == academicId &&
        other.email == email;
  }

  @override
  int get hashCode {
    return Object.hash(id, fullName, academicId, email);
  }
}

