/// Immutable profile of character sets used for password generation.
class CharacterSetProfile {
  /// Creates a [CharacterSetProfile] with the provided character sets.
  const CharacterSetProfile({
    required this.upperCaseLetters,
    required this.lowerCaseLetters,
    required this.numbers,
    required this.specialCharacters,
    required this.upperCaseLettersNonAmbiguous,
    required this.lowerCaseLettersNonAmbiguous,
    required this.numbersNonAmbiguous,
    required this.specialCharactersNonAmbiguous,
  });

  /// Default character set profile.
  static const CharacterSetProfile defaultProfile = CharacterSetProfile(
    upperCaseLetters: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    lowerCaseLetters: 'abcdefghijklmnopqrstuvwxyz',
    numbers: '0123456789',
    specialCharacters: '!@#\$%^&*()_+-=[]{}|;:,.<>?',
    upperCaseLettersNonAmbiguous: 'ABCDEFGHJKLMNPQRSTUVWXYZ',
    lowerCaseLettersNonAmbiguous: 'abcdefghijkmnpqrstuvwxyz',
    numbersNonAmbiguous: '23456789',
    specialCharactersNonAmbiguous: '!@#\$%^&*()_+-=[]:|;,.<>?',
  );

  /// Default profile that includes a space character.
  static const CharacterSetProfile defaultWithSpaces = CharacterSetProfile(
    upperCaseLetters: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    lowerCaseLetters: 'abcdefghijklmnopqrstuvwxyz',
    numbers: '0123456789',
    specialCharacters: '!@#\$%^&*()_+-=[]{}|;:,.<>? ',
    upperCaseLettersNonAmbiguous: 'ABCDEFGHJKLMNPQRSTUVWXYZ',
    lowerCaseLettersNonAmbiguous: 'abcdefghijkmnpqrstuvwxyz',
    numbersNonAmbiguous: '23456789',
    specialCharactersNonAmbiguous: '!@#\$%^&*()_+-=[]:|;,.<>? ',
  );

  /// The set of uppercase letters used in password generation.
  final String upperCaseLetters;

  /// The set of lowercase letters used in password generation.
  final String lowerCaseLetters;

  /// The set of numeric characters used in password generation.
  final String numbers;

  /// The set of special characters used in password generation.
  final String specialCharacters;

  /// The set of non-ambiguous uppercase letters.
  final String upperCaseLettersNonAmbiguous;

  /// The set of non-ambiguous lowercase letters.
  final String lowerCaseLettersNonAmbiguous;

  /// The set of non-ambiguous numeric characters.
  final String numbersNonAmbiguous;

  /// The set of non-ambiguous special characters.
  final String specialCharactersNonAmbiguous;

  CharacterSetProfile copyWith({
    String? upperCaseLetters,
    String? lowerCaseLetters,
    String? numbers,
    String? specialCharacters,
    String? upperCaseLettersNonAmbiguous,
    String? lowerCaseLettersNonAmbiguous,
    String? numbersNonAmbiguous,
    String? specialCharactersNonAmbiguous,
  }) {
    return CharacterSetProfile(
      upperCaseLetters: upperCaseLetters ?? this.upperCaseLetters,
      lowerCaseLetters: lowerCaseLetters ?? this.lowerCaseLetters,
      numbers: numbers ?? this.numbers,
      specialCharacters: specialCharacters ?? this.specialCharacters,
      upperCaseLettersNonAmbiguous:
          upperCaseLettersNonAmbiguous ?? this.upperCaseLettersNonAmbiguous,
      lowerCaseLettersNonAmbiguous:
          lowerCaseLettersNonAmbiguous ?? this.lowerCaseLettersNonAmbiguous,
      numbersNonAmbiguous: numbersNonAmbiguous ?? this.numbersNonAmbiguous,
      specialCharactersNonAmbiguous:
          specialCharactersNonAmbiguous ?? this.specialCharactersNonAmbiguous,
    );
  }
}
