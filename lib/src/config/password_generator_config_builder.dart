import '../model/character_set_profile.dart';
import '../model/password_policy.dart';
import 'password_generator_config.dart';

/// A builder class for [PasswordGeneratorConfig].
///
/// This provides a fluent API for creating configurations.
class PasswordGeneratorConfigBuilder {
  int _length = 16;
  bool _useUpperCase = true;
  bool _useLowerCase = true;
  bool _useNumbers = true;
  bool _useSpecialChars = true;
  bool _excludeAmbiguousChars = false;
  CharacterSetProfile _characterSetProfile = CharacterSetProfile.defaultProfile;
  int _maxGenerationAttempts =
      PasswordGeneratorConfig.defaultMaxGenerationAttempts;
  PasswordPolicy? _policy;
  Map<String, dynamic> _extra = {};

  /// Sets the length of the password.
  PasswordGeneratorConfigBuilder length(int value) {
    _length = value;
    return this;
  }

  /// Enables or disables uppercase letters.
  PasswordGeneratorConfigBuilder useUpperCase(bool value) {
    _useUpperCase = value;
    return this;
  }

  /// Enables or disables lowercase letters.
  PasswordGeneratorConfigBuilder useLowerCase(bool value) {
    _useLowerCase = value;
    return this;
  }

  /// Enables or disables numbers.
  PasswordGeneratorConfigBuilder useNumbers(bool value) {
    _useNumbers = value;
    return this;
  }

  /// Enables or disables special characters.
  PasswordGeneratorConfigBuilder useSpecialChars(bool value) {
    _useSpecialChars = value;
    return this;
  }

  /// Enables or disables ambiguous character exclusion.
  PasswordGeneratorConfigBuilder excludeAmbiguousChars(bool value) {
    _excludeAmbiguousChars = value;
    return this;
  }

  /// Sets the custom character set profile.
  PasswordGeneratorConfigBuilder characterSetProfile(
    CharacterSetProfile profile,
  ) {
    _characterSetProfile = profile;
    return this;
  }

  /// Sets the maximum generation attempts.
  PasswordGeneratorConfigBuilder maxGenerationAttempts(int value) {
    _maxGenerationAttempts = value;
    return this;
  }

  /// Sets the password policy.
  PasswordGeneratorConfigBuilder policy(PasswordPolicy? policy) {
    _policy = policy;
    return this;
  }

  /// Adds an extra configuration parameter.
  PasswordGeneratorConfigBuilder extra(String key, dynamic value) {
    _extra = Map<String, dynamic>.from(_extra)..[key] = value;
    return this;
  }

  /// Adds a map of extra configuration parameters.
  PasswordGeneratorConfigBuilder extraAll(Map<String, dynamic> extras) {
    _extra = Map<String, dynamic>.from(_extra)..addAll(extras);
    return this;
  }

  /// Builds and returns a [PasswordGeneratorConfig] instance.
  PasswordGeneratorConfig build() {
    return PasswordGeneratorConfig(
      length: _length,
      useUpperCase: _useUpperCase,
      useLowerCase: _useLowerCase,
      useNumbers: _useNumbers,
      useSpecialChars: _useSpecialChars,
      excludeAmbiguousChars: _excludeAmbiguousChars,
      characterSetProfile: _characterSetProfile,
      maxGenerationAttempts: _maxGenerationAttempts,
      policy: _policy,
      extra: _extra,
    );
  }
}
