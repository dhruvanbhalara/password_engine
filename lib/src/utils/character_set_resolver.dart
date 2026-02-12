import '../config/password_generator_config.dart';

/// Identifies a character set type in the config.
enum CharacterSetType { upper, lower, number, special }

/// Resolves enabled character sets based on configuration.
class CharacterSetResolver {
  /// Returns a map of enabled character set types to their character strings.
  static Map<CharacterSetType, String> resolve(PasswordGeneratorConfig config) {
    final profile = config.characterSetProfile;
    final useNonAmbiguous = config.excludeAmbiguousChars;

    final sets = <CharacterSetType, String>{};
    if (config.useUpperCase) {
      sets[CharacterSetType.upper] =
          useNonAmbiguous
              ? profile.upperCaseLettersNonAmbiguous
              : profile.upperCaseLetters;
    }
    if (config.useLowerCase) {
      sets[CharacterSetType.lower] =
          useNonAmbiguous
              ? profile.lowerCaseLettersNonAmbiguous
              : profile.lowerCaseLetters;
    }
    if (config.useNumbers) {
      sets[CharacterSetType.number] =
          useNonAmbiguous ? profile.numbersNonAmbiguous : profile.numbers;
    }
    if (config.useSpecialChars) {
      sets[CharacterSetType.special] =
          useNonAmbiguous
              ? profile.specialCharactersNonAmbiguous
              : profile.specialCharacters;
    }

    return sets;
  }
}
