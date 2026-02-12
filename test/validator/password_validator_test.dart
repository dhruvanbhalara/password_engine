import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

void main() {
  group('PasswordValidator', () {
    test('accepts strong mixed password', () {
      final validator = PasswordValidator();
      expect(validator.isStrongPassword('Aa1!aaaaaaaa'), isTrue);
    });

    test('rejects too-short password', () {
      final validator = PasswordValidator();
      expect(validator.isStrongPassword('Aa1!aaaaaaa'), isFalse);
    });

    test('rejects missing uppercase', () {
      final validator = PasswordValidator();
      expect(validator.isStrongPassword('aa1!aaaaaaaa'), isFalse);
    });

    test('rejects missing lowercase', () {
      final validator = PasswordValidator();
      expect(validator.isStrongPassword('AA1!AAAAAAAA'), isFalse);
    });

    test('rejects missing number', () {
      final validator = PasswordValidator();
      expect(validator.isStrongPassword('Aa!!aaaaaaaa'), isFalse);
    });

    test('rejects missing special', () {
      final validator = PasswordValidator();
      expect(validator.isStrongPassword('Aa1Aaaaaaaaa'), isFalse);
    });
  });
}
