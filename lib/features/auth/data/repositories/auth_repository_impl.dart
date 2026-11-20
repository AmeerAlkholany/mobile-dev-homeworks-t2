import '../../../../core/services/auth_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

/// Mock authentication wired into the persistent [AuthService] session.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource, this._authService);

  final AuthLocalDataSource _localDataSource;
  final AuthService _authService;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final UserModel user = await _localDataSource.signIn(
      email: email,
      password: password,
    );
    await _authService.saveSession(
      token: _tokenFor(user.id),
      profile: user.toJson(),
    );
    return user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final UserModel user = await _localDataSource.signUp(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    await _authService.saveSession(
      token: _tokenFor(user.id),
      profile: user.toJson(),
    );
    return user;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final Map<String, dynamic>? profile = _authService.profile;
    if (!_authService.isLoggedIn || profile == null) {
      return null;
    }
    return UserModel.fromJson(profile);
  }

  @override
  Future<void> logout() => _authService.clearSession();

  String _tokenFor(String userId) =>
      'ejary-token-$userId-${DateTime.now().millisecondsSinceEpoch}';
}
