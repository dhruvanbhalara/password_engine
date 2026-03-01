import '../model/character_set_profile.dart';
import '../model/password_policy.dart';
import 'password_generator_config_builder.dart';

/// Configuration for password generation.
///
/// This class holds the settings used to generate a password, such as length and character types.
class PasswordGeneratorConfig {
  /// Creates a [PasswordGeneratorConfig] with the given settings.
  const PasswordGeneratorConfig({
    this.length = 16,
    this.useUpperCase = true,
    this.useLowerCase = true,
    this.useNumbers = true,
    this.useSpecialChars = true,
    this.excludeAmbiguousChars = false,
    this.characterSetProfile = CharacterSetProfile.defaultProfile,
    this.maxGenerationAttempts = defaultMaxGenerationAttempts,
    this.policy,
    this.extra = const {},
  });

  /// Creates a [PasswordGeneratorConfig] from a map.
  factory PasswordGeneratorConfig.fromMap(Map<String, dynamic> map) {
    return PasswordGeneratorConfig(
      length: (map['length'] as num?)?.toInt() ?? 16,
      useUpperCase: map['useUpperCase'] as bool? ?? true,
      useLowerCase: map['useLowerCase'] as bool? ?? true,
      useNumbers: map['useNumbers'] as bool? ?? true,
      useSpecialChars: map['useSpecialChars'] as bool? ?? true,
      excludeAmbiguousChars: map['excludeAmbiguousChars'] as bool? ?? false,
      characterSetProfile:
          map['characterSetProfile'] != null
              ? CharacterSetProfile.fromMap(
                map['characterSetProfile'] as Map<String, dynamic>,
              )
              : CharacterSetProfile.defaultProfile,
      maxGenerationAttempts:
          (map['maxGenerationAttempts'] as num?)?.toInt() ??
          defaultMaxGenerationAttempts,
      policy:
          map['policy'] != null
              ? PasswordPolicy.fromMap(map['policy'] as Map<String, dynamic>)
              : null,
      extra: (map['extra'] as Map<String, dynamic>?) ?? const {},
    );
  }

  /// Creates a [PasswordGeneratorConfigBuilder] for fluent configuration.
  static PasswordGeneratorConfigBuilder builder() =>
      PasswordGeneratorConfigBuilder();

  /// Default maximum attempts when refreshing a password.
  static const int defaultMaxGenerationAttempts = 1000;

  /// The length of the password to generate.
  final int length;

  /// Whether to include uppercase letters in the password.
  final bool useUpperCase;

  /// Whether to include lowercase letters in the password.
  final bool useLowerCase;

  /// Whether to include numbers in the password.
  final bool useNumbers;

  /// Whether to include special characters in the password.
  final bool useSpecialChars;

  /// Whether to exclude ambiguous characters (e.g., 'I', 'l', '1', 'O', '0').
  final bool excludeAmbiguousChars;

  /// Character sets used by generation strategies.
  final CharacterSetProfile characterSetProfile;

  /// Maximum attempts when regenerating until a strong password is found.
  final int maxGenerationAttempts;

  /// Optional policy that can guide validation and UI.
  final PasswordPolicy? policy;

  /// Additional configuration parameters for custom strategies.
  final Map<String, dynamic> extra;

  /// Converts this configuration to a map.
  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'useUpperCase': useUpperCase,
      'useLowerCase': useLowerCase,
      'useNumbers': useNumbers,
      'useSpecialChars': useSpecialChars,
      'excludeAmbiguousChars': excludeAmbiguousChars,
      'characterSetProfile': characterSetProfile.toMap(),
      'maxGenerationAttempts': maxGenerationAttempts,
      'policy': policy?.toMap(),
      'extra': extra,
    };
  }
}
