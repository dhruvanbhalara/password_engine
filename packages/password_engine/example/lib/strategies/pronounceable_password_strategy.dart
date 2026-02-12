import 'dart:math';

import 'package:password_engine/password_engine.dart';

/// A password generation strategy that creates a pronounceable password.
///
/// This strategy generates a password by alternating between consonants and
/// vowels, creating a string of characters that is easy to pronounce, though
/// not necessarily a real word. This can make the password easier to remember
///.
///
/// Example: `datoki`
class PronounceablePasswordStrategy implements IPasswordGenerationStrategy {
  final Random _random = Random.secure();
  final List<String> _consonants = 'bcdfghjklmnpqrstvwxyz'.split('');
  final List<String> _vowels = 'aeiou'.split('');

  @override
  String generate(PasswordGeneratorConfig config) {
    validate(config);

    String password = '';
    for (int i = 0; i < config.length; i++) {
      if (i % 2 == 0) {
        password += _consonants[_random.nextInt(_consonants.length)];
      } else {
        password += _vowels[_random.nextInt(_vowels.length)];
      }
    }
    return password;
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    if (config.length < 4) {
      throw ArgumentError(
        'Password length must be at least 4 for this strategy.',
      );
    }
  }
}
