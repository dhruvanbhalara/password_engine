import '../config/password_generator_config.dart';
import '../model/password_strength.dart';
import '../strength_estimator/ipassword_strength_estimator.dart';
import '../strength_estimator/password_strength_estimator.dart';
import '../utils/character_set_resolver.dart';
import '../utils/password_string_extensions.dart';
import 'iconfig_aware_password_validator.dart';
import 'password_validator.dart';
import 'policy_validation_mixin.dart';

/// Validator that respects enabled character sets in the config.
final class ConfigAwarePasswordValidator extends PasswordValidator
    with PolicyValidationMixin
    implements IConfigAwarePasswordValidator {
  ConfigAwarePasswordValidator({IPasswordStrengthEstimator? strengthEstimator})
    : _strengthEstimator = strengthEstimator ?? PasswordStrengthEstimator();

  final IPasswordStrengthEstimator _strengthEstimator;

  @override
  bool isStrongPasswordWithConfig(
    String password,
    PasswordGeneratorConfig config,
  ) {
    if (!satisfiesPolicy(password, config)) return false;

    final policy = config.policy;
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
    var specialSet = sets[CharacterSetType.special] ?? '';
    if (policy?.allowSpaces == true && !specialSet.contains(' ')) {
      specialSet = '$specialSet ';
    }
    if (requireSpecial && !password.containsAnyOf(specialSet)) {
      return false;
    }

    if (policy?.strengthThreshold != null || policy?.scoreThreshold != null) {
      final entropy = _strengthEstimator.estimateEntropy(
        password,
        allowSpaces: policy?.allowSpaces == true,
      );
      final score = PasswordStrength.fromEntropy(entropy).index;

      if (policy?.scoreThreshold != null && score < policy!.scoreThreshold!) {
        return false;
      }
      if (policy?.strengthThreshold != null) {
        final strength = PasswordStrength.fromEntropy(entropy);
        if (!strength.isAtLeast(policy!.strengthThreshold!)) {
          return false;
        }
      }
    }
    return true;
  }
}
