import '../config/password_generator_config.dart';
import '../normalizer/ipassword_normalizer.dart';
import '../normalizer/password_normalizer.dart';
import 'config_aware_password_validator.dart';
import 'iconfig_aware_password_validator.dart';
import 'ipassword_validator.dart';

/// Validator wrapper that normalizes input before delegating checks.
class NormalizedPasswordValidator implements IConfigAwarePasswordValidator {
  NormalizedPasswordValidator({
    IPasswordValidator? baseValidator,
    IPasswordNormalizer? normalizer,
  }) : _baseValidator = baseValidator ?? ConfigAwarePasswordValidator(),
       _normalizer = normalizer ?? DefaultPasswordNormalizer();

  final IPasswordValidator _baseValidator;
  final IPasswordNormalizer _normalizer;

  @override
  bool isStrongPassword(String password) {
    return _baseValidator.isStrongPassword(_normalize(password));
  }

  @override
  bool isStrongPasswordWithConfig(
    String password,
    PasswordGeneratorConfig config,
  ) {
    final normalized = _normalize(password);
    if (_baseValidator is IConfigAwarePasswordValidator) {
      return (_baseValidator).isStrongPasswordWithConfig(normalized, config);
    }
    return _baseValidator.isStrongPassword(normalized);
  }

  @override
  bool containsUpperCase(String password) {
    return _baseValidator.containsUpperCase(_normalize(password));
  }

  @override
  bool containsLowerCase(String password) {
    return _baseValidator.containsLowerCase(_normalize(password));
  }

  @override
  bool containsNumber(String password) {
    return _baseValidator.containsNumber(_normalize(password));
  }

  @override
  bool containsSpecialChar(String password) {
    return _baseValidator.containsSpecialChar(_normalize(password));
  }

  String _normalize(String password) => _normalizer.normalize(password);
}
