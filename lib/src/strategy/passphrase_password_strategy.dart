import 'dart:math';

import '../config/password_generator_config.dart';
import 'ipassword_generation_strategy.dart';

/// A strategy that generates passphrases from a wordlist.
class PassphrasePasswordStrategy implements IPasswordGenerationStrategy {
  PassphrasePasswordStrategy({
    required List<String> wordlist,
    this.separator = '-',
    this.capitalize = false,
    this.allowDuplicates = true,
  }) : _wordlist = List.unmodifiable(wordlist);

  final List<String> _wordlist;
  final String separator;
  final bool capitalize;
  final bool allowDuplicates;

  @override
  String generate(PasswordGeneratorConfig config) {
    validate(config);

    final wordCount = config.length;
    final random = Random.secure();
    final words = <String>[];

    for (var i = 0; i < wordCount; i++) {
      final word = _pickWord(random, words);
      words.add(_applyCase(word));
    }

    return words.join(separator);
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    if (_wordlist.isEmpty) {
      throw ArgumentError('Wordlist must not be empty');
    }
    if (_wordlist.any((word) => word.isEmpty)) {
      throw ArgumentError('Wordlist must not contain empty words');
    }
    if (config.length <= 0) {
      throw ArgumentError('Word count must be greater than 0');
    }
    if (!allowDuplicates && config.length > _wordlist.length) {
      throw ArgumentError(
        'Word count exceeds wordlist size when duplicates are disabled',
      );
    }
  }

  String _pickWord(Random random, List<String> chosen) {
    if (allowDuplicates) {
      return _wordlist[random.nextInt(_wordlist.length)];
    }

    String word;
    do {
      word = _wordlist[random.nextInt(_wordlist.length)];
    } while (chosen.contains(word));

    return word;
  }

  String _applyCase(String word) {
    if (!capitalize) return word;
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }
}
