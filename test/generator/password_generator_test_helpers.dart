import 'package:password_engine/l10n/messages.i18n.dart';
import 'package:password_engine/password_engine.dart';

final RegExp lowerOnlyPattern = RegExp(r'^[a-z]+$');

class WeakPasswordStrategy implements IPasswordGenerationStrategy {
  @override
  String generate(PasswordGeneratorConfig config) {
    return List.filled(config.length, 'a').join();
  }

  @override
  void validate(PasswordGeneratorConfig config) {}
}

class FixedPasswordStrategy implements IPasswordGenerationStrategy {
  FixedPasswordStrategy(this.value);

  final String value;

  @override
  String generate(PasswordGeneratorConfig config) => value;

  @override
  void validate(PasswordGeneratorConfig config) {}
}

class FixedStrengthEstimator implements IPasswordStrengthEstimator {
  @override
  PasswordStrength estimatePasswordStrength(String password) {
    return PasswordStrength.medium;
  }

  @override
  double estimateEntropy(String password, {bool allowSpaces = false}) {
    return 65.0;
  }

  @override
  (double entropy, int score) estimateDetailedStrength(String password) {
    return (65.0, PasswordStrength.medium.index);
  }
}

class MismatchedScoreEstimator implements IPasswordStrengthEstimator {
  @override
  PasswordStrength estimatePasswordStrength(String password) {
    return PasswordStrength.weak;
  }

  @override
  double estimateEntropy(String password, {bool allowSpaces = false}) {
    return 10.0;
  }

  @override
  (double entropy, int score) estimateDetailedStrength(String password) {
    return (10.0, 4);
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
  ExactMatchEstimator(this.expected, {this.entropy = 80.0});

  final String expected;
  final double entropy;

  @override
  PasswordStrength estimatePasswordStrength(String password) {
    return password == expected
        ? PasswordStrength.strong
        : PasswordStrength.veryWeak;
  }

  @override
  double estimateEntropy(String password, {bool allowSpaces = false}) {
    return password == expected ? entropy : 20.0;
  }

  @override
  (double entropy, int score) estimateDetailedStrength(String password) {
    final e = estimateEntropy(password);
    return (e, PasswordStrength.fromEntropy(e).index);
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

class CapturingFeedbackProvider implements IContextualPasswordFeedbackProvider {
  PasswordFeedbackContext? lastContext;

  @override
  PasswordFeedback build(PasswordStrength strength) {
    return PasswordFeedback(strength: strength);
  }

  @override
  PasswordFeedback buildWithContext(PasswordFeedbackContext context) {
    lastContext = context;
    return PasswordFeedback(strength: context.strength);
  }
}

class PlainFeedbackProvider implements IPasswordFeedbackProvider {
  PasswordStrength? lastStrength;

  @override
  PasswordFeedback build(PasswordStrength strength) {
    lastStrength = strength;
    return PasswordFeedback(strength: strength);
  }
}

class ConfigAwareValidatorMock implements IConfigAwarePasswordValidator {
  bool calledWithConfig = false;

  @override
  bool isStrongPassword(String password) => false;

  @override
  bool containsUpperCase(String password) => false;

  @override
  bool containsLowerCase(String password) => false;

  @override
  bool containsNumber(String password) => false;

  @override
  bool containsSpecialChar(String password) => false;

  @override
  bool isStrongPasswordWithConfig(
    String password,
    PasswordGeneratorConfig config,
  ) {
    calledWithConfig = true;
    return false;
  }
}

class MockStrategy implements IPasswordGenerationStrategy {
  @override
  String generate(PasswordGeneratorConfig config) {
    if (config.length < 1) {
      final messages = const Messages();
      throw ArgumentError(messages.error.invalidFormat);
    }
    return List.filled(config.length, 'a').join();
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    if (config.length < 1) {
      final messages = const Messages();
      throw ArgumentError(messages.error.invalidLength);
    }
  }
}
