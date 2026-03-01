import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

class MockBaseValidator implements IPasswordValidator {
  String? lastCheckedPassword;

  @override
  bool isStrongPassword(String password) {
    lastCheckedPassword = password;
    return true;
  }

  @override
  bool containsUpperCase(String password) {
    lastCheckedPassword = password;
    return true;
  }

  @override
  bool containsLowerCase(String password) {
    lastCheckedPassword = password;
    return true;
  }

  @override
  bool containsNumber(String password) {
    lastCheckedPassword = password;
    return true;
  }

  @override
  bool containsSpecialChar(String password) {
    lastCheckedPassword = password;
    return true;
  }
}

class MockConfigAwareValidator extends MockBaseValidator
    implements IConfigAwarePasswordValidator {
  @override
  bool isStrongPasswordWithConfig(
    String password,
    PasswordGeneratorConfig config,
  ) {
    lastCheckedPassword = password;
    return true;
  }
}

class StaticMockNormalizer implements IPasswordNormalizer {
  @override
  String normalize(String password) => 'normalized';
}

void main() {
  group('$NormalizedPasswordValidator', () {
    test('isStrongPassword delegates normalized password', () {
      final mockBase = MockBaseValidator();
      final validator = NormalizedPasswordValidator(
        baseValidator: mockBase,
        normalizer: StaticMockNormalizer(),
      );

      validator.isStrongPassword('raw_password');
      expect(mockBase.lastCheckedPassword, equals('normalized'));
    });

    test(
      'isStrongPasswordWithConfig delegates to IConfigAwarePasswordValidator with normalized password',
      () {
        final configAwareValidator = MockConfigAwareValidator();
        final validator = NormalizedPasswordValidator(
          baseValidator: configAwareValidator,
          normalizer: StaticMockNormalizer(),
        );
        final config = const PasswordGeneratorConfig();

        validator.isStrongPasswordWithConfig('raw_password', config);
        expect(configAwareValidator.lastCheckedPassword, equals('normalized'));
      },
    );

    test(
      'isStrongPasswordWithConfig falls back to isStrongPassword for non-config aware base',
      () {
        final normalValidator = MockBaseValidator();
        final validator = NormalizedPasswordValidator(
          baseValidator: normalValidator,
          normalizer: StaticMockNormalizer(),
        );
        final config = const PasswordGeneratorConfig();

        validator.isStrongPasswordWithConfig('raw_password', config);
        expect(normalValidator.lastCheckedPassword, equals('normalized'));
      },
    );

    test('delegator methods correctly forward normalized strings', () {
      final mockBase = MockBaseValidator();
      final validator = NormalizedPasswordValidator(
        baseValidator: mockBase,
        normalizer: StaticMockNormalizer(),
      );

      validator.containsUpperCase('raw');
      expect(mockBase.lastCheckedPassword, equals('normalized'));

      validator.containsLowerCase('raw');
      expect(mockBase.lastCheckedPassword, equals('normalized'));

      validator.containsNumber('raw');
      expect(mockBase.lastCheckedPassword, equals('normalized'));

      validator.containsSpecialChar('raw');
      expect(mockBase.lastCheckedPassword, equals('normalized'));
    });

    test('default instantiation builds without error', () {
      final defaultValidator = NormalizedPasswordValidator();
      expect(defaultValidator, isNotNull);
    });
  });
}
