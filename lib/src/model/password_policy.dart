import 'password_strength.dart';

/// Declarative password policy for generators and validators.
class PasswordPolicy {
  /// Creates a [PasswordPolicy] with the given constraints.
  ///
  /// Asserts that [minLength] does not exceed [maxLength] when both are set.
  const PasswordPolicy({
    this.minLength = defaultMinLength,
    this.maxLength,
    this.requireUppercase = false,
    this.requireLowercase = false,
    this.requireNumber = false,
    this.requireSpecial = false,
    this.allowSpaces = false,
    this.allowUnicode = false,
    this.strengthThreshold,
    this.scoreThreshold,
  }) : assert(
         maxLength == null || minLength <= maxLength,
         'minLength ($minLength) cannot exceed maxLength ($maxLength)',
       );

  /// Creates a [PasswordPolicy] from a map.
  factory PasswordPolicy.fromMap(Map<String, dynamic> map) {
    return PasswordPolicy(
      minLength: (map['minLength'] as num?)?.toInt() ?? defaultMinLength,
      maxLength: (map['maxLength'] as num?)?.toInt(),
      requireUppercase: map['requireUppercase'] as bool? ?? false,
      requireLowercase: map['requireLowercase'] as bool? ?? false,
      requireNumber: map['requireNumber'] as bool? ?? false,
      requireSpecial: map['requireSpecial'] as bool? ?? false,
      allowSpaces: map['allowSpaces'] as bool? ?? false,
      allowUnicode: map['allowUnicode'] as bool? ?? false,
      strengthThreshold: _parseStrengthThreshold(map['strengthThreshold']),
      scoreThreshold: (map['scoreThreshold'] as num?)?.toInt(),
    );
  }

  static PasswordStrength? _parseStrengthThreshold(dynamic value) {
    if (value is! int) return null;
    if (value < 0 || value >= PasswordStrength.values.length) return null;
    return PasswordStrength.values[value];
  }

  /// The default minimum length for a password policy.
  static const int defaultMinLength = 16;

  /// The minimum required password length.
  final int minLength;

  /// The maximum allowed password length, if any.
  final int? maxLength;

  /// Whether the password must contain uppercase letters.
  final bool requireUppercase;

  /// Whether the password must contain lowercase letters.
  final bool requireLowercase;

  /// Whether the password must contain at least one digit.
  final bool requireNumber;

  /// Whether the password must contain at least one special character.
  final bool requireSpecial;

  /// Whether spaces are permitted in the password.
  final bool allowSpaces;

  /// Whether non-ASCII Unicode characters are permitted.
  final bool allowUnicode;

  /// The minimum strength level required, if any.
  final PasswordStrength? strengthThreshold;

  /// Minimum score (0–4) required when using score-based checks.
  final int? scoreThreshold;

  /// Returns a copy of this policy with the given fields replaced.
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

  /// Returns a builder initialized with this policy's values.
  PasswordPolicyBuilder toBuilder() => PasswordPolicyBuilder(this);

  /// Returns a new empty policy builder.
  static PasswordPolicyBuilder builder() => PasswordPolicyBuilder();

  /// Converts this policy to a map.
  Map<String, dynamic> toMap() {
    return {
      'minLength': minLength,
      'maxLength': maxLength,
      'requireUppercase': requireUppercase,
      'requireLowercase': requireLowercase,
      'requireNumber': requireNumber,
      'requireSpecial': requireSpecial,
      'allowSpaces': allowSpaces,
      'allowUnicode': allowUnicode,
      'strengthThreshold': strengthThreshold?.index,
      'scoreThreshold': scoreThreshold,
    };
  }
}

/// Builder for creating and modifying [PasswordPolicy] instances.
///
/// Uses private fields with method-chaining setters, consistent with
/// [PasswordGeneratorConfigBuilder].
class PasswordPolicyBuilder {
  PasswordPolicyBuilder([PasswordPolicy? policy])
    : _minLength = policy?.minLength ?? PasswordPolicy.defaultMinLength,
      _maxLength = policy?.maxLength,
      _requireUppercase = policy?.requireUppercase ?? false,
      _requireLowercase = policy?.requireLowercase ?? false,
      _requireNumber = policy?.requireNumber ?? false,
      _requireSpecial = policy?.requireSpecial ?? false,
      _allowSpaces = policy?.allowSpaces ?? false,
      _allowUnicode = policy?.allowUnicode ?? false,
      _strengthThreshold = policy?.strengthThreshold,
      _scoreThreshold = policy?.scoreThreshold;

  int _minLength;
  int? _maxLength;
  bool _requireUppercase;
  bool _requireLowercase;
  bool _requireNumber;
  bool _requireSpecial;
  bool _allowSpaces;
  bool _allowUnicode;
  PasswordStrength? _strengthThreshold;
  int? _scoreThreshold;

  /// Sets the minimum length.
  PasswordPolicyBuilder minLength(int value) {
    _minLength = value;
    return this;
  }

  /// Sets the maximum length.
  PasswordPolicyBuilder maxLength(int? value) {
    _maxLength = value;
    return this;
  }

  /// Sets whether uppercase letters are required.
  PasswordPolicyBuilder requireUppercase(bool value) {
    _requireUppercase = value;
    return this;
  }

  /// Sets whether lowercase letters are required.
  PasswordPolicyBuilder requireLowercase(bool value) {
    _requireLowercase = value;
    return this;
  }

  /// Sets whether numbers are required.
  PasswordPolicyBuilder requireNumber(bool value) {
    _requireNumber = value;
    return this;
  }

  /// Sets whether special characters are required.
  PasswordPolicyBuilder requireSpecial(bool value) {
    _requireSpecial = value;
    return this;
  }

  /// Sets whether spaces are allowed.
  PasswordPolicyBuilder allowSpaces(bool value) {
    _allowSpaces = value;
    return this;
  }

  /// Sets whether Unicode characters are allowed.
  PasswordPolicyBuilder allowUnicode(bool value) {
    _allowUnicode = value;
    return this;
  }

  /// Sets the strength threshold.
  PasswordPolicyBuilder strengthThreshold(PasswordStrength? value) {
    _strengthThreshold = value;
    return this;
  }

  /// Sets the score threshold.
  PasswordPolicyBuilder scoreThreshold(int? value) {
    _scoreThreshold = value;
    return this;
  }

  /// Builds the [PasswordPolicy] instance.
  PasswordPolicy build() {
    return PasswordPolicy(
      minLength: _minLength,
      maxLength: _maxLength,
      requireUppercase: _requireUppercase,
      requireLowercase: _requireLowercase,
      requireNumber: _requireNumber,
      requireSpecial: _requireSpecial,
      allowSpaces: _allowSpaces,
      allowUnicode: _allowUnicode,
      strengthThreshold: _strengthThreshold,
      scoreThreshold: _scoreThreshold,
    );
  }
}

/// Extensions on [PasswordPolicy] for validation and refinement.
extension PasswordPolicyX on PasswordPolicy {
  /// Clamps the given [length] within policy bounds.
  int clampLength(int length) {
    if (length < minLength) return minLength;
    if (maxLength != null && length > maxLength!) return maxLength!;
    return length;
  }
}
