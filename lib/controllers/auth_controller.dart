import 'package:flutter/foundation.dart';
import '../models/login_request.dart';
import '../models/password_reset_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Controller handling student authentication state and business logic.
///
/// Implements [ChangeNotifier] to provide reactive state updates to the UI
/// using Flutter's built-in [ListenableBuilder] without any external packages.
class AuthController extends ChangeNotifier {
  final AuthRepository authRepository;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  UserModel? _currentUser;

  /// Dependency injection via constructor.
  AuthController({required this.authRepository});

  // --- State Getters ---

  /// Whether an authentication asynchronous request is in progress.
  bool get isLoading => _isLoading;

  /// The most recent error message, if any.
  String? get errorMessage => _errorMessage;

  /// The most recent success feedback message, if any.
  String? get successMessage => _successMessage;

  /// The currently authenticated student user.
  UserModel? get currentUser => _currentUser;

  /// Whether a student is currently authenticated.
  bool get isAuthenticated => _currentUser != null;

  /// Convenience getter indicating if the last operation failed.
  bool get hasError => _errorMessage != null;

  /// Convenience getter indicating if the last operation succeeded.
  bool get isSuccess => _successMessage != null && _errorMessage == null;

  // --- State Mutators ---

  /// Clears any pending error and success messages.
  void clearMessages() {
    if (_errorMessage != null || _successMessage != null) {
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();
    }
  }

  /// Logs out the currently authenticated user and resets state.
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    _successMessage = 'You have been logged out successfully.';
    notifyListeners();
  }

  // --- Authentication Operations ---

  /// Authenticates a student with their credentials.
  ///
  /// Prevents duplicate execution if a request is already running.
  Future<void> login(LoginRequest request) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearFeedback();

    try {
      final response = await authRepository.login(request);

      if (response.success) {
        _currentUser = response.user;
        _successMessage = response.message;
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
        _successMessage = null;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _successMessage = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Registers a new student account.
  ///
  /// Prevents duplicate execution if a request is already running.
  Future<void> register(RegisterRequest request) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearFeedback();

    try {
      final response = await authRepository.register(request);

      if (response.success) {
        _successMessage = response.message;
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
        _successMessage = null;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _successMessage = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Requests a password reset verification code (OTP) for the specified identifier.
  ///
  /// Prevents duplicate execution if a request is already running.
  Future<void> sendPasswordResetCode(String identifier) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearFeedback();

    try {
      final response = await authRepository.sendPasswordResetCode(identifier);

      if (response.success) {
        _successMessage = response.message;
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
        _successMessage = null;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _successMessage = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Resets the student's password using the OTP verification code.
  ///
  /// Prevents duplicate execution if a request is already running.
  Future<void> resetPassword(PasswordResetRequest request) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearFeedback();

    try {
      final response = await authRepository.resetPassword(request);

      if (response.success) {
        _successMessage = response.message;
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
        _successMessage = null;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _successMessage = null;
    } finally {
      _setLoading(false);
    }
  }

  // --- Private Helpers ---

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearFeedback() {
    _errorMessage = null;
    _successMessage = null;
  }
}
