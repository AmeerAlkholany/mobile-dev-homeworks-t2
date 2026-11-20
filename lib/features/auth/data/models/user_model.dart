import '../../domain/entities/user_entity.dart';

/// Serialization boundary for the persisted user profile.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.joinedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: (json['phone'] as String?) ?? '',
      joinedAt: DateTime.tryParse((json['joined_at'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}
