import '../config/password_generator_config.dart';
import '../utils/character_set_resolver.dart';
import 'iconfig_aware_password_validator.dart';
import 'password_validator.dart';

/// Validator that respects enabled character sets in the config.
class ConfigAwarePasswordValidator extends PasswordValidator
    implements IConfigAwarePasswordValidator {
  @override
  bool isStrongPasswordWithConfig(
    String password,
    PasswordGeneratorConfig config,
  ) {
    if (password.length < 12) return false;

    final sets = CharacterSetResolver.resolve(config);

    if (config.useUpperCase &&
        !_containsAny(password, sets[CharacterSetType.upper] ?? '')) {
      return false;
    }
    if (config.useLowerCase &&
        !_containsAny(password, sets[CharacterSetType.lower] ?? '')) {
      return false;
    }
    if (config.useNumbers &&
        !_containsAny(password, sets[CharacterSetType.number] ?? '')) {
      return false;
    }
    if (config.useSpecialChars &&
        !_containsAny(password, sets[CharacterSetType.special] ?? '')) {
      return false;
    }
    return true;
  }

  bool _containsAny(String password, String charSet) {
    for (var i = 0; i < password.length; i++) {
      if (charSet.contains(password[i])) return true;
    }
    return false;
  }
}
