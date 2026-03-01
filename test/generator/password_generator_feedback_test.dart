import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

import 'password_generator_test_helpers.dart';

void main() {
  late PasswordGenerator generator;

  setUp(() {
    generator = PasswordGenerator();
  });

  group('$PasswordGenerator feedback', () {
    test('estimateFeedback returns warnings for weak passwords', () {
      final feedback = generator.estimateFeedback('password');
      expect(feedback.strength, PasswordStrength.veryWeak);
      expect(feedback.warning, isNotNull);
      expect(feedback.suggestions, isNotEmpty);
    });

    test('estimateFeedback handles empty string gracefully', () {
      final feedback = generator.estimateFeedback('');
      expect(feedback.strength, PasswordStrength.veryWeak);
      expect(feedback.warning, isNotNull);
    });

    test('estimateFeedback handles very long string gracefully', () {
      final longPass = 'A' * 1000;
      final feedback = generator.estimateFeedback(longPass);

      expect(feedback.strength, isNotNull);
    });

    test('estimateFeedback derives score from entropy', () {
      final customGenerator = PasswordGenerator(
        strengthEstimator: MismatchedScoreEstimator(),
      );

      final feedback = customGenerator.estimateFeedback('password');
      // MismatchedScoreEstimator returns entropy=10.0, ignoring the explicit score=4
      // Since score is now derived from entropy, 10.0 → veryWeak → index 0
      expect(feedback.score, equals(PasswordStrength.veryWeak.index));
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

    test('estimateFeedback uses non-contextual provider when applicable', () {
      final plainProvider = PlainFeedbackProvider();
      final customGenerator = PasswordGenerator(
        feedbackProvider: plainProvider,
      );

      final feedback = customGenerator.estimateFeedback('test');
      expect(plainProvider.lastStrength, PasswordStrength.veryWeak);
      expect(feedback.strength, PasswordStrength.veryWeak);
    });

    test(
      'updateConfig throws AssertionError when maxGenerationAttempts is 0',
      () {
        final customGenerator = PasswordGenerator();
        expect(
          () => customGenerator.updateConfig(
            const PasswordGeneratorConfig(maxGenerationAttempts: 0),
          ),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    test(
      'estimateFeedback handles allowSpaces policy for entropy calculation',
      () {
        final customGenerator = PasswordGenerator();
        customGenerator.updateConfig(
          const PasswordGeneratorConfig(
            policy: PasswordPolicy(allowSpaces: true),
          ),
        );

        final feedback = customGenerator.estimateFeedback('word1 word2');
        expect(feedback.strength, isNotNull);
      },
    );
  });
}
