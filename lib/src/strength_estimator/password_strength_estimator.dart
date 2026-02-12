import 'dart:math';

import '../model/character_set_profile.dart';
import '../model/password_strength.dart';
import 'ipassword_strength_estimator.dart';

/// A class for estimating the strength of a password.
///
/// This class uses a common algorithm based on entropy to estimate the
/// strength of a password. The entropy is calculated based on the length of
/// the password and the size of the character pool it is drawn from.
class PasswordStrengthEstimator implements IPasswordStrengthEstimator {
  /// Creates a [PasswordStrengthEstimator] with an optional character profile.
  PasswordStrengthEstimator({CharacterSetProfile? characterSetProfile})
    : _characterSetProfile =
          characterSetProfile ?? CharacterSetProfile.defaultProfile;

  final CharacterSetProfile _characterSetProfile;

  /// Estimates the strength of a given [password].
  ///
  /// The strength is estimated by calculating the entropy of the password.
  /// The higher the entropy, the stronger the password. The entropy is
  /// calculated using the formula:
  ///
  ///   E = L * log2(N)
  ///
  /// Where:
  ///   - E is the entropy.
  ///   - L is the length of the password.
  ///   - N is the size of the character pool (e.g., 26 for lowercase letters,
  ///     52 for uppercase and lowercase, etc.).
  ///
  /// The returned [PasswordStrength] is determined by the following entropy
  /// thresholds:
  ///
  ///   - less than 40: [PasswordStrength.veryWeak]
  ///   - 40 to 59: [PasswordStrength.weak]
  ///   - 60 to 74: [PasswordStrength.medium]
  ///   - 75 to 127: [PasswordStrength.strong]
  ///   - 128 or greater: [PasswordStrength.veryStrong]
  @override
  PasswordStrength estimatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.veryWeak;

    int characterPoolSize = 0;
    if (password.contains(RegExp(r'[A-Z]'))) {
      characterPoolSize += _characterSetProfile.upperCaseLetters.length;
    }
    if (password.contains(RegExp(r'[a-z]'))) {
      characterPoolSize += _characterSetProfile.lowerCaseLetters.length;
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      characterPoolSize += _characterSetProfile.numbers.length;
    }
    if (password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      characterPoolSize += _characterSetProfile.specialCharacters.length;
    }

    if (characterPoolSize == 0) return PasswordStrength.veryWeak;

    double entropy = password.length * log(characterPoolSize) / log(2);

    if (entropy < 40) return PasswordStrength.veryWeak;
    if (entropy < 60) return PasswordStrength.weak;
    if (entropy < 75) return PasswordStrength.medium;
    if (entropy < 128) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }
}
