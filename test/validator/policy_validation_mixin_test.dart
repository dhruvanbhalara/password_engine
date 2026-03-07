import 'package:password_engine/password_engine.dart';
import 'package:password_engine/src/validator/policy_validation_mixin.dart';
import 'package:test/test.dart';

class TestValidator with PolicyValidationMixin {}

void main() {
  group('PolicyValidationMixin', () {
    final validator = TestValidator();

    test('satisfiesPolicy evaluates base config even for null policy', () {
      const config = PasswordGeneratorConfig(policy: null);
      expect(validator.satisfiesPolicy('AnyValidPassword123!', config), isTrue);
      expect(validator.satisfiesPolicy('short', config), isFalse);
    });

    test('satisfiesPolicy validates minLength', () {
      const config = PasswordGeneratorConfig(
        policy: PasswordPolicy(minLength: 10),
      );
      expect(validator.satisfiesPolicy('short', config), isFalse);
      expect(validator.satisfiesPolicy('longenough', config), isTrue);
    });

    test('satisfiesPolicy validates character requirements', () {
      const config = PasswordGeneratorConfig(
        policy: PasswordPolicy(
          minLength: 5,
          requireUppercase: true,
          requireNumber: true,
        ),
      );
      expect(validator.satisfiesPolicy('abcde', config), isFalse);
      expect(validator.satisfiesPolicy('A1abc', config), isTrue);
    });

    test('satisfiesPolicy validates Unicode and Spaces', () {
      const config = PasswordGeneratorConfig(
        policy: PasswordPolicy(
          minLength: 5,
          allowUnicode: false,
          allowSpaces: false,
        ),
      );
      expect(validator.satisfiesPolicy('abc\u{1F60A}1', config), isFalse);
      expect(validator.satisfiesPolicy('abc 1', config), isFalse);
      expect(validator.satisfiesPolicy('abc12', config), isTrue);
    });

    test('satisfiesPolicy treats spaces as special when allowed', () {
      const config = PasswordGeneratorConfig(
        policy: PasswordPolicy(
          minLength: 5,
          requireSpecial: true,
          allowSpaces: true,
        ),
      );

      expect(validator.satisfiesPolicy('abc 1', config), isTrue);
    });
  });
}
