import 'dart:math';

import 'package:password_engine/password_engine.dart';

import '../constants/words.dart';

/// A password generation strategy that creates a memorable password.
///
/// This strategy generates a password by combining a series of random words
/// from a predefined list, separated by a hyphen. This approach, inspired by
/// the "diceware" method, results in passwords that are easier for humans to
/// remember and type than traditional random strings of characters.
///
/// Example: `apple-banana-carrot-dog`
class MemorablePasswordStrategy implements IPasswordGenerationStrategy {
  final Random _random = Random.secure();
  final String separator;
  final bool capitalize;

  MemorablePasswordStrategy({this.separator = '-', this.capitalize = false});

  @override
  String generate(PasswordGeneratorConfig config) {
    validate(config);

    List<String> passwordWords = [];
    for (int i = 0; i < config.length; i++) {
      String word = words[_random.nextInt(words.length)];
      if (capitalize) {
        word = word[0].toUpperCase() + word.substring(1);
      }
      passwordWords.add(word);
    }
    return passwordWords.join(separator);
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    if (config.length < 4) {
      throw ArgumentError(
        'Number of words must be at least 4 for this strategy.',
      );
    }
  }
}
