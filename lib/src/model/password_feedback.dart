import 'password_strength.dart';

/// User-facing feedback for password strength results.
class PasswordFeedback {
  const PasswordFeedback({
    required this.strength,
    this.warning,
    this.suggestions = const [],
    this.estimatedEntropy,
    this.score,
  });

  final PasswordStrength strength;
  final String? warning;
  final List<String> suggestions;
  final double? estimatedEntropy;
  final int? score;
}
