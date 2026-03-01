import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

import 'password_generator_test_helpers.dart';

void main() {
  late PasswordGenerator generator;

  setUp(() {
    generator = PasswordGenerator();
  });

  group('$PasswordGenerator', () {
    test('generatePassword returns 16-char password by default', () {
      final password = generator.generatePassword();
      expect(password.length, equals(16));
    });

    test('generates password with custom length', () {
      final password = generator.generatePassword(length: 20);
      expect(password.length, equals(20));
    });

    test('generatePassword produces different outputs on successive calls', () {
      final p1 = generator.generatePassword();
      final p2 = generator.generatePassword();
      expect(p1, isNot(equals(p2)));
    });

    group('Password Length Validation', () {
      test('generates password of length 0 (throws exception in strategy)', () {
        expect(
          () => generator.generatePassword(length: 0),
          throwsArgumentError,
        );
      });

      test('generates password of negative length (throws exception)', () {
        expect(
          () => generator.generatePassword(length: -5),
          throwsArgumentError,
        );
      });

      test('generates password of length 1 (using mock strategy)', () {
        final mockGen = PasswordGenerator(generationStrategy: MockStrategy());
        final password = mockGen.generatePassword(length: 1);
        expect(password.length, equals(1));
      });

      test('generates password with length 4 (using mock strategy)', () {
        final mockGen = PasswordGenerator(generationStrategy: MockStrategy());
        final password = mockGen.generatePassword(length: 4);
        expect(password.length, equals(4));
        expect(password, equals('aaaa'));
      });

      test(
        'throws when length is less than number of required character types',
        () {
          expect(
            () => generator.generatePassword(length: 3),
            throwsArgumentError,
          );
        },
      );

      test('throws for length exceeding max allowed (1024)', () {
        expect(
          () => generator.generatePassword(length: 10000),
          throwsArgumentError,
        );
      });
    });

    test('uses updated config when no args are provided', () {
      generator.updateConfig(
        PasswordGeneratorConfig(
          length: 16,
          useUpperCase: false,
          useNumbers: false,
          useSpecialChars: false,
        ),
      );

      final password = generator.generatePassword();
      expect(password.length, equals(16));
      expect(password, matches(lowerOnlyPattern));
    });

    test('generatePassword returns normalized output', () {
      final customGenerator = PasswordGenerator(
        generationStrategy: FixedPasswordStrategy('  pass  '),
        normalizer: FunctionNormalizer((value) => value.trim()),
        validator: AlwaysTrueValidator(),
      );

      final password = customGenerator.generatePassword();
      expect(password, equals('pass'));
      expect(customGenerator.lastPassword, equals('pass'));
    });

    test('updateConfig can clear policy', () {
      generator.updateConfig(
        PasswordGeneratorConfig(policy: PasswordPolicy(minLength: 20)),
      );
      expect(generator.generatePassword().length, equals(20));

      generator.updateConfig(PasswordGeneratorConfig(length: 16));
      expect(generator.generatePassword().length, equals(16));
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
        PasswordGeneratorConfig.builder()
            .characterSetProfile(customProfile)
            .build(),
      );

      final password = generator.generatePassword(length: 16);
      expect(password, matches(RegExp(r'^[Xy7!]+$')));
      expect(password, contains('X'));
      expect(password, contains('y'));
      expect(password, contains('7'));
      expect(password, contains('!'));
    });

    test(
      'estimateStrength maps entropy bands to correct PasswordStrength levels',
      () {
        expect(
          generator.estimateStrength('password'),
          PasswordStrength.veryWeak,
        );
        expect(
          generator.estimateStrength('password123'),
          PasswordStrength.weak,
        );
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
      },
    );

    test('uses custom estimator when provided', () {
      final customGenerator = PasswordGenerator(
        strengthEstimator: FixedStrengthEstimator(),
      );

      expect(
        customGenerator.estimateStrength('anything'),
        PasswordStrength.medium,
      );
    });

    test('normalizer output is used for strength estimation', () {
      final customGenerator = PasswordGenerator(
        strengthEstimator: ExactMatchEstimator('normalized'),
        normalizer: FunctionNormalizer((_) => 'normalized'),
      );

      expect(customGenerator.estimateStrength('RAW'), PasswordStrength.strong);
    });

    test('lastPassword tracks latest generated value', () {
      final password = generator.generatePassword();
      expect(generator.lastPassword, equals(password));
    });
  });
}
