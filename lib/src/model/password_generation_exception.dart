import '../../l10n/messages.i18n.dart';

/// Error codes for password generation failures.
enum PasswordGenerationErrorCode {
  /// The generator could not produce a strong password within the attempt limit.
  maxAttemptsExceeded,
}

/// Base class for password generation failures.
sealed class PasswordGenerationException implements Exception {
  const PasswordGenerationException(this.code, {required this.message});

  /// The error code describing the failure.
  final PasswordGenerationErrorCode code;

  /// Human-readable message describing the failure.
  final String message;

  @override
  String toString() => message;

  /// Factory for max-attempt failures.
  static PasswordGenerationException maxAttemptsExceeded({
    required int maxAttempts,
  }) {
    final messages = const Messages();
    return MaxAttemptsExceededException(
      maxAttempts: maxAttempts,
      message: messages.error.maxAttemptsExceeded(maxAttempts),
    );
  }
}

/// Thrown when the generator cannot produce a strong password within the limit.
class MaxAttemptsExceededException extends PasswordGenerationException {
  MaxAttemptsExceededException({
    required this.maxAttempts,
    required String message,
  }) : super(PasswordGenerationErrorCode.maxAttemptsExceeded, message: message);

  /// The attempt limit used when the error occurred.
  final int maxAttempts;
}
