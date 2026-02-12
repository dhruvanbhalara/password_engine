import '../model/password_strength.dart';

/// An abstract interface for password strength estimators.
///
/// This interface defines the contract for classes that estimate the strength of a password.
/// Implement this interface to create custom password strength estimation logic.
abstract class IPasswordStrengthEstimator {
  /// Estimates the strength of a given [password].
  ///
  /// Returns a [PasswordStrength] enum value indicating the estimated strength.
  PasswordStrength estimatePasswordStrength(String password);
}
