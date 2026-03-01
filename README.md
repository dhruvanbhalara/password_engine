# Password Engine

A secure, modular, and extensible password generation library for Dart and Flutter.

## Features

- **Cryptographically Secure**: Uses `Random.secure()` for strong random number generation.
- **Modular Design**: Built with interfaces (`IPasswordGenerationStrategy`, `IPasswordStrengthEstimator`) for maximum flexibility.
- **Customizable**:
  - Configure length, character sets, and exclusion of ambiguous characters.
  - Inject custom generation strategies.
  - Inject custom strength estimators.
- **Extensible**: Easily add new strategies (e.g., memorable words, PINs) without modifying the core library.
- **Normalizer**: Pluggable `IPasswordNormalizer` interface — inject a custom normalizer for Unicode normalization or whitespace handling.
- **Validation**: Enforce minimum character counts (e.g., "must have 2 symbols") via `ConfigAwarePasswordValidator`.
- **Feedback**: Evaluate password strength with user-friendly feedback via `estimateFeedback()`.
- **Customizable Messages**: Feedback and error strings are generated from a YAML source and can be updated centrally.

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  password_engine: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:password_engine/password_engine.dart';

void main() {
  // Create a generator with default settings (RandomPasswordStrategy)
  final generator = PasswordGenerator();

  // Generate a password
  String password = generator.generatePassword(); 
  print(password); // e.g., "aB3$kL9@pQ2!"
}
```

### Custom Configuration

Use the fluent `PasswordGeneratorConfigBuilder` to create robust configs:

```dart
final config = PasswordGeneratorConfig.builder()
  .length(20)
  .useUpperCase(true)
  .useLowerCase(true)
  .useNumbers(true)
  .useSpecialChars(true)
  .excludeAmbiguousChars(true) // e.g., excludes 'I', 'l', '1', 'O', '0'
  .build();

final generator = PasswordGenerator();
generator.updateConfig(config);
String password = generator.generatePassword();
```

### Using Custom Strategies

The library supports custom generation strategies. You can implement `IPasswordGenerationStrategy` to create your own.

**Note**: The `MemorablePasswordStrategy` and `PronounceablePasswordStrategy` have been moved to the `example` app to serve as learning resources. You can copy them into your project if needed.

```dart
// Example of using a custom strategy (e.g., from the example app)
final memorableStrategy = MemorablePasswordStrategy(separator: '-');
final generator = PasswordGenerator(generationStrategy: memorableStrategy);

generator.updateConfig(PasswordGeneratorConfig(length: 4)); // 4 words
String password = generator.generatePassword(); // e.g., "correct-horse-battery-staple"
```

### Password Strength Estimation

The library includes a default entropy-based strength estimator, but you can inject your own (e.g., one based on zxcvbn).

```dart
class MyCustomStrengthEstimator implements IPasswordStrengthEstimator {
  @override
  PasswordStrength estimatePasswordStrength(String password) {
    // Your custom logic here
    return PasswordStrength.strong;
  }
}

final generator = PasswordGenerator(
  strengthEstimator: MyCustomStrengthEstimator(),
);

PasswordStrength strength = generator.estimateStrength("myPassword123");
```

### Password Feedback

Evaluate a password and receive user-facing feedback including strength, warnings, and suggestions:

```dart
final generator = PasswordGenerator();

final feedback = generator.estimateFeedback('myPassword');
print(feedback.strength.name);    // "veryWeak"
print(feedback.warning);          // "Weak password"
print(feedback.suggestions);      // ["Increase length to at least 16", ...]
```

### Customizing Messages

Feedback and error messages are generated from a YAML source file:

- Source: `lib/l10n/messages.i18n.yaml`
- Generated output: `lib/l10n/messages.i18n.dart`

This is a single-locale (English) message system. To customize messages, edit the YAML and re-run build_runner:

```bash
dart run build_runner build
```

## Configuration Options

| Parameter               | Type | Default | Description                                      |
| ----------------------- | ---- | ------- | ------------------------------------------------ |
| `length`                | int  | 16      | Password length (or word count for some strategies) |
| `useUpperCase`          | bool | true    | Include uppercase letters                        |
| `useLowerCase`          | bool | true    | Include lowercase letters                        |
| `useNumbers`            | bool | true    | Include numbers                                  |
| `useSpecialChars`       | bool | true    | Include special characters                       |
| `excludeAmbiguousChars` | bool | false   | Exclude characters like 'I', 'l', '1', 'O', '0'  |
| `extra`                 | Map  | {}      | Custom parameters for user-defined strategies    |

## Security Notes

- **CSPRNG**: Uses `Random.secure()` for all random number generation.
- **Normalizer**: The default normalizer is a passthrough. Inject a custom `IPasswordNormalizer` for Unicode normalization or whitespace handling if your application requires it.
- **Validation Threshold**: The default `PasswordValidator` enforces strictly 16+ characters and requires a mix of 4 character types.
- **Entropy**: The default strength estimator uses pool-based entropy (`L × log₂(N)`). This assumes uniform random selection and may overestimate strength for pattern-enforced passwords. Inject a custom `IPasswordStrengthEstimator` (e.g., zxcvbn-based) for more accurate estimations.

## Additional Information

- **Source Code**: [GitHub Repository](https://github.com/dhruvanbhalara/password_engine)
- **Issues**: [Issue Tracker](https://github.com/dhruvanbhalara/password_engine/issues)
- **Examples**: Check the `example` folder for a full Flutter app demonstrating custom strategies and UI integration.

## License

MIT License - see the [LICENSE](LICENSE) file for details.
