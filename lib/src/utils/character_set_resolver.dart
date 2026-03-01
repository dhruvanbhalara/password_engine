import '../config/password_generator_config.dart';

/// Identifies a character set type in the config.
enum CharacterSetType { upper, lower, number, special }

/// Resolves enabled character sets based on configuration.
class CharacterSetResolver {
  /// Returns a map of enabled character set types to their character strings.
  static Map<CharacterSetType, String> resolve(
    PasswordGeneratorConfig config, {
    bool? useUpperCase,
    bool? useLowerCase,
    bool? useNumbers,
    bool? useSpecialChars,
  }) {
    final profile = config.characterSetProfile;
    final useNonAmbiguous = config.excludeAmbiguousChars;
    final enableUpper = useUpperCase ?? config.useUpperCase;
    final enableLower = useLowerCase ?? config.useLowerCase;
    final enableNumbers = useNumbers ?? config.useNumbers;
    final enableSpecial = useSpecialChars ?? config.useSpecialChars;

    final sets = <CharacterSetType, String>{};
    if (enableUpper) {
      sets[CharacterSetType.upper] =
          useNonAmbiguous
              ? profile.upperCaseLettersNonAmbiguous
              : profile.upperCaseLetters;
    }
    if (enableLower) {
      sets[CharacterSetType.lower] =
          useNonAmbiguous
              ? profile.lowerCaseLettersNonAmbiguous
              : profile.lowerCaseLetters;
    }
    if (enableNumbers) {
      sets[CharacterSetType.number] =
          useNonAmbiguous ? profile.numbersNonAmbiguous : profile.numbers;
    }
    if (enableSpecial) {
      sets[CharacterSetType.special] =
          useNonAmbiguous
              ? profile.specialCharactersNonAmbiguous
              : profile.specialCharacters;
    }

    return sets;
  }
}
