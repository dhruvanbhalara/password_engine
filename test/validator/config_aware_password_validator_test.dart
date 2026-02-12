import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

import '../test_helpers.dart';

void main() {
  group('ConfigAwarePasswordValidator', () {
    test('accepts strong mixed password', () {
      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPassword('Aa1!aaaaaaaa'), isTrue);
    });

    test('rejects too-short password', () {
      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPassword('Aa1!aaaaaaa'), isFalse);
    });

    test('rejects missing uppercase', () {
      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPassword('aa1!aaaaaaaa'), isFalse);
    });

    test('rejects missing lowercase', () {
      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPassword('AA1!AAAAAAAA'), isFalse);
    });

    test('allows lowercase-only when configured', () {
      final validator = ConfigAwarePasswordValidator();
      const config = PasswordGeneratorConfig(
        useUpperCase: false,
        useNumbers: false,
        useSpecialChars: false,
      );
      expect(
        validator.isStrongPasswordWithConfig('aaaaaaaaaaaa', config),
        isTrue,
      );
    });

    test('allows numbers-only when configured', () {
      final validator = ConfigAwarePasswordValidator();
      const config = PasswordGeneratorConfig(
        useUpperCase: false,
        useLowerCase: false,
        useSpecialChars: false,
      );
      expect(
        validator.isStrongPasswordWithConfig('111111111111', config),
        isTrue,
      );
    });

    test('rejects ambiguous numbers when excluded', () {
      final validator = ConfigAwarePasswordValidator();
      const config = PasswordGeneratorConfig(
        useUpperCase: false,
        useLowerCase: false,
        useSpecialChars: false,
        excludeAmbiguousChars: true,
      );
      expect(
        validator.isStrongPasswordWithConfig('111111111111', config),
        isFalse,
      );
    });

    test('supports custom specials', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: '',
        lowerCaseLetters: '',
        numbers: '',
        specialCharacters: '`~',
        upperCaseLettersNonAmbiguous: '',
        lowerCaseLettersNonAmbiguous: '',
        numbersNonAmbiguous: '',
        specialCharactersNonAmbiguous: '`~',
      );

      final validator = ConfigAwarePasswordValidator();
      const config = PasswordGeneratorConfig(
        useUpperCase: false,
        useLowerCase: false,
        useNumbers: false,
        useSpecialChars: true,
        characterSetProfile: customProfile,
      );

      expect(
        validator.isStrongPasswordWithConfig(repeatChar('`', 12), config),
        isTrue,
      );
    });

    test('honors policy minLength and requirements', () {
      const policy = PasswordPolicy(minLength: 4, requireNumber: true);
      const config = PasswordGeneratorConfig(
        useUpperCase: false,
        useLowerCase: false,
        useSpecialChars: false,
        policy: policy,
      );

      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPasswordWithConfig('1234', config), isTrue);
    });

    test('enforces policy maxLength', () {
      const policy = PasswordPolicy(minLength: 4, maxLength: 5);
      const config = PasswordGeneratorConfig(
        useUpperCase: false,
        useLowerCase: false,
        useNumbers: false,
        useSpecialChars: false,
        policy: policy,
      );

      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPasswordWithConfig('aaaaaa', config), isFalse);
    });

    test('treats space as special when allowed', () {
      const policy = PasswordPolicy(
        minLength: 5,
        requireSpecial: true,
        allowSpaces: true,
      );
      const config = PasswordGeneratorConfig(policy: policy);

      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPasswordWithConfig('word ', config), isTrue);
    });
  });
}
