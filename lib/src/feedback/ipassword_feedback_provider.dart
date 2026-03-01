import '../model/password_feedback.dart';
import '../model/password_strength.dart';

/// Interface for building user-facing password feedback.
abstract interface class IPasswordFeedbackProvider {
  /// Builds a [PasswordFeedback] for the given [strength].
  PasswordFeedback build(PasswordStrength strength);
}
