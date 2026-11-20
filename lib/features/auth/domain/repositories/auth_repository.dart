import '../entities/user_entity.dart';

/// Authentication contract used by the app's use cases.
abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<UserEntity?> getCurrentUser();

  Future<void> logout();
}
