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
