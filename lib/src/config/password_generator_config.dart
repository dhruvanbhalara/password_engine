import '../model/character_set_profile.dart';

/// Configuration for password generation.
///
/// This class holds the settings used to generate a password, such as length and character types.
class PasswordGeneratorConfig {
  /// Creates a [PasswordGeneratorConfig] with the given settings.
  const PasswordGeneratorConfig({
    this.length = 12,
    this.useUpperCase = true,
    this.useLowerCase = true,
    this.useNumbers = true,
    this.useSpecialChars = true,
    this.excludeAmbiguousChars = false,
    this.characterSetProfile = CharacterSetProfile.defaultProfile,
    this.maxGenerationAttempts = defaultMaxGenerationAttempts,
    this.extra = const {},
  });

  /// Default maximum attempts when refreshing a password.
  static const int defaultMaxGenerationAttempts = 1000;

  /// The length of the password to generate.
  final int length;

  /// Whether to include uppercase letters in the password.
  final bool useUpperCase;

  /// Whether to include lowercase letters in the password.
  final bool useLowerCase;

  /// Whether to include numbers in the password.
  final bool useNumbers;

  /// Whether to include special characters in the password.
  final bool useSpecialChars;

  /// Whether to exclude ambiguous characters (e.g., 'I', 'l', '1', 'O', '0').
  final bool excludeAmbiguousChars;

  /// Character sets used by generation strategies.
  final CharacterSetProfile characterSetProfile;

  /// Maximum attempts when regenerating until a strong password is found.
  final int maxGenerationAttempts;

  /// Additional configuration parameters for custom strategies.
  final Map<String, dynamic> extra;
}
