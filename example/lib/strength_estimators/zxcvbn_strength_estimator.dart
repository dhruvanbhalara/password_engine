import 'package:password_engine/password_engine.dart';
import 'package:zxcvbn/zxcvbn.dart';

/// Example-only zxcvbn estimator that uses the package directly.
class ExampleZxcvbnStrengthEstimator implements IPasswordStrengthEstimator {
  ExampleZxcvbnStrengthEstimator({List<String> userInputs = const []})
      : _userInputs = List.unmodifiable(userInputs),
        _zxcvbn = Zxcvbn();

  final List<String> _userInputs;
  final Zxcvbn _zxcvbn;

  @override
  PasswordStrength estimatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.veryWeak;
    final (_, score) = estimateDetailedStrength(password);
    return mapScoreToStrength(score);
  }

  @override
  (double entropy, int score) estimateDetailedStrength(String password) {
    if (password.isEmpty) return (0.0, 0);

    final result = _zxcvbn.evaluate(password, userInputs: _userInputs);
    final entropy = result.guesses_log10;
    final bits = entropy / 0.30102999566;
    final score = (result.score ?? 0).round().toInt();

    return (bits, score);
  }

  @override
  double estimateEntropy(String password, {bool allowSpaces = false}) {
    final (entropy, _) = estimateDetailedStrength(password);
    return entropy;
  }
}

/// Maps zxcvbn scores to PasswordStrength.
PasswordStrength mapScoreToStrength(int score) {
  final normalizedScore = score.clamp(0, 4).toInt();
  switch (normalizedScore) {
    case 0:
      return PasswordStrength.veryWeak;
    case 1:
      return PasswordStrength.weak;
    case 2:
      return PasswordStrength.medium;
    case 3:
      return PasswordStrength.strong;
    default:
      return PasswordStrength.veryStrong;
  }
}
