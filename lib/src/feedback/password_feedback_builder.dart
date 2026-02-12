import '../model/password_feedback.dart';
import '../model/password_strength.dart';
import 'ipassword_feedback_provider.dart';

/// Default feedback builder based on strength buckets.
class PasswordFeedbackBuilder implements IPasswordFeedbackProvider {
  @override
  PasswordFeedback build(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return const PasswordFeedback(
          strength: PasswordStrength.veryWeak,
          warning: 'Too weak',
          suggestions: [
            'Use a longer password',
            'Add another word or phrase',
            'Mix more character types',
          ],
        );
      case PasswordStrength.weak:
        return const PasswordFeedback(
          strength: PasswordStrength.weak,
          warning: 'Weak password',
          suggestions: ['Add length or another word', 'Avoid common patterns'],
        );
      case PasswordStrength.medium:
        return const PasswordFeedback(
          strength: PasswordStrength.medium,
          warning: 'Could be stronger',
          suggestions: [
            'Increase length slightly',
            'Add another word or symbol',
          ],
        );
      case PasswordStrength.strong:
        return const PasswordFeedback(strength: PasswordStrength.strong);
      case PasswordStrength.veryStrong:
        return const PasswordFeedback(strength: PasswordStrength.veryStrong);
    }
  }
}
