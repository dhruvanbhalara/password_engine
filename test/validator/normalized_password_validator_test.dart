import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

import '../test_helpers.dart';

void main() {
  group('NormalizedPasswordValidator', () {
    test('normalizes before isStrongPassword', () {
      final validator = NormalizedPasswordValidator(
        baseValidator: ExactMatchValidator('normalized'),
        normalizer: FunctionNormalizer((_) => 'normalized'),
      );

      expect(validator.isStrongPassword('raw'), isTrue);
    });

    test('normalizes before config-aware validation', () {
      final validator = NormalizedPasswordValidator(
        baseValidator: ExactMatchValidator('normalized'),
        normalizer: FunctionNormalizer((_) => 'normalized'),
      );

      expect(
        validator.isStrongPasswordWithConfig(
          'raw',
          const PasswordGeneratorConfig(),
        ),
        isTrue,
      );
    });

    test('normalizes before character checks', () {
      final validator = NormalizedPasswordValidator(
        baseValidator: PasswordValidator(),
        normalizer: FunctionNormalizer((_) => 'Aa1!'),
      );

      expect(validator.containsUpperCase('raw'), isTrue);
      expect(validator.containsLowerCase('raw'), isTrue);
      expect(validator.containsNumber('raw'), isTrue);
      expect(validator.containsSpecialChar('raw'), isTrue);
    });
  });
}
