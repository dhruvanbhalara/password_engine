import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PassphrasePasswordStrategy', () {
    test('validate throws on empty wordlist', () {
      final strategy = PassphrasePasswordStrategy(wordlist: []);
      final config = const PasswordGeneratorConfig(length: 4);

      expect(() => strategy.validate(config), throwsArgumentError);
    });

    test('validate throws when wordlist contains empty word', () {
      final strategy = PassphrasePasswordStrategy(
        wordlist: ['hello', '', 'world'],
      );
      final config = const PasswordGeneratorConfig(length: 4);

      expect(() => strategy.validate(config), throwsArgumentError);
    });

    test('validate throws when word count <= 0', () {
      final strategy = PassphrasePasswordStrategy(wordlist: ['hello']);

      expect(
        () => strategy.validate(const PasswordGeneratorConfig(length: 0)),
        throwsArgumentError,
      );
      expect(
        () => strategy.validate(const PasswordGeneratorConfig(length: -1)),
        throwsArgumentError,
      );
    });

    test(
      'validate throws when duplicates disabled and word count > unique wordlist size',
      () {
        final strategy = PassphrasePasswordStrategy(
          wordlist: ['apple', 'apple', 'banana'],
          allowDuplicates: false,
        );

        final config = const PasswordGeneratorConfig(length: 3);

        expect(() => strategy.validate(config), throwsArgumentError);
      },
    );

    test('generate allows duplicates when enabled', () {
      final strategy = PassphrasePasswordStrategy(
        wordlist: ['apple'],
        allowDuplicates: true,
      );
      final config = const PasswordGeneratorConfig(length: 5);

      final phrase = strategy.generate(config);
      expect(phrase, equals('apple-apple-apple-apple-apple'));
    });

    test('generate uses unique words when duplicates disabled', () {
      final strategy = PassphrasePasswordStrategy(
        wordlist: ['apple', 'banana', 'cherry'],
        allowDuplicates: false,
        separator: '+',
      );
      final config = const PasswordGeneratorConfig(length: 3);

      final phrase = strategy.generate(config);
      final parts = phrase.split('+');

      expect(parts.length, equals(3));
      expect(parts.toSet().length, equals(3));
      expect(parts, containsAll(['apple', 'banana', 'cherry']));
    });

    test('capitalizes words when capitalize is true', () {
      final strategy = PassphrasePasswordStrategy(
        wordlist: ['apple', 'banana'],
        allowDuplicates: false,
        capitalize: true,
      );
      final config = const PasswordGeneratorConfig(length: 2);

      final phrase = strategy.generate(config);
      final parts = phrase.split('-');

      expect(parts, containsAll(['Apple', 'Banana']));
    });

    test('does not capitalize words when capitalize is false', () {
      final strategy = PassphrasePasswordStrategy(
        wordlist: ['apple', 'banana'],
        capitalize: false,
      );
      final config = const PasswordGeneratorConfig(length: 2);

      final phrase = strategy.generate(config);
      final parts = phrase.split('-');

      for (final part in parts) {
        expect(part, part.toLowerCase());
      }
    });
  });
}
