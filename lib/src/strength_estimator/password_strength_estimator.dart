import 'dart:math';

import '../model/character_set_profile.dart';
import '../model/password_strength.dart';
import '../utils/password_string_extensions.dart';
import 'ipassword_strength_estimator.dart';

/// Estimates password strength using pool-based entropy (`L × log₂(N)`).
///
/// May overestimate strength for patterned or dictionary-based passwords.
/// For more accurate results, inject a custom [IPasswordStrengthEstimator].
final class PasswordStrengthEstimator implements IPasswordStrengthEstimator {
  /// Creates a [PasswordStrengthEstimator] with an optional [characterSetProfile].
  PasswordStrengthEstimator({CharacterSetProfile? characterSetProfile})
    : _characterSetProfile =
          characterSetProfile ?? CharacterSetProfile.defaultProfile;

  final CharacterSetProfile _characterSetProfile;

  /// Returns the [PasswordStrength] for the given [password].
  @override
  PasswordStrength estimatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.veryWeak;
    final (entropy, _) = estimateDetailedStrength(password);
    return PasswordStrength.fromEntropy(entropy);
  }

  /// Returns a record containing entropy and a simplified score [0-4].
  @override
  (double entropy, int score) estimateDetailedStrength(String password) {
    if (password.isEmpty) return (0.0, 0);
    final entropy = estimateEntropy(password);
    final strength = PasswordStrength.fromEntropy(entropy);
    return (entropy, strength.index);
  }

  @override
  double estimateEntropy(String password, {bool allowSpaces = false}) {
    if (password.isEmpty) return 0;

    int characterPoolSize = 0;
    if (password.containsAnyOf(_characterSetProfile.upperCaseLetters)) {
      characterPoolSize += _characterSetProfile.upperCaseLetters.length;
    }
    if (password.containsAnyOf(_characterSetProfile.lowerCaseLetters)) {
      characterPoolSize += _characterSetProfile.lowerCaseLetters.length;
    }
    if (password.containsAnyOf(_characterSetProfile.numbers)) {
      characterPoolSize += _characterSetProfile.numbers.length;
    }

    var specialCharacters = _characterSetProfile.specialCharacters;
    if (allowSpaces && !specialCharacters.contains(' ')) {
      specialCharacters = '$specialCharacters ';
    }

    if (password.containsAnyOf(specialCharacters)) {
      characterPoolSize += specialCharacters.length;
    }

    if (characterPoolSize == 0) {
      // Fallback for passwords consisting entirely of unmapped characters (e.g., Unicode).
      // We assume a large arbitrary pool size to give credit for these characters.
      characterPoolSize = 100000;
    }

    return password.length * log(characterPoolSize) / log(2);
  }
}
