import '../config/password_generator_config.dart';
import '../model/password_policy.dart';
import 'ipassword_generation_strategy.dart';

/// Strategy that applies [PasswordPolicy] constraints before delegating to a base strategy.
final class PolicyAwarePasswordStrategy implements IPasswordGenerationStrategy {
  /// Creates a [PolicyAwarePasswordStrategy] wrapping the given [baseStrategy].
  PolicyAwarePasswordStrategy({
    required IPasswordGenerationStrategy baseStrategy,
  }) : _baseStrategy = baseStrategy;

  final IPasswordGenerationStrategy _baseStrategy;

  @override
  String generate(PasswordGeneratorConfig config) {
    final effectiveConfig = _applyPolicy(config);
    return _baseStrategy.generate(effectiveConfig);
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    final effectiveConfig = _applyPolicy(config);
    _baseStrategy.validate(effectiveConfig);
  }

  PasswordGeneratorConfig _applyPolicy(PasswordGeneratorConfig config) {
    final policy = config.policy;
    if (policy == null) return config;

    final length = policy.clampLength(config.length);

    return PasswordGeneratorConfig(
      length: length,
      useUpperCase: config.useUpperCase || policy.requireUppercase,
      useLowerCase: config.useLowerCase || policy.requireLowercase,
      useNumbers: config.useNumbers || policy.requireNumber,
      useSpecialChars: config.useSpecialChars || policy.requireSpecial,
      excludeAmbiguousChars: config.excludeAmbiguousChars,
      characterSetProfile: config.characterSetProfile,
      maxGenerationAttempts: config.maxGenerationAttempts,
      policy: config.policy,
      extra: config.extra,
    );
  }
}
