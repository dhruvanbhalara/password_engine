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
  veryStrong;

  /// Returns the strength level corresponding to the given entropy.
  static PasswordStrength fromEntropy(double entropy) => switch (entropy) {
    < EntropyThresholds.weak => PasswordStrength.veryWeak,
    < EntropyThresholds.medium => PasswordStrength.weak,
    < EntropyThresholds.strong => PasswordStrength.medium,
    < EntropyThresholds.veryStrong => PasswordStrength.strong,
    _ => PasswordStrength.veryStrong,
  };

  /// Returns true if this strength is at least as strong as [other].
  bool isAtLeast(PasswordStrength other) => index >= other.index;
}

/// Centralized entropy thresholds for password strength classification.
///
/// A non-instantiable namespace for threshold constants.
abstract final class EntropyThresholds {
  /// Very Weak to Weak transition.
  static const double weak = 40.0;

  /// Weak to Medium transition.
  static const double medium = 60.0;

  /// Medium to Strong transition.
  static const double strong = 75.0;

  /// Strong to Very Strong transition.
  static const double veryStrong = 128.0;
}
