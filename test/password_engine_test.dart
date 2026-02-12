import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

void main() {
  late PasswordGenerator generator;

  setUp(() {
    generator = PasswordGenerator();
  });

  group('PasswordGenerator', () {
    test('generates password with default settings', () {
      final password = generator.generatePassword();
      expect(password.length, equals(12)); // Default length is 12
    });

    test('generates password with custom length', () {
      final password = generator.generatePassword(length: 20);
      expect(password.length, equals(20));
    });

    test('generates password with only lowercase letters', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useNumbers: false,
        useSpecialChars: false,
      );
      expect(password, matches(RegExp(r'^[a-z]+$')));
    });

    test('generates password with all character types when enabled', () {
      final password = generator.generatePassword(length: 100);

      // Should contain at least one of each type
      expect(password, contains(RegExp(r'[A-Z]'))); // Uppercase
      expect(password, contains(RegExp(r'[a-z]'))); // Lowercase
      expect(password, contains(RegExp(r'[0-9]'))); // Numbers
      expect(
        password,
        contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]')),
      ); // Special
    });

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

    test('uses a custom character set profile', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: 'X',
        lowerCaseLetters: 'y',
        numbers: '7',
        specialCharacters: '!',
        upperCaseLettersNonAmbiguous: 'X',
        lowerCaseLettersNonAmbiguous: 'y',
        numbersNonAmbiguous: '7',
        specialCharactersNonAmbiguous: '!',
      );

      generator.updateConfig(
        const PasswordGeneratorConfig(characterSetProfile: customProfile),
      );

      final password = generator.generatePassword(length: 12);
      expect(password, matches(RegExp(r'^[Xy7!]+$')));
      expect(password, contains('X'));
      expect(password, contains('y'));
      expect(password, contains('7'));
      expect(password, contains('!'));
    });

    test('estimates password strength correctly', () {
      expect(generator.estimateStrength('password'), PasswordStrength.veryWeak);
      expect(generator.estimateStrength('password123'), PasswordStrength.weak);
      expect(
        generator.estimateStrength('Password123'),
        PasswordStrength.medium,
      );
      expect(
        generator.estimateStrength('Password123!'),
        PasswordStrength.strong,
      );
      expect(
        generator.estimateStrength('aVeryComplexPassword123!@#'),
        PasswordStrength.veryStrong,
      );
    });

    test('refreshPassword throws after max attempts', () {
      final weakGenerator = PasswordGenerator(
        generationStrategy: _WeakPasswordStrategy(),
      );
      weakGenerator.updateConfig(
        const PasswordGeneratorConfig(maxGenerationAttempts: 3),
      );

      expect(
        weakGenerator.refreshPassword,
        throwsA(
          isA<PasswordGenerationException>().having(
            (exception) => exception.code,
            'code',
            PasswordGenerationErrorCode.maxAttemptsExceeded,
          ),
        ),
      );
    });

    test('refreshPassword respects disabled character sets', () {
      generator.updateConfig(
        const PasswordGeneratorConfig(
          length: 12,
          useUpperCase: false,
          useNumbers: false,
          useSpecialChars: false,
        ),
      );

      final password = generator.refreshPassword();
      expect(password, matches(RegExp(r'^[a-z]+$')));
    });

    test('config-aware validator supports custom special set', () {
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

      final password = List.filled(12, '`').join();
      expect(validator.isStrongPasswordWithConfig(password, config), isTrue);
    });

    test('strength estimator honors custom special set', () {
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

      final estimator = PasswordStrengthEstimator(
        characterSetProfile: customProfile,
      );
      final password = List.filled(128, '`').join();

      expect(
        estimator.estimatePasswordStrength(password),
        PasswordStrength.veryStrong,
      );
    });
  });

  group('Generator and strategy - extra cases', () {
    test('uses updated config when no args are provided', () {
      generator.updateConfig(
        const PasswordGeneratorConfig(
          length: 16,
          useUpperCase: false,
          useNumbers: false,
          useSpecialChars: false,
        ),
      );

      final password = generator.generatePassword();
      expect(password.length, equals(16));
      expect(password, matches(RegExp(r'^[a-z]+$')));
    });

    test('generates numbers-only password', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        useSpecialChars: false,
      );
      expect(password, matches(RegExp(r'^[0-9]+$')));
    });

    test('generates specials-only password', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        useNumbers: false,
      );
      expect(password, matches(RegExp(r'^[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]+$')));
    });

    test('excludes ambiguous numbers when requested', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        useSpecialChars: false,
        excludeAmbiguousChars: true,
      );
      expect(password, matches(RegExp(r'^[2-9]+$')));
    });

    test('excludes ambiguous lowercase when requested', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useNumbers: false,
        useSpecialChars: false,
        excludeAmbiguousChars: true,
        length: 100,
      );
      expect(password, matches(RegExp(r'^[abcdefghijkmnpqrstuvwxyz]+$')));
    });

    test('generates uppercase-only password', () {
      final password = generator.generatePassword(
        useLowerCase: false,
        useNumbers: false,
        useSpecialChars: false,
      );
      expect(password, matches(RegExp(r'^[A-Z]+$')));
    });

    test('generates number+special only with required mix', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        length: 40,
      );
      expect(
        password,
        matches(RegExp(r'^[0-9!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]+$')),
      );
      expect(password, contains(RegExp(r'[0-9]')));
      expect(password, contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]')));
    });

    test('lastPassword tracks latest generated value', () {
      final password = generator.generatePassword();
      expect(generator.lastPassword, equals(password));
    });

    test('generates alpha-only when upper and lower enabled', () {
      final password = generator.generatePassword(
        useNumbers: false,
        useSpecialChars: false,
        length: 40,
      );
      expect(password, matches(RegExp(r'^[A-Za-z]+$')));
      expect(password, contains(RegExp(r'[A-Z]')));
      expect(password, contains(RegExp(r'[a-z]')));
    });

    test('generates number+special when letters disabled', () {
      final password = generator.generatePassword(
        useUpperCase: false,
        useLowerCase: false,
        length: 40,
      );
      expect(
        password,
        matches(RegExp(r'^[0-9!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]+$')),
      );
      expect(password, isNot(contains(RegExp(r'[A-Za-z]'))));
    });
  });

  group('Validator - extra cases', () {
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

    test('rejects missing number', () {
      final validator = PasswordValidator();
      expect(validator.isStrongPassword('Aa!!aaaaaaaa'), isFalse);
    });

    test('rejects missing special', () {
      final validator = PasswordValidator();
      expect(validator.isStrongPassword('Aa1Aaaaaaaaa'), isFalse);
    });

    test('config-aware allows lowercase-only', () {
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

    test('config-aware allows numbers-only', () {
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

    test('config-aware rejects ambiguous numbers when excluded', () {
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

    test('config-aware supports custom specials', () {
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
        validator.isStrongPasswordWithConfig('````````````', config),
        isTrue,
      );
    });
  });

  group('Strength estimator - extra cases', () {
    test('empty password is very weak', () {
      final estimator = PasswordStrengthEstimator();
      expect(estimator.estimatePasswordStrength(''), PasswordStrength.veryWeak);
    });

    test('lowercase length 8 is very weak', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength('aaaaaaaa'),
        PasswordStrength.veryWeak,
      );
    });

    test('lowercase length 10 is weak', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength('aaaaaaaaaa'),
        PasswordStrength.weak,
      );
    });

    test('lowercase length 13 is medium', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength('aaaaaaaaaaaaa'),
        PasswordStrength.medium,
      );
    });

    test('lowercase length 16 is strong', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength('aaaaaaaaaaaaaaaa'),
        PasswordStrength.strong,
      );
    });

    test('lowercase length 28 is very strong', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength(List.filled(28, 'a').join()),
        PasswordStrength.veryStrong,
      );
    });

    test('custom profile with mixed sets yields strong', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: 'AB',
        lowerCaseLetters: 'cd',
        numbers: '12',
        specialCharacters: '@#',
        upperCaseLettersNonAmbiguous: 'AB',
        lowerCaseLettersNonAmbiguous: 'cd',
        numbersNonAmbiguous: '12',
        specialCharactersNonAmbiguous: '@#',
      );

      final estimator = PasswordStrengthEstimator(
        characterSetProfile: customProfile,
      );
      final password = 'Ac1@${List.filled(26, 'A').join()}';

      expect(
        estimator.estimatePasswordStrength(password),
        PasswordStrength.strong,
      );
    });

    test('custom special-only profile yields very strong at length 128', () {
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

      final estimator = PasswordStrengthEstimator(
        characterSetProfile: customProfile,
      );
      final password = List.filled(128, '`').join();

      expect(
        estimator.estimatePasswordStrength(password),
        PasswordStrength.veryStrong,
      );
    });

    test('numbers length 12 is very weak', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength(List.filled(12, '1').join()),
        PasswordStrength.veryWeak,
      );
    });

    test('numbers length 13 is weak', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength(List.filled(13, '1').join()),
        PasswordStrength.weak,
      );
    });
  });

  group('Error and edge cases - extra cases', () {
    test('refreshPassword includes maxAttempts in exception', () {
      final weakGenerator = PasswordGenerator(
        generationStrategy: _WeakPasswordStrategy(),
      );
      weakGenerator.updateConfig(
        const PasswordGeneratorConfig(maxGenerationAttempts: 2),
      );

      expect(
        weakGenerator.refreshPassword,
        throwsA(
          isA<PasswordGenerationException>().having(
            (exception) => exception.maxAttempts,
            'maxAttempts',
            2,
          ),
        ),
      );
    });

    test('refreshPassword rejects non-positive max attempts', () {
      generator.updateConfig(
        const PasswordGeneratorConfig(maxGenerationAttempts: 0),
      );

      expect(generator.refreshPassword, throwsArgumentError);
    });

    test('generatePassword throws for length below 12', () {
      expect(() => generator.generatePassword(length: 8), throwsArgumentError);
    });

    test('generatePassword throws when no character sets enabled', () {
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

    test('generatePassword rejects empty enabled character set', () {
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

    test('generatePassword uses updateConfig length by default', () {
      generator.updateConfig(const PasswordGeneratorConfig(length: 18));
      final password = generator.generatePassword();
      expect(password.length, equals(18));
    });

    test('generator uses custom estimator when provided', () {
      final customGenerator = PasswordGenerator(
        strengthEstimator: _FixedStrengthEstimator(),
      );

      expect(
        customGenerator.estimateStrength('anything'),
        PasswordStrength.medium,
      );
    });

    test('refreshPassword uses custom validator behavior', () {
      final customGenerator = PasswordGenerator(
        validator: _AlwaysTrueValidator(),
        generationStrategy: _WeakPasswordStrategy(),
      );

      customGenerator.updateConfig(
        const PasswordGeneratorConfig(maxGenerationAttempts: 1),
      );

      expect(customGenerator.refreshPassword(), isNotEmpty);
    });

    test('random strategy validate rejects short length', () {
      final strategy = RandomPasswordStrategy();
      const config = PasswordGeneratorConfig(length: 8);

      expect(() => strategy.validate(config), throwsArgumentError);
    });

    test('refreshPassword returns a non-empty password', () {
      final password = generator.refreshPassword();
      expect(password, isNotEmpty);
    });
  });
}

class _WeakPasswordStrategy implements IPasswordGenerationStrategy {
  @override
  String generate(PasswordGeneratorConfig config) {
    return List.filled(config.length, 'a').join();
  }

  @override
  void validate(PasswordGeneratorConfig config) {}
}

class _FixedStrengthEstimator implements IPasswordStrengthEstimator {
  @override
  PasswordStrength estimatePasswordStrength(String password) {
    return PasswordStrength.medium;
  }
}

class _AlwaysTrueValidator implements IPasswordValidator {
  @override
  bool isStrongPassword(String password) => true;

  @override
  bool containsUpperCase(String password) => true;

  @override
  bool containsLowerCase(String password) => true;

  @override
  bool containsNumber(String password) => true;

  @override
  bool containsSpecialChar(String password) => true;
}
