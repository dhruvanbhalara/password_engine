import 'dart:math';

import '../../l10n/messages.i18n.dart';
import '../config/password_generator_config.dart';
import 'ipassword_generation_strategy.dart';

/// Strategy that generates passphrases by joining random words from a wordlist.
final class PassphrasePasswordStrategy implements IPasswordGenerationStrategy {
  /// Creates a [PassphrasePasswordStrategy] with the given [wordlist].
  PassphrasePasswordStrategy({
    required List<String> wordlist,
    this.separator = '-',
    this.capitalize = false,
    this.allowDuplicates = true,
  }) : _wordlist = List.unmodifiable(wordlist);

  final List<String> _wordlist;
  List<String>? _uniqueWordlistCache;
  List<String> get _uniqueWordlist =>
      _uniqueWordlistCache ??= List.unmodifiable(_wordlist.toSet());

  /// The separator between words in the passphrase.
  final String separator;

  /// Whether to capitalize the first letter of each word.
  final bool capitalize;

  /// Whether the same word may appear more than once.
  final bool allowDuplicates;

  final Random _random = Random.secure();

  @override
  String generate(PasswordGeneratorConfig config) {
    validate(config);

    final wordCount = config.extra['wordCount'] as int? ?? config.length;
    final random = _random;
    final words = <String>[];

    if (allowDuplicates) {
      for (var i = 0; i < wordCount; i++) {
        final word = _pickWord(random);
        words.add(_applyCase(word));
      }
      return words.join(separator);
    }

    final pool = List<String>.from(_uniqueWordlist);
    pool.shuffle(random);
    for (var i = 0; i < wordCount; i++) {
      words.add(_applyCase(pool[i]));
    }
    return words.join(separator);
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    final messages = const Messages();
    if (_wordlist.isEmpty) {
      throw ArgumentError(messages.error.wordlistEmpty);
    }
    if (_wordlist.any((word) => word.isEmpty)) {
      throw ArgumentError(messages.error.wordlistHasEmptyWords);
    }
    final wordCount = config.extra['wordCount'] as int? ?? config.length;
    if (wordCount <= 0) {
      throw ArgumentError(messages.error.wordCountPositive);
    }
    if (!allowDuplicates && wordCount > _uniqueWordlist.length) {
      throw ArgumentError(messages.error.wordCountExceedsWordlist);
    }
  }

  String _pickWord(Random random) {
    return _wordlist[random.nextInt(_wordlist.length)];
  }

  String _applyCase(String word) {
    if (!capitalize) return word;
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }
}
