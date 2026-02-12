import '../config/password_generator_config.dart';

/// An abstract interface for password generation strategies.
///
/// This interface defines the contract for classes that generate passwords
/// based on a given configuration. Implement this interface to create new
/// password generation strategies, such as a random password generator, a
/// memorable password generator, or a pronounceable password generator.
abstract class IPasswordGenerationStrategy {
  /// Generates a password based on the provided [config].
  ///
  /// The [config] specifies the parameters for the password generation, such as
  /// length and character types.
  ///
  /// Returns a [String] representing the generated password.
  String generate(PasswordGeneratorConfig config);

  /// Validates the provided [config] for this strategy.
  ///
  /// Throws an [ArgumentError] if the configuration is invalid for this strategy.
  void validate(PasswordGeneratorConfig config);
}
