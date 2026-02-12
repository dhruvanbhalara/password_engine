# Changelog

## 1.0.0

- Initial release of `password_engine`.
- **Core Features**:
  - Flexible password generation with configurable character sets (uppercase, lowercase, numbers, special characters) and length.
  - Architecture based on Strategy pattern allowing custom generation algorithms.
- **Security & Validation**:
  - Built-in `PasswordStrengthEstimator` to evaluate password entropy and strength.
  - `PasswordValidator` to enforce strong password rules (e.g., minimum 12 characters, mixed types).
  - `refreshPassword` method to ensure generated passwords meet security criteria.
- **Configuration**:
  - Comprehensive `PasswordGeneratorConfig` for tailoring output.
  - Option to exclude ambiguous characters.
