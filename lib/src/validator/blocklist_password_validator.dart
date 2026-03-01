import '../config/password_generator_config.dart';
import '../normalizer/ipassword_normalizer.dart';
import '../normalizer/password_normalizer.dart';
import 'config_aware_password_validator.dart';
import 'iconfig_aware_password_validator.dart';
import 'ipassword_validator.dart';

/// Validator that rejects passwords found in a blocklist.
class BlocklistPasswordValidator implements IConfigAwarePasswordValidator {
  BlocklistPasswordValidator({
    required Set<String> blockedPasswords,
    IPasswordValidator? baseValidator,
    IPasswordNormalizer? normalizer,
  }) : _blockedPasswords = blockedPasswords,
       _baseValidator = baseValidator ?? ConfigAwarePasswordValidator(),
       _normalizer = normalizer ?? DefaultPasswordNormalizer();

  final Set<String> _blockedPasswords;
  final IPasswordValidator _baseValidator;
  final IPasswordNormalizer _normalizer;

  @override
  bool isStrongPassword(String password) {
    if (_isBlocked(password)) return false;
    return _baseValidator.isStrongPassword(password);
  }

  @override
  bool isStrongPasswordWithConfig(
    String password,
    PasswordGeneratorConfig config,
  ) {
    if (_isBlocked(password)) return false;
    if (_baseValidator is IConfigAwarePasswordValidator) {
      return (_baseValidator).isStrongPasswordWithConfig(password, config);
    }
    return _baseValidator.isStrongPassword(password);
  }

  @override
  bool containsUpperCase(String password) =>
      _baseValidator.containsUpperCase(password);

  @override
  bool containsLowerCase(String password) =>
      _baseValidator.containsLowerCase(password);

  @override
  bool containsNumber(String password) =>
      _baseValidator.containsNumber(password);

  @override
  bool containsSpecialChar(String password) =>
      _baseValidator.containsSpecialChar(password);

  bool _isBlocked(String password) {
    return _blockedPasswords.contains(_normalizer.normalize(password));
  }
}
