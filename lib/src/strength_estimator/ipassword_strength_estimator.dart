import '../model/password_strength.dart';

/// Interface for password strength estimators.
abstract interface class IPasswordStrengthEstimator {
  /// Returns the estimated [PasswordStrength] of the given [password].
  PasswordStrength estimatePasswordStrength(String password);

  /// Returns a record of (entropy, score) for the given [password].
  (double entropy, int score) estimateDetailedStrength(String password);

  /// Returns the estimated entropy in bits for the given [password].
  double estimateEntropy(String password, {bool allowSpaces = false});
}
