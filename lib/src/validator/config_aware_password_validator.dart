import '../config/password_generator_config.dart';
import '../model/password_strength.dart';
import '../strength_estimator/ipassword_strength_estimator.dart';
import '../strength_estimator/password_strength_estimator.dart';
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
