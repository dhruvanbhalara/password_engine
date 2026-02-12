import '../model/password_feedback.dart';
import '../model/password_strength.dart';

/// Interface for building user-facing password feedback.
abstract class IPasswordFeedbackProvider {
  PasswordFeedback build(PasswordStrength strength);
}
