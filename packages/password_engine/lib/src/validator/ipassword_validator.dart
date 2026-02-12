/// An abstract interface for password validators.
///
/// This interface defines the contract for classes that validate passwords.
/// Implement this interface to create custom password validation logic.
abstract class IPasswordValidator {
  /// Checks if the given [password] is considered strong.
  ///
  /// The definition of a "strong" password is up to the implementation.
  /// For example, an implementation might check for a minimum length, the
  /// presence of different character types (uppercase, lowercase, numbers,
  /// special characters), or other criteria.
  ///
  /// Returns `true` if the password is strong, `false` otherwise.
  bool isStrongPassword(String password);

  /// Checks if the given [password] contains at least one uppercase letter.
  ///
  /// Returns `true` if the password contains at least one uppercase letter,
  /// `false` otherwise.
  bool containsUpperCase(String password);

  /// Checks if the given [password] contains at least one lowercase letter.
  ///
  /// Returns `true` if the password contains at least one lowercase letter,
  /// `false` otherwise.
  bool containsLowerCase(String password);

  /// Checks if the given [password] contains at least one number.
  ///
  /// Returns `true` if the password contains at least one number, `false`
  /// otherwise.
  bool containsNumber(String password);

  /// Checks if the given [password] contains at least one special character.
  ///
  /// The definition of a "special character" is up to the implementation.
  ///
  /// Returns `true` if the password contains at least one special character,
  /// `false` otherwise.
  bool containsSpecialChar(String password);
}
