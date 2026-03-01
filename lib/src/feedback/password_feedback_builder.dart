import '../../l10n/messages.i18n.dart';
import '../model/password_feedback.dart';
import '../model/password_feedback_context.dart';
import '../model/password_strength.dart';
import '../utils/password_string_extensions.dart';
import 'icontextual_password_feedback_provider.dart';

/// Default feedback builder based on strength buckets.
final class PasswordFeedbackBuilder
    implements IContextualPasswordFeedbackProvider {
  PasswordFeedbackBuilder({Messages? messages})
    : _messages = messages ?? const Messages();

  final Messages _messages;

  @override
  PasswordFeedback build(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.veryWeak => PasswordFeedback(
        strength: PasswordStrength.veryWeak,
        warning: _messages.feedback.warning.tooWeak,
        suggestions: [
          _messages.feedback.suggestion.useLonger,
          _messages.feedback.suggestion.addWordPhrase,
          _messages.feedback.suggestion.mixCharacterTypes,
        ],
      ),
      PasswordStrength.weak => PasswordFeedback(
        strength: PasswordStrength.weak,
        warning: _messages.feedback.warning.weak,
        suggestions: [
          _messages.feedback.suggestion.addLengthOrWord,
          _messages.feedback.suggestion.avoidCommonPatterns,
        ],
      ),
      PasswordStrength.medium => PasswordFeedback(
        strength: PasswordStrength.medium,
        warning: _messages.feedback.warning.medium,
        suggestions: [
          _messages.feedback.suggestion.increaseLengthSlightly,
          _messages.feedback.suggestion.addWordOrSymbol,
        ],
      ),
      PasswordStrength.strong => PasswordFeedback(
        strength: PasswordStrength.strong,
      ),
      PasswordStrength.veryStrong => PasswordFeedback(
        strength: PasswordStrength.veryStrong,
      ),
    };
  }

  @override
  PasswordFeedback buildWithContext(PasswordFeedbackContext context) {
    if (context.strength.isAtLeast(PasswordStrength.strong)) {
      return _attachMetrics(build(context.strength), context);
    }

    final policy = context.config.policy;
    final password = context.normalizedPassword;
    final suggestions = <String>[];

    if (policy != null) {
      if (password.length < policy.minLength) {
        suggestions.add(
          _messages.feedback.suggestion.increaseLengthMin(policy.minLength),
        );
      }
      if (policy.requireUppercase && !password.hasUpperCase) {
        suggestions.add(_messages.feedback.suggestion.addUppercase);
      }
      if (policy.requireLowercase && !password.hasLowerCase) {
        suggestions.add(_messages.feedback.suggestion.addLowercase);
      }
      if (policy.requireNumber && !password.hasNumber) {
        suggestions.add(_messages.feedback.suggestion.addNumber);
      }
      if (policy.requireSpecial &&
          !password.hasSpecialChar &&
          !password.hasSpace) {
        suggestions.add(_messages.feedback.suggestion.addSpecial);
      }
      if (policy.scoreThreshold != null) {
        if (context.score < policy.scoreThreshold!) {
          suggestions.add(_messages.feedback.suggestion.useMoreVariety);
        }
      }
    }

    if (suggestions.isEmpty) {
      return _attachMetrics(build(context.strength), context);
    }

    final warning = switch (context.strength) {
      PasswordStrength.veryWeak => _messages.feedback.warning.policyNotMet,
      PasswordStrength.weak => _messages.feedback.warning.policyPartiallyMet,
      PasswordStrength.medium => _messages.feedback.warning.almostThere,
      _ => null,
    };

    return PasswordFeedback(
      strength: context.strength,
      warning: warning,
      suggestions: suggestions,
      estimatedEntropy: context.entropy,
      score: context.score,
    );
  }

  PasswordFeedback _attachMetrics(
    PasswordFeedback base,
    PasswordFeedbackContext context,
  ) {
    return PasswordFeedback(
      strength: base.strength,
      warning: base.warning,
      suggestions: base.suggestions,
      estimatedEntropy: context.entropy,
      score: context.score,
    );
  }
}
