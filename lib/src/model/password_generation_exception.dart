/// Error codes for password generation failures.
enum PasswordGenerationErrorCode {
  /// The generator could not produce a strong password within the attempt limit.
  maxAttemptsExceeded,
}

/// Typed exception for password generation failures.
class PasswordGenerationException implements Exception {
  /// Factory for max-attempt failures.
  factory PasswordGenerationException.maxAttemptsExceeded({
    required int maxAttempts,
  }) {
    return PasswordGenerationException._(
      PasswordGenerationErrorCode.maxAttemptsExceeded,
      message:
          'Unable to generate a strong password within $maxAttempts attempts.',
      maxAttempts: maxAttempts,
    );
  }

  /// Creates a [PasswordGenerationException] with a specific error code.
  const PasswordGenerationException._(
    this.code, {
    required this.message,
    this.maxAttempts,
  });

  /// The error code describing the failure.
  final PasswordGenerationErrorCode code;

  /// Human-readable message describing the failure.
  final String message;

  /// The attempt limit used when the error occurred.
  final int? maxAttempts;

  @override
  String toString() => message;
}
