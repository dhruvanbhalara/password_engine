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
    final policy = config.policy;
    final minLength = policy?.minLength ?? 12;
    if (password.length < minLength) return false;
    if (policy?.maxLength != null && password.length > policy!.maxLength!) {
      return false;
    }

    final requireUpper = policy?.requireUppercase ?? config.useUpperCase;
    final requireLower = policy?.requireLowercase ?? config.useLowerCase;
    final requireNumber = policy?.requireNumber ?? config.useNumbers;
    final requireSpecial = policy?.requireSpecial ?? config.useSpecialChars;

    final sets = CharacterSetResolver.resolve(
      config,
      useUpperCase: requireUpper,
      useLowerCase: requireLower,
      useNumbers: requireNumber,
      useSpecialChars: requireSpecial,
    );

    if (requireUpper &&
        !_containsAny(password, sets[CharacterSetType.upper] ?? '')) {
      return false;
    }
    if (requireLower &&
        !_containsAny(password, sets[CharacterSetType.lower] ?? '')) {
      return false;
    }
    if (requireNumber &&
        !_containsAny(password, sets[CharacterSetType.number] ?? '')) {
      return false;
    }
    var specialSet = sets[CharacterSetType.special] ?? '';
    if (policy?.allowSpaces == true && !specialSet.contains(' ')) {
      specialSet = '$specialSet ';
    }
    if (requireSpecial && !_containsAny(password, specialSet)) {
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
