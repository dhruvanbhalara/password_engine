import 'package:collection/collection.dart';

import 'password_strength.dart';

/// User-facing feedback for password strength results.
class PasswordFeedback {
  /// Creates a [PasswordFeedback] with the given [strength] and optional details.
  const PasswordFeedback({
    required this.strength,
    this.warning,
    this.suggestions = const [],
    this.estimatedEntropy,
    this.score,
  });

  /// Creates a [PasswordFeedback] from a map.
  factory PasswordFeedback.fromMap(Map<String, dynamic> map) {
    final strengthIndex = (map['strength'] as num?)?.toInt() ?? 0;
    return PasswordFeedback(
      strength:
          (strengthIndex >= 0 && strengthIndex < PasswordStrength.values.length)
              ? PasswordStrength.values[strengthIndex]
              : PasswordStrength.veryWeak,
      warning: map['warning'] as String?,
      suggestions: List<String>.from(map['suggestions'] as Iterable? ?? []),
      estimatedEntropy: (map['estimatedEntropy'] as num?)?.toDouble(),
      score: (map['score'] as num?)?.toInt(),
    );
  }

  /// The estimated strength of the password.
  final PasswordStrength strength;

  /// An optional warning message for weak passwords.
  final String? warning;

  /// Actionable suggestions for improving the password.
  final List<String> suggestions;

  /// The estimated entropy in bits, if available.
  final double? estimatedEntropy;

  /// A simplified score (0–4) derived from entropy, if available.
  final int? score;

  /// Converts this feedback to a map.
  Map<String, dynamic> toMap() {
    return {
      'strength': strength.index,
      'warning': warning,
      'suggestions': suggestions,
      'estimatedEntropy': estimatedEntropy,
      'score': score,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other is PasswordFeedback &&
        other.strength == strength &&
        other.warning == warning &&
        collectionEquals(other.suggestions, suggestions) &&
        other.estimatedEntropy == estimatedEntropy &&
        other.score == score;
  }

  @override
  int get hashCode {
    return strength.hashCode ^
        warning.hashCode ^
        const DeepCollectionEquality().hash(suggestions) ^
        estimatedEntropy.hashCode ^
        score.hashCode;
  }

  @override
  String toString() {
    return 'PasswordFeedback(strength: $strength, warning: $warning, suggestions: $suggestions, estimatedEntropy: $estimatedEntropy, score: $score)';
  }
}
