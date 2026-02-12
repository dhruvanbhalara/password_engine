import 'package:password_engine/password_engine.dart';
import 'package:password_engine_zxcvbn/src/zxcvbn_strength_estimator.dart';
import 'package:test/test.dart';

void main() {
  test('maps zxcvbn scores to PasswordStrength', () {
    expect(mapScoreToStrength(-1), PasswordStrength.veryWeak);
    expect(mapScoreToStrength(0), PasswordStrength.veryWeak);
    expect(mapScoreToStrength(1), PasswordStrength.weak);
    expect(mapScoreToStrength(2), PasswordStrength.medium);
    expect(mapScoreToStrength(3), PasswordStrength.strong);
    expect(mapScoreToStrength(4), PasswordStrength.veryStrong);
    expect(mapScoreToStrength(5), PasswordStrength.veryStrong);
  });

  test('estimator returns veryWeak for empty input', () {
    final estimator = ZxcvbnStrengthEstimator();
    expect(estimator.estimatePasswordStrength(''), PasswordStrength.veryWeak);
  });

  test('estimator treats common passwords as veryWeak', () {
    final estimator = ZxcvbnStrengthEstimator();
    expect(
      estimator.estimatePasswordStrength('password'),
      PasswordStrength.veryWeak,
    );
  });
}
