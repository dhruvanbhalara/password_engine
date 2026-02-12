import '../config/password_generator_config.dart';
import 'ipassword_validator.dart';

/// Validator contract that requires generation config context.
abstract class IConfigAwarePasswordValidator implements IPasswordValidator {
  /// Checks if the given [password] is strong for the provided [config].
  bool isStrongPasswordWithConfig(
    String password,
    PasswordGeneratorConfig config,
  );
}
