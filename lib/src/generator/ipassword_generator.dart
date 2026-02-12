import '../model/password_feedback.dart';

/// An abstract interface for password generators.
///
/// This interface defines the contract for classes that generate passwords.
/// Implement this interface to provide custom password generation logic.
abstract class IPasswordGenerator {
  /// Generates a password based on the provided settings.
  ///
  /// The [length], [useUpperCase], [useLowerCase], [useNumbers], and
  /// [useSpecialChars] parameters allow for on-the-fly customization of the
  /// generated password. The [excludeAmbiguousChars] flag can be used to avoid
  /// characters that are easily confused (such as 'I', 'l', '1', 'O', '0'). If
  /// any of these parameters are not provided, the generator should use its
  /// default or previously configured settings.
  ///
  /// Returns a [String] representing the generated password.
  String generatePassword({
    int? length,
    bool? useUpperCase,
    bool? useLowerCase,
    bool? useNumbers,
    bool? useSpecialChars,
    bool? excludeAmbiguousChars,
  });

  /// Generates a new password, ensuring it meets strength requirements.
  ///
  /// This method is intended to be used when a new, strong password is needed,
  /// for example, when the user clicks a "refresh" button. The implementation
  /// should ensure that the generated password is valid and strong, potentially
  /// by regenerating it until it passes validation checks.
  ///
  /// Returns a [String] representing the new, strong password.
  String refreshPassword();

  /// Returns user-facing feedback for a given [password].
  PasswordFeedback estimateFeedback(String password);
}
