import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

import 'password_generator_test_helpers.dart';

void main() {
  late PasswordGenerator generator;

  setUp(() {
    generator = PasswordGenerator();
  });

  group('$PasswordGenerator refresh behavior', () {
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
          isA<MaxAttemptsExceededException>().having(
            (exception) => exception.maxAttempts,
            'maxAttempts',
            2,
          ),
        ),
      );
    });

    test(
      'refreshPassword delegates to isStrongPasswordWithConfig on config-aware validators',
      () {
        final configAwareValidator = ConfigAwareValidatorMock();
        final customGenerator = PasswordGenerator(
          validator: configAwareValidator,
          generationStrategy: WeakPasswordStrategy(),
        );

        customGenerator.updateConfig(
          const PasswordGeneratorConfig(maxGenerationAttempts: 2),
        );

        expect(
          () => customGenerator.refreshPassword(),
          throwsA(isA<PasswordGenerationException>()),
        );
        expect(configAwareValidator.calledWithConfig, isTrue);
      },
    );

    test('refreshPassword respects disabled character sets', () {
      generator.updateConfig(
        const PasswordGeneratorConfig(
          length: 16,
          useUpperCase: false,
          useNumbers: false,
          useSpecialChars: false,
        ),
      );

      final password = generator.refreshPassword();
      expect(password, matches(lowerOnlyPattern));
    });

    test('refreshPassword rejects non-positive max attempts', () {
      expect(
        () => generator.updateConfig(
          const PasswordGeneratorConfig(maxGenerationAttempts: 0),
        ),
        throwsA(isA<AssertionError>()),
      );
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

    test(
      'refreshPassword validates the normalizer output, not the raw password',
      () {
        final customGenerator = PasswordGenerator(
          validator: ExactMatchValidator('normalized'),
          normalizer: FunctionNormalizer((_) => 'normalized'),
          generationStrategy: WeakPasswordStrategy(),
        );

        customGenerator.updateConfig(
          const PasswordGeneratorConfig(maxGenerationAttempts: 1),
        );

        expect(customGenerator.refreshPassword(), isNotEmpty);
      },
    );
  });
}
