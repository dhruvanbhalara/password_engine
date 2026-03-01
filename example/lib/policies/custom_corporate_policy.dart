import 'package:password_engine/password_engine.dart';

/// An example of a predefined, reusable corporate policy.
///
/// This demonstrates how to use the [PasswordPolicyBuilder] to construct
/// strict security requirements that can be reused across an entire organization.
class CustomCorporatePolicy {
  /// A strict policy requiring at least 16 characters, all character types,
  /// and a minimum strength of "strong".
  static PasswordPolicy get strictPolicy => PasswordPolicyBuilder()
      .minLength(16)
      .maxLength(64)
      .requireUppercase(true)
      .requireLowercase(true)
      .requireNumber(true)
      .requireSpecial(true)
      .allowSpaces(false)
      .strengthThreshold(PasswordStrength.strong)
      .build();
}
