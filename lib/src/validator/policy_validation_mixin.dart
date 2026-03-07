import '../config/password_generator_config.dart';
import '../utils/character_set_resolver.dart';
import '../utils/password_string_extensions.dart';

/// Mixin providing common policy validation logic.
mixin PolicyValidationMixin {
  /// Checks if the [password] satisfies the constraints in [config].
  bool satisfiesPolicy(String password, PasswordGeneratorConfig config) {
    final policy = config.policy;

    final minLength = policy?.minLength ?? 16; // default min length
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
        !password.containsAnyOf(sets[CharacterSetType.upper] ?? '')) {
      return false;
    }
    if (requireLower &&
        !password.containsAnyOf(sets[CharacterSetType.lower] ?? '')) {
      return false;
    }
    if (requireNumber &&
        !password.containsAnyOf(sets[CharacterSetType.number] ?? '')) {
      return false;
    }
    if (requireSpecial) {
      var specialSet = sets[CharacterSetType.special] ?? '';
      if (policy?.allowSpaces == true && !specialSet.contains(' ')) {
        specialSet = '$specialSet ';
      }
      if (!password.containsAnyOf(specialSet)) return false;
    }

    if (policy != null) {
      if (!policy.allowUnicode && password.hasUnicode) return false;
      if (!policy.allowSpaces && password.hasSpace) return false;
    }

    return true;
  }
}
