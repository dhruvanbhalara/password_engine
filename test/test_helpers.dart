import 'package:password_engine/password_engine.dart';

final RegExp specialPattern = RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]');
final RegExp specialOnlyPattern = RegExp(
  r'^[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]+$',
);
final RegExp lowerOnlyPattern = RegExp(r'^[a-z]+$');
final RegExp upperOnlyPattern = RegExp(r'^[A-Z]+$');
final RegExp alphaOnlyPattern = RegExp(r'^[A-Za-z]+$');
final RegExp numberOnlyPattern = RegExp(r'^[0-9]+$');
final RegExp numberOnlyNonAmbiguousPattern = RegExp(r'^[2-9]+$');
final RegExp numberOrSpecialPattern = RegExp(
  r'^[0-9!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]+$',
);
final RegExp lowerOnlyNonAmbiguousPattern = RegExp(
  r'^[abcdefghijkmnpqrstuvwxyz]+$',
);

String repeatChar(String char, int count) {
  return List.filled(count, char).join();
}

class WeakPasswordStrategy implements IPasswordGenerationStrategy {
  @override
  String generate(PasswordGeneratorConfig config) {
    return List.filled(config.length, 'a').join();
  }

  @override
  void validate(PasswordGeneratorConfig config) {}
}

class FixedStrengthEstimator implements IPasswordStrengthEstimator {
  @override
  PasswordStrength estimatePasswordStrength(String password) {
    return PasswordStrength.medium;
  }
}

class AlwaysTrueValidator implements IPasswordValidator {
  @override
  bool isStrongPassword(String password) => true;

  @override
  bool containsUpperCase(String password) => true;

  @override
  bool containsLowerCase(String password) => true;

  @override
  bool containsNumber(String password) => true;

  @override
  bool containsSpecialChar(String password) => true;
}

class ExactMatchEstimator implements IPasswordStrengthEstimator {
  ExactMatchEstimator(this.expected);

  final String expected;

  @override
  PasswordStrength estimatePasswordStrength(String password) {
    return password == expected
        ? PasswordStrength.strong
        : PasswordStrength.veryWeak;
  }
}

class ExactMatchValidator implements IPasswordValidator {
  ExactMatchValidator(this.expected);

  final String expected;

  @override
  bool isStrongPassword(String password) => password == expected;

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

class FunctionNormalizer implements IPasswordNormalizer {
  FunctionNormalizer(this.normalizeFn);

  final String Function(String password) normalizeFn;

  @override
  String normalize(String password) => normalizeFn(password);
}
