import '../config/password_generator_config.dart';
import 'password_strength.dart';

/// Context passed to feedback providers for detailed evaluation.
class PasswordFeedbackContext {
  /// Creates a [PasswordFeedbackContext] with all required properties.
  const PasswordFeedbackContext({
    required this.password,
    required this.normalizedPassword,
    required this.strength,
    required this.entropy,
    required this.config,
  });

  /// The raw password as entered by the user.
  final String password;

  /// The password after normalization.
  final String normalizedPassword;

  /// The estimated strength of the password.
  final PasswordStrength strength;

  /// The estimated entropy in bits.
  final double entropy;

  /// The configuration used for generation.
  final PasswordGeneratorConfig config;

  /// A score (0–4) derived from [entropy].
  int get score => PasswordStrength.fromEntropy(entropy).index;
}
