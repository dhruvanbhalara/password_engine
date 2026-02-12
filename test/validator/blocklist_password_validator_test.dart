import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

import '../test_helpers.dart';

void main() {
  group('BlocklistPasswordValidator', () {
    test('rejects blocked passwords', () {
      final validator = BlocklistPasswordValidator(
        blockedPasswords: {'bad'},
        baseValidator: AlwaysTrueValidator(),
      );

      expect(validator.isStrongPassword('bad'), isFalse);
      expect(validator.isStrongPassword('good'), isTrue);
    });

    test('supports normalization', () {
      final validator = BlocklistPasswordValidator(
        blockedPasswords: {'bad'},
        baseValidator: AlwaysTrueValidator(),
        normalizer: FunctionNormalizer((password) => password.toLowerCase()),
      );

      expect(validator.isStrongPassword('BAD'), isFalse);
    });
  });
}
