import '../model/password_feedback.dart';
import '../model/password_strength.dart';

/// Interface for password generators.
abstract interface class IPasswordGenerator {
  /// Generates a password with the given overrides, or uses configured defaults.
  String generatePassword({
    int? length,
    bool? useUpperCase,
    bool? useLowerCase,
    bool? useNumbers,
    bool? useSpecialChars,
    bool? excludeAmbiguousChars,
  });

  /// Generates a strong password, retrying until validation passes.
  String refreshPassword();

  /// Estimates the [PasswordStrength] of the given [password].
  PasswordStrength estimateStrength(String password);

  /// Returns user-facing [PasswordFeedback] for the given [password].
  PasswordFeedback estimateFeedback(String password);
}
