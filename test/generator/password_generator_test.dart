import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

import '../test_helpers.dart';

void main() {
  late PasswordGenerator generator;

  setUp(() {
    generator = PasswordGenerator();
  });

  group('PasswordGenerator basics', () {
    test('generates password with default settings', () {
      final password = generator.generatePassword();
      expect(password.length, equals(12));
    });

    test('generates password with custom length', () {
      final password = generator.generatePassword(length: 20);
      expect(password.length, equals(20));
    });

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
      expect(password, matches(lowerOnlyPattern));
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

    test('uses custom estimator when provided', () {
      final customGenerator = PasswordGenerator(
        strengthEstimator: FixedStrengthEstimator(),
      );

      expect(
        customGenerator.estimateStrength('anything'),
        PasswordStrength.medium,
      );
    });

    test('estimateFeedback returns warnings for weak passwords', () {
      final feedback = generator.estimateFeedback('password');
      expect(feedback.strength, PasswordStrength.veryWeak);
      expect(feedback.warning, isNotNull);
      expect(feedback.suggestions, isNotEmpty);
    });

    test('estimateFeedback provides context when supported', () {
      final provider = CapturingFeedbackProvider();
      final customGenerator = PasswordGenerator(
        feedbackProvider: provider,
        normalizer: FunctionNormalizer((value) => value.trim()),
      );
      customGenerator.updateConfig(const PasswordGeneratorConfig(length: 14));

      customGenerator.estimateFeedback(' pass ');

      expect(provider.lastContext?.password, ' pass ');
      expect(provider.lastContext?.normalizedPassword, 'pass');
      expect(provider.lastContext?.config.length, 14);
    });

    test('normalizer affects estimateStrength', () {
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

  group('PasswordGenerator refresh behavior', () {
    test('refreshPassword throws after max attempts', () {
      final weakGenerator = PasswordGenerator(
        generationStrategy: WeakPasswordStrategy(),
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

    test('refreshPassword includes maxAttempts in exception', () {
      final weakGenerator = PasswordGenerator(
        generationStrategy: WeakPasswordStrategy(),
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
      expect(password, matches(lowerOnlyPattern));
    });

    test('refreshPassword rejects non-positive max attempts', () {
      generator.updateConfig(
        const PasswordGeneratorConfig(maxGenerationAttempts: 0),
      );

      expect(generator.refreshPassword, throwsArgumentError);
    });

    test('refreshPassword returns a non-empty password', () {
      final password = generator.refreshPassword();
      expect(password, isNotEmpty);
    });

    test('refreshPassword uses custom validator behavior', () {
      final customGenerator = PasswordGenerator(
        validator: AlwaysTrueValidator(),
        generationStrategy: WeakPasswordStrategy(),
      );

      customGenerator.updateConfig(
        const PasswordGeneratorConfig(maxGenerationAttempts: 1),
      );

      expect(customGenerator.refreshPassword(), isNotEmpty);
    });

    test('normalizer is applied before validation', () {
      final customGenerator = PasswordGenerator(
        validator: ExactMatchValidator('normalized'),
        normalizer: FunctionNormalizer((_) => 'normalized'),
        generationStrategy: WeakPasswordStrategy(),
      );

      customGenerator.updateConfig(
        const PasswordGeneratorConfig(maxGenerationAttempts: 1),
      );

      expect(customGenerator.refreshPassword(), isNotEmpty);
    });
  });
}

class CapturingFeedbackProvider implements IContextualPasswordFeedbackProvider {
  PasswordFeedbackContext? lastContext;

  @override
  PasswordFeedback build(PasswordStrength strength) {
    return PasswordFeedback(strength: strength);
  }

  @override
  PasswordFeedback buildWithContext(PasswordFeedbackContext context) {
    lastContext = context;
    return PasswordFeedback(strength: context.strength);
  }
}
