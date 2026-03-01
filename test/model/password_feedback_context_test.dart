import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordFeedbackContext', () {
    test('stores all required fields correctly', () {
      final config = PasswordGeneratorConfig();
      final context = PasswordFeedbackContext(
        password: 'Secret123!',
        normalizedPassword: 'secret123!',
        strength: PasswordStrength.strong,
        entropy: 80.0,
        config: config,
      );

      expect(context.password, equals('Secret123!'));
      expect(context.normalizedPassword, equals('secret123!'));
      expect(context.strength, equals(PasswordStrength.strong));
      expect(context.entropy, equals(80.0));
      expect(context.score, equals(PasswordStrength.fromEntropy(80.0).index));
      expect(context.config, equals(config));
    });

    test('accepts empty strings for password fields', () {
      final config = PasswordGeneratorConfig();
      final context = PasswordFeedbackContext(
        password: '',
        normalizedPassword: '',
        strength: PasswordStrength.veryWeak,
        entropy: 0.0,
        config: config,
      );

      expect(context.password, isEmpty);
      expect(context.normalizedPassword, isEmpty);
      expect(context.strength, equals(PasswordStrength.veryWeak));
      expect(context.entropy, equals(0.0));
      expect(context.score, equals(0));
    });

    test('holds reference to exact config instance', () {
      final config = PasswordGeneratorConfig(length: 32);
      final context = PasswordFeedbackContext(
        password: 'p',
        normalizedPassword: 'p',
        strength: PasswordStrength.medium,
        entropy: 55.0,
        config: config,
      );

      expect(identical(context.config, config), isTrue);
    });

    test('score is derived from entropy via PasswordStrength.fromEntropy', () {
      final config = PasswordGeneratorConfig();
      final context = PasswordFeedbackContext(
        password: 'Secret123!',
        normalizedPassword: 'secret123!',
        strength: PasswordStrength.strong,
        entropy: 88.5,
        config: config,
      );

      expect(context.entropy, equals(88.5));
      expect(context.score, equals(PasswordStrength.fromEntropy(88.5).index));
    });

    test('supports distinct password and normalizedPassword values', () {
      final config = PasswordGeneratorConfig();
      final context = PasswordFeedbackContext(
        password: '  pass  ',
        normalizedPassword: 'pass',
        strength: PasswordStrength.weak,
        entropy: 40.0,
        config: config,
      );

      expect(context.password, isNot(equals(context.normalizedPassword)));
      expect(context.normalizedPassword, equals('pass'));
    });
  });
}
