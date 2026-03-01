import 'package:password_engine/l10n/messages.i18n.dart';
import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordFeedbackBuilder', () {
    late PasswordFeedbackBuilder builder;
    const messages = Messages();

    setUp(() {
      builder = PasswordFeedbackBuilder();
    });

    test('build maps PasswordStrength.veryWeak correctly', () {
      final feedback = builder.build(PasswordStrength.veryWeak);
      expect(feedback.strength, equals(PasswordStrength.veryWeak));
      expect(feedback.warning, equals(messages.feedback.warning.tooWeak));
      expect(feedback.suggestions, isNotEmpty);
      expect(feedback.suggestions.length, equals(3));
    });

    test('build maps PasswordStrength.weak correctly', () {
      final feedback = builder.build(PasswordStrength.weak);
      expect(feedback.strength, equals(PasswordStrength.weak));
      expect(feedback.warning, equals(messages.feedback.warning.weak));
      expect(feedback.suggestions, isNotEmpty);
      expect(feedback.suggestions.length, equals(2));
    });

    test('build maps PasswordStrength.medium correctly', () {
      final feedback = builder.build(PasswordStrength.medium);
      expect(feedback.strength, equals(PasswordStrength.medium));
      expect(feedback.warning, equals(messages.feedback.warning.medium));
      expect(feedback.suggestions, isNotEmpty);
      expect(feedback.suggestions.length, equals(2));
    });

    test('build maps PasswordStrength.strong correctly', () {
      final feedback = builder.build(PasswordStrength.strong);
      expect(feedback.strength, equals(PasswordStrength.strong));
      expect(feedback.warning, isNull);
      expect(feedback.suggestions, isEmpty);
    });

    test('build maps PasswordStrength.veryStrong correctly', () {
      final feedback = builder.build(PasswordStrength.veryStrong);
      expect(feedback.strength, equals(PasswordStrength.veryStrong));
      expect(feedback.warning, isNull);
      expect(feedback.suggestions, isEmpty);
    });

    test(
      'buildWithContext provide specific suggestions for missing requirements',
      () {
        final config = PasswordGeneratorConfig(
          policy: PasswordPolicy(
            minLength: 20,
            requireUppercase: true,
            requireNumber: true,
            requireSpecial: true,
          ),
        );
        final context = PasswordFeedbackContext(
          password: 'password',
          normalizedPassword: 'password',
          strength: PasswordStrength.veryWeak,
          entropy: 20.0,
          config: config,
        );

        final feedback = builder.buildWithContext(context);

        expect(
          feedback.suggestions,
          contains(messages.feedback.suggestion.increaseLengthMin(20)),
        );
        expect(
          feedback.suggestions,
          contains(messages.feedback.suggestion.addUppercase),
        );
        expect(
          feedback.suggestions,
          contains(messages.feedback.suggestion.addNumber),
        );
        expect(
          feedback.suggestions,
          contains(messages.feedback.suggestion.addSpecial),
        );
        expect(
          feedback.warning,
          equals(messages.feedback.warning.policyNotMet),
        );
      },
    );

    test('buildWithContext provide score threshold suggestion', () {
      final config = PasswordGeneratorConfig(
        policy: PasswordPolicy(scoreThreshold: 3),
      );
      final context = PasswordFeedbackContext(
        password: 'A' * 20,
        normalizedPassword: 'A' * 20,
        strength: PasswordStrength.medium,
        entropy: 60.0,
        config: config,
      );

      final feedback = builder.buildWithContext(context);

      expect(
        feedback.suggestions,
        contains(messages.feedback.suggestion.useMoreVariety),
      );
      expect(feedback.warning, equals(messages.feedback.warning.almostThere));
    });

    group('buildWithContext - Logical Paths', () {
      test('immediate feedback for veryStrong strength', () {
        final config = PasswordGeneratorConfig.builder().build();
        final context = PasswordFeedbackContext(
          password: 'VeryStrongPassword123!@#',
          normalizedPassword: 'VeryStrongPassword123!@#',
          strength: PasswordStrength.veryStrong,
          entropy: 140.0,
          config: config,
        );
        final feedback = builder.buildWithContext(context);
        expect(feedback.strength, equals(PasswordStrength.veryStrong));
        expect(feedback.suggestions, isEmpty);
      });

      test('triggers lowercase suggestion when required but missing', () {
        final policy = PasswordPolicy(requireLowercase: true);
        final config = PasswordGeneratorConfig.builder().policy(policy).build();
        final context = PasswordFeedbackContext(
          password: 'UPPERCASE123!',
          normalizedPassword: 'UPPERCASE123!',
          strength: PasswordStrength.weak,
          entropy: 50.0,
          config: config,
        );
        final feedback = builder.buildWithContext(context);
        expect(
          feedback.suggestions,
          contains(messages.feedback.suggestion.addLowercase),
        );
      });

      test('returns multiple suggestions for multiple policy failures', () {
        final policy = PasswordPolicy(
          minLength: 20,
          requireUppercase: true,
          requireLowercase: true,
          requireNumber: true,
          requireSpecial: true,
        );
        final config = PasswordGeneratorConfig.builder().policy(policy).build();
        final context = PasswordFeedbackContext(
          password: 'abc',
          normalizedPassword: 'abc',
          strength: PasswordStrength.veryWeak,
          entropy: 10.0,
          config: config,
        );
        final feedback = builder.buildWithContext(context);
        expect(feedback.suggestions.length, greaterThan(1));
      });

      test('handles empty password with policy', () {
        final policy = PasswordPolicy(minLength: 8, requireNumber: true);
        final config = PasswordGeneratorConfig.builder().policy(policy).build();
        final context = PasswordFeedbackContext(
          password: '',
          normalizedPassword: '',
          strength: PasswordStrength.veryWeak,
          entropy: 0.0,
          config: config,
        );
        final feedback = builder.buildWithContext(context);
        expect(feedback.suggestions, isNotEmpty);
      });

      test('suggestions consistently mention missing number', () {
        final policy = PasswordPolicy(requireNumber: true);
        final config = PasswordGeneratorConfig.builder().policy(policy).build();
        final context = PasswordFeedbackContext(
          password: 'NoNumbersHere!',
          normalizedPassword: 'NoNumbersHere!',
          strength: PasswordStrength.medium,
          entropy: 70.0,
          config: config,
        );
        final feedback = builder.buildWithContext(context);
        expect(
          feedback.suggestions,
          contains(messages.feedback.suggestion.addNumber),
        );
      });
    });
  });
}
