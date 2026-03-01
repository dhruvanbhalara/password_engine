import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$CharacterSetResolver', () {
    test(
      'resolves default configuration (all enabled, non-ambiguous false)',
      () {
        final config = const PasswordGeneratorConfig();
        final sets = CharacterSetResolver.resolve(config);

        expect(sets.length, equals(4));
        expect(
          sets[CharacterSetType.upper],
          equals(CharacterSetProfile.defaultProfile.upperCaseLetters),
        );
        expect(
          sets[CharacterSetType.lower],
          equals(CharacterSetProfile.defaultProfile.lowerCaseLetters),
        );
        expect(
          sets[CharacterSetType.number],
          equals(CharacterSetProfile.defaultProfile.numbers),
        );
        expect(
          sets[CharacterSetType.special],
          equals(CharacterSetProfile.defaultProfile.specialCharacters),
        );
      },
    );

    test('resolves empty when everything is disabled', () {
      final config = const PasswordGeneratorConfig(
        useUpperCase: false,
        useLowerCase: false,
        useNumbers: false,
        useSpecialChars: false,
      );
      final sets = CharacterSetResolver.resolve(config);

      expect(sets, isEmpty);
    });

    test('resolves only explicitly enabled sets', () {
      final config = const PasswordGeneratorConfig(
        useUpperCase: true,
        useLowerCase: false,
        useNumbers: true,
        useSpecialChars: false,
      );
      final sets = CharacterSetResolver.resolve(config);

      expect(sets.length, equals(2));
      expect(sets.containsKey(CharacterSetType.upper), isTrue);
      expect(sets.containsKey(CharacterSetType.number), isTrue);
      expect(sets.containsKey(CharacterSetType.lower), isFalse);
      expect(sets.containsKey(CharacterSetType.special), isFalse);
    });

    test('respects excludeAmbiguousChars flag', () {
      final config = const PasswordGeneratorConfig(excludeAmbiguousChars: true);
      final sets = CharacterSetResolver.resolve(config);

      expect(
        sets[CharacterSetType.upper],
        equals(CharacterSetProfile.defaultProfile.upperCaseLettersNonAmbiguous),
      );
      expect(
        sets[CharacterSetType.lower],
        equals(CharacterSetProfile.defaultProfile.lowerCaseLettersNonAmbiguous),
      );
      expect(
        sets[CharacterSetType.number],
        equals(CharacterSetProfile.defaultProfile.numbersNonAmbiguous),
      );
      expect(
        sets[CharacterSetType.special],
        equals(
          CharacterSetProfile.defaultProfile.specialCharactersNonAmbiguous,
        ),
      );
    });

    test('uses custom CharacterSetProfile', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: 'A',
        lowerCaseLetters: 'b',
        numbers: '1',
        specialCharacters: '*',
        upperCaseLettersNonAmbiguous: 'C',
        lowerCaseLettersNonAmbiguous: 'd',
        numbersNonAmbiguous: '2',
        specialCharactersNonAmbiguous: '&',
      );

      final config = const PasswordGeneratorConfig(
        characterSetProfile: customProfile,
      );

      final sets = CharacterSetResolver.resolve(config);
      expect(sets[CharacterSetType.upper], equals('A'));
      expect(sets[CharacterSetType.lower], equals('b'));
      expect(sets[CharacterSetType.number], equals('1'));
      expect(sets[CharacterSetType.special], equals('*'));

      final nonAmbiguousConfig = const PasswordGeneratorConfig(
        characterSetProfile: customProfile,
        excludeAmbiguousChars: true,
      );

      final nonAmbiguousSets = CharacterSetResolver.resolve(nonAmbiguousConfig);
      expect(nonAmbiguousSets[CharacterSetType.upper], equals('C'));
      expect(nonAmbiguousSets[CharacterSetType.lower], equals('d'));
      expect(nonAmbiguousSets[CharacterSetType.number], equals('2'));
      expect(nonAmbiguousSets[CharacterSetType.special], equals('&'));
    });

    test('param overrides take precedence over config', () {
      final config = const PasswordGeneratorConfig(
        useUpperCase: false,
        useLowerCase: false,
        useNumbers: false,
        useSpecialChars: false,
      );

      final sets = CharacterSetResolver.resolve(
        config,
        useUpperCase: true,
        useNumbers: true,
      );

      expect(sets.length, equals(2));
      expect(sets.containsKey(CharacterSetType.upper), isTrue);
      expect(sets.containsKey(CharacterSetType.number), isTrue);
      expect(sets.containsKey(CharacterSetType.lower), isFalse);
      expect(sets.containsKey(CharacterSetType.special), isFalse);
    });
  });
}
