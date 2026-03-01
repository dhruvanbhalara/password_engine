import '../config/password_generator_config.dart';

/// Interface for password generation strategies.
abstract interface class IPasswordGenerationStrategy {
  /// Generates a password based on the given [config].
  String generate(PasswordGeneratorConfig config);

  /// Validates the [config] for this strategy.
  ///
  /// Throws [ArgumentError] if the configuration is invalid.
  void validate(PasswordGeneratorConfig config);
}
