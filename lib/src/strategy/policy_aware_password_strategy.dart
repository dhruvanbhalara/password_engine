import '../config/password_generator_config.dart';
import 'ipassword_generation_strategy.dart';

/// Strategy wrapper that applies policy requirements to generation config.
class PolicyAwarePasswordStrategy implements IPasswordGenerationStrategy {
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

    if (policy.maxLength != null && policy.minLength > policy.maxLength!) {
      throw ArgumentError('PasswordPolicy minLength cannot exceed maxLength');
    }

    var length = config.length;
    if (length < policy.minLength) {
      length = policy.minLength;
    }
    if (policy.maxLength != null && length > policy.maxLength!) {
      length = policy.maxLength!;
    }

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
