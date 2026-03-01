import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$ConfigAwarePasswordValidator', () {
    late ConfigAwarePasswordValidator validator;

    setUp(() {
      validator = ConfigAwarePasswordValidator();
    });

    test('isStrongPassword fallback passes for length > 16', () {
      expect(validator.isStrongPassword('V3ryL0ngP@ssw0rd!Extra'), isTrue);
      expect(validator.isStrongPassword('weak'), isFalse);
    });

    test('fails if length < minLength (default 16)', () {
      final config = PasswordGeneratorConfig();
      expect(validator.isStrongPasswordWithConfig('short', config), isFalse);
    });
    test('fails if length > maxLength', () {
      final config = PasswordGeneratorConfig(
        policy: PasswordPolicy(maxLength: 10, minLength: 8),
      );
      expect(
        validator.isStrongPasswordWithConfig('longer_than_ten', config),
        isFalse,
      );
    });

    test('passes if length is exactly maxLength', () {
      final config = PasswordGeneratorConfig(
        policy: PasswordPolicy(maxLength: 10, minLength: 8),
      );

      expect(
        validator.isStrongPasswordWithConfig('Exact10P@s', config),
        isTrue,
      );
    });

    test('fails if allowUnicode is false and non-ascii present', () {
      final config = PasswordGeneratorConfig(
        policy: PasswordPolicy(allowUnicode: false),
      );

      expect(
        validator.isStrongPasswordWithConfig('Password!123\u03C0', config),
        isFalse,
      );
    });

    test('fails if allowSpaces is false and space present', () {
      final config = PasswordGeneratorConfig(
        policy: PasswordPolicy(allowSpaces: false),
      );
      expect(
        validator.isStrongPasswordWithConfig('Password! 12345', config),
        isFalse,
      );
    });

    group('Requirement Checks', () {
      test('fails when missing required uppercase', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(requireUppercase: true),
        );
        expect(
          validator.isStrongPasswordWithConfig('password!1234567', config),
          isFalse,
        );
      });

      test('fails when missing required lowercase', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(requireLowercase: true),
        );
        expect(
          validator.isStrongPasswordWithConfig('PASSWORD!1234567', config),
          isFalse,
        );
      });

      test('fails when missing required numbers', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(requireNumber: true),
        );
        expect(
          validator.isStrongPasswordWithConfig('Password!abcdefg', config),
          isFalse,
        );
      });

      test('fails when missing required specials', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(requireSpecial: true),
        );
        expect(
          validator.isStrongPasswordWithConfig('Password12345678', config),
          isFalse,
        );
      });

      test('allows spaces as special if allowSpaces is true', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(requireSpecial: true, allowSpaces: true),
        );
        expect(
          validator.isStrongPasswordWithConfig('Password 12345678', config),
          isTrue,
        );
      });

      test('security invariant: honors custom CharacterSetProfile', () {
        const customProfile = CharacterSetProfile(
          upperCaseLetters: '!',
          lowerCaseLetters: 'a',
          numbers: '1',
          specialCharacters: 'X',
          upperCaseLettersNonAmbiguous: '!',
          lowerCaseLettersNonAmbiguous: 'a',
          numbersNonAmbiguous: '1',
          specialCharactersNonAmbiguous: 'X',
        );
        final config = PasswordGeneratorConfig(
          characterSetProfile: customProfile,
          policy: PasswordPolicy(requireUppercase: true, minLength: 4),
        );

        expect(validator.isStrongPasswordWithConfig('!a1X', config), isTrue);

        expect(validator.isStrongPasswordWithConfig('Aa1X', config), isFalse);
      });
    });

    group('Entropy & Threshold Checks', () {
      test('passes high score threshold', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(scoreThreshold: 3),
        );

        final pass = 'A!2b' * 10;
        expect(validator.isStrongPasswordWithConfig(pass, config), isTrue);
      });

      test('fails low score threshold', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(scoreThreshold: 4),
        );

        expect(
          validator.isStrongPasswordWithConfig('AAAAAAAAAAAAAAAA', config),
          isFalse,
        );
      });

      test('passes strength threshold', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(strengthThreshold: PasswordStrength.strong),
        );

        final pass = 'A!2bC#4dE%6fG&8hI(0j';
        expect(validator.isStrongPasswordWithConfig(pass, config), isTrue);
      });

      test('fails strength threshold', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(
            strengthThreshold: PasswordStrength.veryStrong,
          ),
        );

        expect(
          validator.isStrongPasswordWithConfig('aaaaaaaaaaaaaaaa', config),
          isFalse,
        );
      });

      test('entropy fallback for 0 pool size', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(
            scoreThreshold: 1,
            requireUppercase: false,
            requireLowercase: false,
            requireNumber: false,
            requireSpecial: false,
          ),
        );

        expect(
          validator.isStrongPasswordWithConfig(
            '\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}',
            config,
          ),
          isFalse,
        );
      });

      test('entropy fallback for empty password', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(
            scoreThreshold: 1,
            minLength: 0,
            requireUppercase: false,
            requireLowercase: false,
            requireNumber: false,
            requireSpecial: false,
          ),
        );
        expect(validator.isStrongPasswordWithConfig('', config), isFalse);
      });

      test('entropy spaces evaluation check', () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(scoreThreshold: 1, allowSpaces: true),
          useUpperCase: false,
          useLowerCase: false,
          useNumbers: false,
          useSpecialChars: false,
        );

        expect(
          validator.isStrongPasswordWithConfig('                ', config),
          isTrue,
        );
      });
    });
  });
}
