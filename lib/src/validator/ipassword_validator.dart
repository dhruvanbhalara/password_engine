/// Interface for password validators.
abstract interface class IPasswordValidator {
  /// Returns `true` if the [password] meets strength requirements.
  bool isStrongPassword(String password);

  /// Returns `true` if the [password] contains at least one uppercase letter.
  bool containsUpperCase(String password);

  /// Returns `true` if the [password] contains at least one lowercase letter.
  bool containsLowerCase(String password);

  /// Returns `true` if the [password] contains at least one digit.
  bool containsNumber(String password);

  /// Returns `true` if the [password] contains at least one special character.
  bool containsSpecialChar(String password);
}
