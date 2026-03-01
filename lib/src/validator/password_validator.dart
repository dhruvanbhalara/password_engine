import '../model/password_policy.dart';
import '../utils/password_string_extensions.dart';
import 'ipassword_validator.dart';

/// Default [IPasswordValidator] that requires 16+ characters and all four types.
class PasswordValidator implements IPasswordValidator {
  @override
  bool isStrongPassword(String password) {
    if (password.length < PasswordPolicy.defaultMinLength) return false;
    if (!password.hasUpperCase) return false;
    if (!password.hasLowerCase) return false;
    if (!password.hasNumber) return false;
    if (!password.hasSpecialChar) return false;
    return true;
  }

  @override
  bool containsUpperCase(String password) => password.hasUpperCase;

  @override
  bool containsLowerCase(String password) => password.hasLowerCase;

  @override
  bool containsNumber(String password) => password.hasNumber;

  @override
  bool containsSpecialChar(String password) => password.hasSpecialChar;
}
