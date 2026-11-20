/// Base exception for any recoverable failure thrown by a repository or
/// data source. [messageKey] is a localization key so the UI never shows a
/// raw developer message to the user.
class AppException implements Exception {
  const AppException(this.messageKey, {this.details});

  final String messageKey;
  final String? details;

  @override
  String toString() => 'AppException($messageKey${details == null ? '' : ': $details'})';
}

class NotFoundException extends AppException {
  const NotFoundException(super.messageKey, {super.details});
}
