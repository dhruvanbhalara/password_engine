import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordValidator', () {
    final validator = PasswordValidator();

    group('containsUpperCase', () {
      test(
        'returns true when string contains at least one uppercase letter',
        () {
          expect(validator.containsUpperCase('abcA'), isTrue);
        },
      );
      test('returns false when string has no uppercase letters', () {
        expect(validator.containsUpperCase('abc'), isFalse);
      });
      test('returns true for all-uppercase string', () {
        expect(validator.containsUpperCase('ABCDEFG'), isTrue);
      });
      test('returns false for empty string', () {
        expect(validator.containsUpperCase(''), isFalse);
      });
      test('only matches A-Z characters', () {
        expect(validator.containsUpperCase('123!@#'), isFalse);
        expect(validator.containsUpperCase('Z'), isTrue);
      });
    });

    group('containsLowerCase', () {
      test(
        'returns true when string contains at least one lowercase letter',
        () {
          expect(validator.containsLowerCase('ABCa'), isTrue);
        },
      );
      test('returns false when string has no lowercase letters', () {
        expect(validator.containsLowerCase('ABC'), isFalse);
      });
      test('returns true for all-lowercase string', () {
        expect(validator.containsLowerCase('abcdefg'), isTrue);
      });
      test('returns false for empty string', () {
        expect(validator.containsLowerCase(''), isFalse);
      });
      test('only matches a-z characters', () {
        expect(validator.containsLowerCase('123!@#'), isFalse);
        expect(validator.containsLowerCase('z'), isTrue);
      });
    });

    group('containsNumber', () {
      test('returns true when string contains at least one digit', () {
        expect(validator.containsNumber('abc1'), isTrue);
      });
      test('returns false when string has no digits', () {
        expect(validator.containsNumber('abc'), isFalse);
      });
      test('returns true for all-digit string', () {
        expect(validator.containsNumber('1234567'), isTrue);
      });
      test('returns false for empty string', () {
        expect(validator.containsNumber(''), isFalse);
      });
      test('only matches 0-9 characters', () {
        expect(validator.containsNumber('abc!@#'), isFalse);
        expect(validator.containsNumber('0'), isTrue);
      });
    });

    group('containsSpecialChar', () {
      test(
        'returns true when string contains at least one special character',
        () {
          expect(validator.containsSpecialChar('abc!'), isTrue);
        },
      );
      test('returns false when string has no special characters', () {
        expect(validator.containsSpecialChar('abc'), isFalse);
      });
      test('returns true for multiple special characters', () {
        expect(validator.containsSpecialChar('!@#\$%^'), isTrue);
      });
      test('returns false for empty string', () {
        expect(validator.containsSpecialChar(''), isFalse);
      });
      test('recognises underscore as special character', () {
        expect(validator.containsSpecialChar('abc123'), isFalse);
        expect(validator.containsSpecialChar('_'), isTrue);
      });
    });

    group('isStrongPassword', () {
      test('returns true for password meeting all criteria', () {
        expect(validator.isStrongPassword('Strong123!@#ABCD'), isTrue);
      });
      test('returns false when length is below 16 characters', () {
        expect(validator.isStrongPassword('Strong123!@#ABC'), isFalse);
      });
      test('returns true for very long password with all required types', () {
        expect(validator.isStrongPassword('Strong' * 10 + '123!'), isTrue);
      });
      test('returns false when one or more character types are missing', () {
        expect(
          validator.isStrongPassword('OnlyLowercaseLongAndStillNoTypes'),
          isFalse,
        );
        expect(validator.isStrongPassword('NoSpecial123456789'), isFalse);
      });
      test('requires all types and minimum length of 16', () {
        const base = 'abcABC123!';
        expect(validator.isStrongPassword(base), isFalse);
        expect(validator.isStrongPassword('${base}Extra6'), isTrue);
      });
    });
  });
}
