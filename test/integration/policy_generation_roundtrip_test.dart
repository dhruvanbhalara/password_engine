import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Integration: Policy → Config → Generate → Validate', () {
    test('generated password respects all policy constraints', () {
      final policy = PasswordPolicy(
        minLength: 20,
        maxLength: 30,
        requireUppercase: true,
        requireLowercase: true,
        requireNumber: true,
        requireSpecial: true,
      );

      final config = PasswordGeneratorConfig(length: 25, policy: policy);

      final generator = PasswordGenerator();
      generator.updateConfig(config);

      final password = generator.generatePassword();

      // Policy constraints
      expect(password.length, inInclusiveRange(20, 30));
      expect(password, contains(RegExp(r'[A-Z]')));
      expect(password, contains(RegExp(r'[a-z]')));
      expect(password, contains(RegExp(r'[0-9]')));
      expect(password, contains(RegExp(r'[!@#\$%^\&*()_+\-=\[\]{}|;:,.<>?]')));

      // Validator confirms generated password is strong
      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPasswordWithConfig(password, config), isTrue);
    });

    test('refreshPassword returns validator-approved passwords', () {
      final config = PasswordGeneratorConfig(
        length: 20,
        policy: PasswordPolicy(
          requireUppercase: true,
          requireLowercase: true,
          requireNumber: true,
          requireSpecial: true,
        ),
      );

      final generator = PasswordGenerator();
      generator.updateConfig(config);

      final password = generator.refreshPassword();
      expect(password.length, equals(20));

      final validator = ConfigAwarePasswordValidator();
      expect(validator.isStrongPasswordWithConfig(password, config), isTrue);
    });

    test('estimateFeedback round-trip with generated password', () {
      final generator = PasswordGenerator();
      final password = generator.generatePassword(length: 24);
      final feedback = generator.estimateFeedback(password);

      expect(feedback.strength, isNotNull);
      expect(
        feedback.strength.index,
        greaterThanOrEqualTo(PasswordStrength.medium.index),
      );
    });
  });
}
