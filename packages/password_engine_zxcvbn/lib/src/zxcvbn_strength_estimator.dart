import 'package:password_engine/password_engine.dart';
import 'package:zxcvbn/zxcvbn.dart';

/// Password strength estimator powered by zxcvbn.
class ZxcvbnStrengthEstimator implements IPasswordStrengthEstimator {
  /// Creates a [ZxcvbnStrengthEstimator] with optional user inputs.
  ZxcvbnStrengthEstimator({List<String> userInputs = const []})
    : _userInputs = List.unmodifiable(userInputs),
      _zxcvbn = Zxcvbn();

  final List<String> _userInputs;
  final Zxcvbn _zxcvbn;

  @override
  PasswordStrength estimatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.veryWeak;

    final result = _zxcvbn.evaluate(password, userInputs: _userInputs);
    final score = (result.score ?? 0).round().clamp(0, 4).toInt();
    return mapScoreToStrength(score);
  }
}

/// Maps a zxcvbn score to [PasswordStrength].
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
