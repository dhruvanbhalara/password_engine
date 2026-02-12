import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

import '../test_helpers.dart';

void main() {
  late PasswordGenerator generator;

  setUp(() {
    generator = PasswordGenerator();
  });

  group('RandomPasswordStrategy generation', () {
    test('generates password with only lowercase letters', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useNumbers: false,
        useSpecialChars: false,
      );
      expect(password, matches(lowerOnlyPattern));
    });

    test('generates numbers-only password', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        useSpecialChars: false,
      );
      expect(password, matches(numberOnlyPattern));
    });

    test('generates specials-only password', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        useNumbers: false,
      );
      expect(password, matches(specialOnlyPattern));
    });

    test('generates uppercase-only password', () {
      final password = generator.generatePassword(
        useLowerCase: false,
        useNumbers: false,
        useSpecialChars: false,
      );
      expect(password, matches(upperOnlyPattern));
    });

    test('generates alpha-only when upper and lower enabled', () {
      final password = generator.generatePassword(
        useNumbers: false,
        useSpecialChars: false,
        length: 40,
      );
      expect(password, matches(alphaOnlyPattern));
      expect(password, contains(RegExp(r'[A-Z]')));
      expect(password, contains(RegExp(r'[a-z]')));
    });

    test('generates number+special only with required mix', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        length: 40,
      );
      expect(password, matches(numberOrSpecialPattern));
      expect(password, contains(RegExp(r'[0-9]')));
      expect(password, contains(specialPattern));
    });

    test('generates number+special when letters disabled', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        length: 40,
      );
      expect(password, matches(numberOrSpecialPattern));
      expect(password, isNot(contains(RegExp(r'[A-Za-z]'))));
    });

    test('excludes ambiguous numbers when requested', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        useSpecialChars: false,
        excludeAmbiguousChars: true,
      );
      expect(password, matches(numberOnlyNonAmbiguousPattern));
    });

    test('excludes ambiguous lowercase when requested', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useNumbers: false,
        useSpecialChars: false,
        excludeAmbiguousChars: true,
        length: 100,
      );
      expect(password, matches(lowerOnlyNonAmbiguousPattern));
    });

    test('excludes ambiguous characters when requested', () {
      final password = generator.generatePassword(
        length: 100,
        excludeAmbiguousChars: true,
      );
      expect(
        password,
        isNot(anyOf(contains('I'), contains('l'), contains('1'))),
      );
    });

    test('generates password with all character types when enabled', () {
      final password = generator.generatePassword(length: 100);
      expect(password, contains(RegExp(r'[A-Z]')));
      expect(password, contains(RegExp(r'[a-z]')));
      expect(password, contains(RegExp(r'[0-9]')));
      expect(password, contains(specialPattern));
    });
  });

  group('RandomPasswordStrategy validation errors', () {
    test('throws error for invalid length', () {
      expect(() => generator.generatePassword(length: 11), throwsArgumentError);
    });

    test('throws error when all character types are disabled', () {
      expect(
        () => generator.generatePassword(
          useUpperCase: false,
          useLowerCase: false,
          useNumbers: false,
          useSpecialChars: false,
        ),
        throwsArgumentError,
      );
    });

    test('rejects empty enabled character set', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: '',
        lowerCaseLetters: 'abc',
        numbers: '123',
        specialCharacters: '!@#',
        upperCaseLettersNonAmbiguous: '',
        lowerCaseLettersNonAmbiguous: 'abc',
        numbersNonAmbiguous: '123',
        specialCharactersNonAmbiguous: '!@#',
      );

      generator.updateConfig(
        const PasswordGeneratorConfig(characterSetProfile: customProfile),
      );

      expect(
        () => generator.generatePassword(useUpperCase: true),
        throwsArgumentError,
      );
    });

    test('validate rejects short length', () {
      final strategy = RandomPasswordStrategy();
      const config = PasswordGeneratorConfig(length: 8);

      expect(() => strategy.validate(config), throwsArgumentError);
    });
  });
}
