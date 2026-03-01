# Changelog

## 1.0.0

- Initial release of `password_engine`.
- **Core Features**:
  - Flexible password generation with configurable character sets (uppercase, lowercase, numbers, special characters) and length (default to 16 characters).
  - Advanced architecture built around the Strategy pattern, allowing injection of custom generation algorithms.
  - Fluent `PasswordGeneratorConfigBuilder` for strict, safe, and immutable configuration management.
- **Security & Validation**:
  - Built-in `PasswordStrengthEstimator` using pool-based entropy estimation (`L × log₂(N)`) to evaluate password strength.
  - Pluggable `IPasswordNormalizer` interface with a passthrough default — inject a custom normalizer for Unicode normalization or whitespace handling.
  - `PasswordValidator` and `ConfigAwarePasswordValidator` to enforce rigorous rules (e.g., minimum 16 characters, 4 disjoint types).
  - Advanced `PolicyAwarePasswordStrategy` ensuring the outcome explicitly respects numeric thresholds (e.g., "at least 2 letters, 3 symbols").
- **Interactive Feedback**:
  - `estimateFeedback()` method coupled with `PasswordFeedbackContext` for UI-layer password meters and suggestions.
- **Configuration**:
  - Comprehensive `PasswordGeneratorConfig` and `CharacterSetProfile`.
  - Configurable exclusion of ambiguous characters.
