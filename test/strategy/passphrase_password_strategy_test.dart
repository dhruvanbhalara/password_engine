import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

void main() {
  group('PassphrasePasswordStrategy', () {
    test('generates expected word count', () {
      final strategy = PassphrasePasswordStrategy(
        wordlist: ['alpha', 'beta', 'gamma', 'delta'],
        separator: '-',
      );
      final generator = PasswordGenerator(generationStrategy: strategy);
      generator.updateConfig(const PasswordGeneratorConfig(length: 4));

      final passphrase = generator.generatePassword();
      final words = passphrase.split('-');

      expect(words.length, equals(4));
      for (final word in words) {
        expect(['alpha', 'beta', 'gamma', 'delta'], contains(word));
      }
    });

    test('rejects empty wordlist', () {
      final strategy = PassphrasePasswordStrategy(wordlist: []);
      const config = PasswordGeneratorConfig(length: 3);

      expect(() => strategy.validate(config), throwsArgumentError);
    });

    test('rejects too many unique words', () {
      final strategy = PassphrasePasswordStrategy(
        wordlist: ['alpha', 'beta'],
        allowDuplicates: false,
      );
      const config = PasswordGeneratorConfig(length: 3);

      expect(() => strategy.validate(config), throwsArgumentError);
    });
  });
}
