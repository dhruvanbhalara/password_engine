import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('PasswordStringX', () {
    test('hasUpperCase detects uppercase letters', () {
      expect('abc'.hasUpperCase, isFalse);
      expect('Abc'.hasUpperCase, isTrue);
      expect(''.hasUpperCase, isFalse);
      expect(('a' * 1000 + 'A').hasUpperCase, isTrue);
      expect('123!@#'.hasUpperCase, isFalse);
    });

    test('hasLowerCase detects lowercase letters', () {
      expect('ABC'.hasLowerCase, isFalse);
      expect('aBC'.hasLowerCase, isTrue);
      expect(''.hasLowerCase, isFalse);
      expect(('A' * 1000 + 'a').hasLowerCase, isTrue);
    });

    test('hasNumber detects digits', () {
      expect('abc'.hasNumber, isFalse);
      expect('abc1'.hasNumber, isTrue);
      expect(''.hasNumber, isFalse);
      expect(('a' * 1000 + '5').hasNumber, isTrue);
    });

    test('hasSpecialChar detects symbols', () {
      expect('abc'.hasSpecialChar, isFalse);
      expect('abc!'.hasSpecialChar, isTrue);
      expect(''.hasSpecialChar, isFalse);
      expect(('a' * 1000 + '#').hasSpecialChar, isTrue);
    });

    test('hasSpace detects whitespace', () {
      expect('abc'.hasSpace, isFalse);
      expect('a b c'.hasSpace, isTrue);
      expect(''.hasSpace, isFalse);
      expect(('a' * 1000 + ' ').hasSpace, isTrue);
    });

    test('hasUnicode detects non-ASCII', () {
      expect('abc'.hasUnicode, isFalse);
      expect('abc\u{1F60A}'.hasUnicode, isTrue);
      expect(''.hasUnicode, isFalse);
      expect(('a' * 1000 + '\u03C0').hasUnicode, isTrue);
    });
  });
}
