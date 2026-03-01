import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

final RegExp specialPattern = RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]');
final RegExp specialOnlyPattern = RegExp(
  r'^[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]+$',
);
final RegExp lowerOnlyPattern = RegExp(r'^[a-z]+$');
final RegExp upperOnlyPattern = RegExp(r'^[A-Z]+$');
final RegExp alphaOnlyPattern = RegExp(r'^[A-Za-z]+$');
final RegExp numberOnlyPattern = RegExp(r'^[0-9]+$');
final RegExp numberOnlyNonAmbiguousPattern = RegExp(r'^[2-9]+$');
final RegExp numberOrSpecialPattern = RegExp(
  r'^[0-9!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]+$',
);
final RegExp lowerOnlyNonAmbiguousPattern = RegExp(
  r'^[abcdefghijkmnpqrstuvwxyz]+$',
);

void main() {
  late PasswordGenerator generator;

  setUp(() {
    generator = PasswordGenerator();
  });

  group('$RandomPasswordStrategy', () {
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

  group('$RandomPasswordStrategy validation errors', () {
    test('throws error for invalid length', () {
      expect(() => generator.generatePassword(length: 15), throwsArgumentError);
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
      const config = PasswordGeneratorConfig(length: 15);

      expect(() => strategy.validate(config), throwsArgumentError);
    });

    test('validate rejects extremely large length (> 1024)', () {
      final strategy = RandomPasswordStrategy();
      const config = PasswordGeneratorConfig(length: 2000);

      expect(() => strategy.validate(config), throwsArgumentError);
    });

    test('validate accepts max allowed length (1024)', () {
      final strategy = RandomPasswordStrategy();
      const config = PasswordGeneratorConfig(length: 1024);

      expect(() => strategy.validate(config), returnsNormally);
    });
  });

  group('$RandomPasswordStrategy Randomness & Distribution', () {
    test('sequential generations yield different passwords', () {
      final p1 = generator.generatePassword(length: 20);
      final p2 = generator.generatePassword(length: 20);

      expect(p1, isNot(equals(p2)));
    });

    test('character sets are distributed reasonably', () {
      final password = generator.generatePassword(length: 100);

      int upperCount = 0;
      int lowerCount = 0;
      int numberCount = 0;
      int specialCount = 0;

      for (final char in password.split('')) {
        if (RegExp(r'[A-Z]').hasMatch(char)) {
          upperCount++;
        } else if (RegExp(r'[a-z]').hasMatch(char)) {
          lowerCount++;
        } else if (RegExp(r'[0-9]').hasMatch(char)) {
          numberCount++;
        } else {
          specialCount++;
        }
      }

      expect(upperCount, greaterThan(2));
      expect(lowerCount, greaterThan(2));
      expect(numberCount, greaterThan(2));
      expect(specialCount, greaterThan(2));
    });
  });
}
