import 'ipassword_validator.dart';

/// The default implementation of [IPasswordValidator].
///
/// This class provides a basic set of validation rules for passwords.
class PasswordValidator implements IPasswordValidator {
  /// Determines if a password is strong based on a set of rules.
  ///
  /// A password is considered strong if it meets the following criteria:
  /// - Is at least 12 characters long.
  /// - Contains at least one uppercase letter.
  /// - Contains at least one lowercase letter.
  /// - Contains at least one number.
  /// - Contains at least one special character.
  @override
  bool isStrongPassword(String password) {
    if (password.length < 12) return false;
    if (!containsUpperCase(password)) return false;
    if (!containsLowerCase(password)) return false;
    if (!containsNumber(password)) return false;
    if (!containsSpecialChar(password)) return false;
    return true;
  }

  @override
  bool containsUpperCase(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  @override
  bool containsLowerCase(String password) =>
      password.contains(RegExp(r'[a-z]'));

  @override
  bool containsNumber(String password) => password.contains(RegExp(r'[0-9]'));

  @override
  bool containsSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'));
}
