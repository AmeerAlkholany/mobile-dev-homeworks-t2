import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/user_model.dart';

/// Mock credential check. Swapping this for a REST data source is the only
/// change needed to move Ejary onto a real backend.
abstract class AuthLocalDataSource {
  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
}

class MockAuthLocalDataSource implements AuthLocalDataSource {
  const MockAuthLocalDataSource();

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);
    final String normalized = email.trim().toLowerCase();
    if (password.length < 6 || !normalized.contains('@')) {
      throw const AppException('error_login_failed');
    }
    return UserModel(
      id: _idFor(normalized),
      name: _nameFromEmail(normalized),
      email: normalized,
      phone: '+966500000000',
      joinedAt: DateTime.now(),
    );
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);
    final String normalized = email.trim().toLowerCase();
    if (password.length < 6 || !normalized.contains('@')) {
      throw const AppException('error_login_failed');
    }
    return UserModel(
      id: _idFor(normalized),
      name: name.trim(),
      email: normalized,
      phone: phone.trim(),
      joinedAt: DateTime.now(),
    );
  }

  String _idFor(String email) => 'usr-${email.hashCode.abs()}';

  String _nameFromEmail(String email) {
    final String local = email.split('@').first;
    final List<String> words = local
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .split(' ')
        .where((String word) => word.trim().isNotEmpty)
        .toList();
    if (words.isEmpty) {
      return 'Ejary Tenant';
    }
    return words
        .map(
          (String word) =>
              '${word.substring(0, 1).toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}
