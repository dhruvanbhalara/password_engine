import 'dart:math';

import '../config/password_generator_config.dart';
import '../constants/password_constants.dart';
import 'ipassword_generation_strategy.dart';

/// A password generation strategy that creates a random password.
///
/// This is the default strategy for the [PasswordGenerator]. It generates a
/// password by randomly selecting characters from a pool of allowed characters,
/// which can include uppercase letters, lowercase letters, numbers, and special
/// characters, as specified by the [PasswordGeneratorConfig].
class RandomPasswordStrategy implements IPasswordGenerationStrategy {
  @override
  String generate(PasswordGeneratorConfig config) {
    validate(config);

    final random = Random.secure();
    final enabledSets = _enabledCharacterSets(config);
    final characters = <String>[];

    for (final charSet in enabledSets) {
      characters.add(_randomCharFrom(charSet, random));
    }

    final combinedPool = enabledSets.join();
    final remaining = config.length - characters.length;
    for (var i = 0; i < remaining; i++) {
      characters.add(_randomCharFrom(combinedPool, random));
    }

    characters.shuffle(random);
    return characters.join();
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    if (config.length < 12) {
      throw ArgumentError('Password length must be at least 12');
    }
    final enabledCount = _enabledCharacterSets(config).length;
    if (enabledCount == 0) {
      throw ArgumentError('At least one character type must be selected');
    }
    if (config.length < enabledCount) {
      throw ArgumentError(
        'Password length must be at least $enabledCount to include all '
        'selected character types',
      );
    }
  }

  List<String> _enabledCharacterSets(PasswordGeneratorConfig config) {
    final upper =
        config.excludeAmbiguousChars
            ? PasswordConstants.upperCaseLettersNonAmbiguous
            : PasswordConstants.upperCaseLetters;
    final lower =
        config.excludeAmbiguousChars
            ? PasswordConstants.lowerCaseLettersNonAmbiguous
            : PasswordConstants.lowerCaseLetters;
    final numbers =
        config.excludeAmbiguousChars
            ? PasswordConstants.numbersNonAmbiguous
            : PasswordConstants.numbers;
    final special =
        config.excludeAmbiguousChars
            ? PasswordConstants.specialCharactersNonAmbiguous
            : PasswordConstants.specialCharacters;

    final characterSets = <String>[];
    if (config.useUpperCase) characterSets.add(upper);
    if (config.useLowerCase) characterSets.add(lower);
    if (config.useNumbers) characterSets.add(numbers);
    if (config.useSpecialChars) characterSets.add(special);

    return characterSets;
  }

  String _randomCharFrom(String charSet, Random random) {
    final randomIndex = random.nextInt(charSet.length);
    return charSet[randomIndex];
  }
}
