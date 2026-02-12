import '../config/password_generator_config.dart';
import 'password_strength.dart';

/// Context passed to feedback providers that want more detail.
class PasswordFeedbackContext {
  const PasswordFeedbackContext({
    required this.password,
    required this.normalizedPassword,
    required this.strength,
    required this.config,
  });

  final String password;
  final String normalizedPassword;
  final PasswordStrength strength;
  final PasswordGeneratorConfig config;
}
