import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

class MockBaseValidator implements IPasswordValidator {
  bool calledIsStrong = false;
  bool calledContainsUpper = false;
  bool calledContainsLower = false;
  bool calledContainsNumber = false;
  bool calledContainsSpecial = false;

  @override
  bool isStrongPassword(String password) {
    calledIsStrong = true;
    return true;
  }

  @override
  bool containsUpperCase(String password) {
    calledContainsUpper = true;
    return true;
  }

  @override
  bool containsLowerCase(String password) {
    calledContainsLower = true;
    return true;
  }

  @override
  bool containsNumber(String password) {
    calledContainsNumber = true;
    return true;
  }

  @override
  bool containsSpecialChar(String password) {
    calledContainsSpecial = true;
    return true;
  }
}

class MockConfigAwareValidator extends MockBaseValidator
    implements IConfigAwarePasswordValidator {
  bool calledIsStrongWithConfig = false;

  @override
  bool isStrongPasswordWithConfig(
    String password,
    PasswordGeneratorConfig config,
  ) {
    calledIsStrongWithConfig = true;
    return true;
  }
}

class MockNormalizer implements IPasswordNormalizer {
  @override
  String normalize(String password) => password.toLowerCase();
}

void main() {
  group('$BlocklistPasswordValidator', () {
    test('isStrongPassword rejects blocked password (default normalizer)', () {
      final validator = BlocklistPasswordValidator(
        blockedPasswords: {'password123'},
      );

      expect(validator.isStrongPassword('password123'), isFalse);
    });

    test('isStrongPassword accepts unblocked password', () {
      final mockBase = MockBaseValidator();
      final validator = BlocklistPasswordValidator(
        blockedPasswords: {'password123'},
        baseValidator: mockBase,
      );

      expect(validator.isStrongPassword('secure_password123'), isTrue);
      expect(mockBase.calledIsStrong, isTrue);
    });

    test('isStrongPasswordWithConfig rejects blocked password', () {
      final validator = BlocklistPasswordValidator(
        blockedPasswords: {'password123'},
      );
      final config = const PasswordGeneratorConfig();
      expect(
        validator.isStrongPasswordWithConfig('password123', config),
        isFalse,
      );
    });

    test(
      'isStrongPasswordWithConfig delegates to IConfigAwarePasswordValidator',
      () {
        final configAwareValidator = MockConfigAwareValidator();
        final validator = BlocklistPasswordValidator(
          blockedPasswords: {'password123'},
          baseValidator: configAwareValidator,
        );
        final config = const PasswordGeneratorConfig();

        expect(
          validator.isStrongPasswordWithConfig('good_password', config),
          isTrue,
        );
        expect(configAwareValidator.calledIsStrongWithConfig, isTrue);
      },
    );

    test(
      'isStrongPasswordWithConfig falls back to isStrongPassword for non-config aware base',
      () {
        final normalValidator = MockBaseValidator();
        final validator = BlocklistPasswordValidator(
          blockedPasswords: {'password123'},
          baseValidator: normalValidator,
        );
        final config = const PasswordGeneratorConfig();

        expect(
          validator.isStrongPasswordWithConfig('good_password', config),
          isTrue,
        );
        expect(normalValidator.calledIsStrong, isTrue);
      },
    );

    test('uses custom normalizer', () {
      final validator = BlocklistPasswordValidator(
        blockedPasswords: {'p@ssword'},
        normalizer: MockNormalizer(),
      );

      expect(validator.isStrongPassword('P@SSWORD'), isFalse);
    });

    test('delegator methods correctly forward to base validator', () {
      final mockBase = MockBaseValidator();
      final validator = BlocklistPasswordValidator(
        blockedPasswords: {},
        baseValidator: mockBase,
      );

      expect(validator.containsUpperCase('pass'), isTrue);
      expect(mockBase.calledContainsUpper, isTrue);

      expect(validator.containsLowerCase('pass'), isTrue);
      expect(mockBase.calledContainsLower, isTrue);

      expect(validator.containsNumber('pass'), isTrue);
      expect(mockBase.calledContainsNumber, isTrue);

      expect(validator.containsSpecialChar('pass'), isTrue);
      expect(mockBase.calledContainsSpecial, isTrue);
    });
  });
}
