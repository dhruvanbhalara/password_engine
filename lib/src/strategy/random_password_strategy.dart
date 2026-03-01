import 'dart:math';

import '../../l10n/messages.i18n.dart';
import '../config/config_extensions.dart';
import '../config/password_generator_config.dart';
import '../model/password_policy.dart';
import '../utils/random_extensions.dart';
import 'ipassword_generation_strategy.dart';

/// Default strategy that generates random passwords from a character pool.
final class RandomPasswordStrategy implements IPasswordGenerationStrategy {
  /// Maximum allowed password length to prevent excessive memory/CPU usage.
  static const int maxAllowedLength = 1024;

  final Random _random = Random.secure();
  @override
  String generate(PasswordGeneratorConfig config) {
    validate(config);

    final random = _random;
    final enabledSets = config.resolveCharacterSets().values.toList();
    final characters = <String>[];

    // Ensure at least one character from each enabled set.
    for (final charSet in enabledSets) {
      characters.add(random.choice(charSet));
    }

    // Fill remaining length from the combined pool.
    // When config.length == enabledSets.length, remaining is 0 — no fill needed.
    final combinedPool = enabledSets.join();
    final remaining = config.length - characters.length;
    for (var i = 0; i < remaining; i++) {
      characters.add(random.choice(combinedPool));
    }

    characters.shuffle(random);
    return characters.join();
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    final messages = const Messages();
    final minLength = PasswordPolicy.defaultMinLength;
    if (config.length < minLength) {
      throw ArgumentError(messages.error.passwordLengthMin(minLength));
    }
    if (config.length > maxAllowedLength) {
      throw ArgumentError(
        'Password length (${config.length}) cannot exceed $maxAllowedLength.',
      );
    }
    final enabledSets = config.resolveCharacterSets().values.toList();
    final enabledCount = enabledSets.length;
    if (enabledCount == 0) {
      throw ArgumentError(messages.error.atLeastOneCharType);
    }
    if (config.length < enabledCount) {
      throw ArgumentError(
        'Password length (${config.length}) must be at least $enabledCount '
        'to guarantee one character from each enabled set.',
      );
    }
    for (final charSet in enabledSets) {
      if (charSet.isEmpty) {
        throw ArgumentError(messages.error.selectedCharSetsNotEmpty);
      }
    }
  }
}
