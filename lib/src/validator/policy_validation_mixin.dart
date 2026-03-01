import '../config/password_generator_config.dart';
import '../utils/character_set_resolver.dart';
import '../utils/password_string_extensions.dart';

/// Mixin providing common policy validation logic.
mixin PolicyValidationMixin {
  /// Checks if the [password] satisfies the constraints in [config].
  bool satisfiesPolicy(String password, PasswordGeneratorConfig config) {
    final policy = config.policy;
    if (policy == null) return true;

    if (password.length < policy.minLength) return false;
    if (policy.maxLength != null && password.length > policy.maxLength!) {
      return false;
    }

    final sets = CharacterSetResolver.resolve(
      config,
      useUpperCase: policy.requireUppercase,
      useLowerCase: policy.requireLowercase,
      useNumbers: policy.requireNumber,
      useSpecialChars: policy.requireSpecial,
    );

    if (policy.requireUppercase &&
        !password.containsAnyOf(sets[CharacterSetType.upper] ?? '')) {
      return false;
    }
    if (policy.requireLowercase &&
        !password.containsAnyOf(sets[CharacterSetType.lower] ?? '')) {
      return false;
    }
    if (policy.requireNumber &&
        !password.containsAnyOf(sets[CharacterSetType.number] ?? '')) {
      return false;
    }
    if (policy.requireSpecial) {
      var specialSet = sets[CharacterSetType.special] ?? '';
      if (policy.allowSpaces && !specialSet.contains(' ')) {
        specialSet = '$specialSet ';
      }
      if (!password.containsAnyOf(specialSet)) return false;
    }

    if (!policy.allowUnicode && password.hasUnicode) return false;
    if (!policy.allowSpaces && password.hasSpace) return false;

    return true;
  }
}
