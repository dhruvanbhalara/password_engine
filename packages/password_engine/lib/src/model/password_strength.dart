/// Represents the estimated strength of a password.
///
/// This enum is used by the [PasswordStrengthEstimator] to classify a password
/// into one of five strength levels.
enum PasswordStrength {
  /// Indicates a very weak password that is highly vulnerable to attacks.
  veryWeak,

  /// Indicates a weak password that may be easily guessed or cracked.
  weak,

  /// Indicates a password of medium strength that provides a reasonable
  /// level of security.
  medium,

  /// Indicates a strong password that is resistant to common cracking methods.
  strong,

  /// Indicates a very strong password that provides a high level of security.
  veryStrong,
}
