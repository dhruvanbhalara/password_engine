import 'password_strength.dart';

/// Declarative password policy for generators and validators.
class PasswordPolicy {
  const PasswordPolicy({
    this.minLength = 12,
    this.maxLength,
    this.requireUppercase = false,
    this.requireLowercase = false,
    this.requireNumber = false,
    this.requireSpecial = false,
    this.allowSpaces = false,
    this.allowUnicode = false,
    this.strengthThreshold,
    this.scoreThreshold,
  });

  final int minLength;
  final int? maxLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumber;
  final bool requireSpecial;
  final bool allowSpaces;
  final bool allowUnicode;
  final PasswordStrength? strengthThreshold;
  final int? scoreThreshold;

  PasswordPolicy copyWith({
    int? minLength,
    int? maxLength,
    bool? requireUppercase,
    bool? requireLowercase,
    bool? requireNumber,
    bool? requireSpecial,
    bool? allowSpaces,
    bool? allowUnicode,
    PasswordStrength? strengthThreshold,
    int? scoreThreshold,
  }) {
    return PasswordPolicy(
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
      requireUppercase: requireUppercase ?? this.requireUppercase,
      requireLowercase: requireLowercase ?? this.requireLowercase,
      requireNumber: requireNumber ?? this.requireNumber,
      requireSpecial: requireSpecial ?? this.requireSpecial,
      allowSpaces: allowSpaces ?? this.allowSpaces,
      allowUnicode: allowUnicode ?? this.allowUnicode,
      strengthThreshold: strengthThreshold ?? this.strengthThreshold,
      scoreThreshold: scoreThreshold ?? this.scoreThreshold,
    );
  }
}
