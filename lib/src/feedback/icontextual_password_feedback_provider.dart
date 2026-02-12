import '../model/password_feedback.dart';
import '../model/password_feedback_context.dart';
import 'ipassword_feedback_provider.dart';

/// Interface for feedback providers that need extra context.
abstract class IContextualPasswordFeedbackProvider
    implements IPasswordFeedbackProvider {
  PasswordFeedback buildWithContext(PasswordFeedbackContext context);
}
